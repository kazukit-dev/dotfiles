# ドメインモデリング

業務のモデルを型で表し、業務の処理を状態を遷移させる関数として組み立てる方法をまとめる。
例は TypeScript で書く。

## 目次

- 型を業務の言葉で書く
- 単純な値にも型を付ける
- 状態ごとに型を分ける
- ありえない状態を型で表せなくする
- 処理は状態を遷移させる関数にする
- 業務フローを関数のパイプラインにする
- 業務上の失敗を表す
- 業務フローの出力にイベントを含める

## 型を業務の言葉で書く

型と関数の名前には、業務の担当者が使う言葉を使う。
`Data`、`Info`、`Manager`、`process` のような、何にでも当てはまる名前を避ける。
型の定義が、業務の担当者と一緒に読める仕様書になることを目指す。

## 単純な値にも型を付ける

業務上の意味を持つ値は、`string` や `number` のままにせず、意味ごとに型を付ける。
`string` のままだと、注文IDを渡すべき引数に顧客IDを渡しても型エラーにならない。

TypeScript では、ブランド型で区別する。
値を作る関数（スマートコンストラクタ）で業務上の制約を確かめ、制約を満たす値だけがその型になるようにする。

```ts
type OrderId = string & { readonly _brand: "OrderId" };
type Quantity = number & { readonly _brand: "Quantity" };

const createQuantity = (value: number): Quantity | null =>
  Number.isInteger(value) && value >= 1 && value <= 1000 ? (value as Quantity) : null;
```

こうすると、`Quantity` 型の値を受け取る関数は、1以上1000以下の整数であることを前提にでき、同じ検証を繰り返さずに済む。

## 状態ごとに型を分ける

業務で扱うものが状態によって持つ情報を変えるなら、状態ごとに別の型にし、判別用のプロパティ（`kind` など）を持つ合併型で表す。

悪い例：状態をフラグと省略可能なプロパティで表している。

```ts
type Order = {
  id: OrderId;
  lines: OrderLine[];
  isValidated: boolean;
  totalPrice?: number;
  paidAt?: Date;
};
```

この型では、「未検証なのに価格がある」「価格がないのに支払済み」といった、ありえない組み合わせが作れてしまう。
どの状態でどのプロパティが存在するのかを、コードを読む人が実装から推測するしかない。

良い例：状態ごとに型を分けている。

```ts
type UnvalidatedOrder = { kind: "unvalidated"; id: string; lines: UnvalidatedOrderLine[] };
type ValidatedOrder = { kind: "validated"; id: OrderId; lines: ValidatedOrderLine[] };
type PricedOrder = { kind: "priced"; id: OrderId; lines: PricedOrderLine[]; totalPrice: Price };
type PaidOrder = { kind: "paid"; id: OrderId; lines: PricedOrderLine[]; totalPrice: Price; paidAt: Date };

type Order = UnvalidatedOrder | ValidatedOrder | PricedOrder | PaidOrder;
```

各状態で何が確定しているかが、型の定義から読み取れる。
`PaidOrder` を受け取る関数は、価格と支払日時が必ずあることを前提にできる。

## ありえない状態を型で表せなくする

業務のルールで許されない組み合わせは、型の上で作れないようにする。
実行時の検証やコメントで禁止するより、コンパイラに守らせるほうが確実である。

例：「連絡先にはメールアドレスか住所の少なくとも一方が必要」というルール。

悪い例：両方を省略可能にしているため、どちらもない連絡先が作れる。

```ts
type ContactInfo = { email?: EmailAddress; postalAddress?: PostalAddress };
```

良い例：許される組み合わせだけを列挙している。

```ts
type ContactInfo =
  | { kind: "emailOnly"; email: EmailAddress }
  | { kind: "postalOnly"; postalAddress: PostalAddress }
  | { kind: "both"; email: EmailAddress; postalAddress: PostalAddress };
```

## 処理は状態を遷移させる関数にする

業務の処理は、ある状態の型を受け取り、次の状態の型を返す純粋関数として書く。
関数の型（シグネチャ）を先に定義すると、処理の入力と出力が業務の言葉で読める。

```ts
type PriceOrder = (order: ValidatedOrder, priceList: PriceList) => PricedOrder;

const priceOrder: PriceOrder = (order, priceList) => {
  const lines = order.lines.map((line) => priceLine(line, priceList));
  return {
    kind: "priced",
    id: order.id,
    lines,
    totalPrice: sumPrices(lines.map((line) => line.price)),
  };
};
```

- 受け取った値を書き換えず、新しい状態の値を返す
- 遷移に必要な情報（価格表、現在時刻など）は引数で受け取る
- 1つの関数は1つの遷移だけを担う。遷移の中の短い計算までは関数に分けない（SKILL.md の基本方針6）

## 業務フローを関数のパイプラインにする

業務フローは、状態を遷移させる関数をつないだパイプラインとして組み立てる。
各ステップの出力の型が、次のステップの入力の型になる。

```ts
type PlaceOrder = (input: UnvalidatedOrder, context: PlaceOrderContext) => PlaceOrderResult;

const placeOrder: PlaceOrder = (input, context) => {
  const validated = validateOrder(input, context.productCatalog);
  if (validated.kind === "invalid") return validated;

  const priced = priceOrder(validated, context.priceList);
  return { kind: "placed", order: priced, events: createEvents(priced) };
};
```

業務フローの関数も純粋関数にする。
商品カタログや価格表などの必要なデータは、I/O を担う外側の層が事前に取得して渡す（[io-and-dependencies.md](io-and-dependencies.md) を参照）。

## 業務上の失敗を表す

業務上起こりうる失敗は、業務の言葉で名前を付け、関数のシグネチャから読み取れるようにする。

```ts
type InvalidOrder = { kind: "invalid"; reasons: OrderValidationError[] };
type OrderValidationError =
  | { kind: "unknownProduct"; productCode: string }
  | { kind: "invalidQuantity"; productCode: string; quantity: number };

type ValidateOrder = (order: UnvalidatedOrder, catalog: ProductCatalog) => ValidatedOrder | InvalidOrder;
```

失敗の表し方は、プロジェクトの書き方に従う。

- 失敗を状態の1つとして合併型で返す（上の例）
- Result 型のような汎用の型で返す
- 例外を投げる

関数型の設計にとって、どれかの形式が必須なわけではない。
どの形式でも、次の点は守る。

- 起こりうる失敗の種類を業務の言葉で名前付けする
- 業務上の失敗（入力の不正、在庫不足など）と、想定外の障害（DB の停止、プログラムのバグなど）を区別する
- 呼び出し側が失敗の場合を扱い忘れないようにする。合併型なら `switch` の網羅性チェックを使う

## 業務フローの出力にイベントを含める

業務フローの結果として外部に知らせるべきこと（注文が確定した、確認メールを送るべき、など）は、イベントとして出力に含める。
メールの送信などの副作用は業務フローの中で行わず、外側の層がイベントを受け取って実行する。

```ts
type PlaceOrderEvent =
  | { kind: "orderPlaced"; orderId: OrderId; totalPrice: Price }
  | { kind: "acknowledgementRequired"; orderId: OrderId; email: EmailAddress };
```

こうすると、業務フローは純粋なまま保てる。
「注文が確定したら確認メールを送る」というルールも、出力されるイベントを確かめるだけでテストできる。
