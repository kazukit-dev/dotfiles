# I/O と依存の扱い

I/O を処理の端に寄せる方法と、依存をカリー化で注入する方法をまとめる。

## 目次

- 純粋な中心と、I/O を担う端
- 外部からの入力は端で型に変換する
- 基本の形：取得 → 純粋な処理 → 保存
- 端に寄せきれないとき：サンドイッチ
- 判断を値として返す
- 時刻・乱数・環境変数の取り方
- 依存をカリー化で注入する
- 依存を組み立てる場所
- 避ける書き方

## 純粋な中心と、I/O を担う端

アプリケーションを、純粋な中心と、I/O を担う端の2つに分ける。

| 部分 | 担うこと | テスト |
|---|---|---|
| 純粋な中心 | 業務のルール、状態の遷移、計算、判断 | 出力値ベーステスト（速く、大量に書ける） |
| I/O を担う端 | DB・外部API・ファイルの読み書き、時刻の取得、ログ、中心の呼び出し | インテグレーションテスト（少数） |

中心は端のことを知らない。
端は中心を呼び出すが、判断はほとんど持たない。
業務のルールはすべて中心に置き、端はできるだけ薄くする。

## 外部からの入力は端で型に変換する

HTTP のリクエストや DB の行のような外部からの値は、端で業務の型（ブランド型や状態ごとの型）に変換してから、純粋な中心に渡す。
変換に失敗したら、端で業務上の失敗として返す。
中心は、検証済みの型だけを受け取る前提で書ける。

変換そのものも純粋関数として書き、業務のルールを書くモジュールとは分けて置く。端はそれを呼ぶだけにする。

## 基本の形：取得 → 純粋な処理 → 保存

多くの処理は、次の3段に分けられる。

1. **取得（I/O）**: 判断に必要なデータをすべて集める
2. **純粋な処理**: 集めたデータから結果を計算する
3. **保存（I/O）**: 結果を保存したり、外部に送ったりする

```ts
const placeOrderHandler =
  (deps: { findProducts: FindProducts; findPriceList: FindPriceList; saveOrder: SaveOrder; publishEvents: PublishEvents }) =>
  async (input: UnvalidatedOrder): Promise<PlaceOrderResult> => {
    const productCatalog = await deps.findProducts(input.lines.map((line) => line.productCode));
    const priceList = await deps.findPriceList();

    const result = placeOrder(input, { productCatalog, priceList });

    if (result.kind === "placed") {
      await deps.saveOrder(result.order);
      await deps.publishEvents(result.events);
    }
    return result;
  };
```

`placeOrder` は純粋関数なので、DB も外部APIもなしでテストできる。
`placeOrderHandler` には判断がほとんどないので、インテグレーションテストは少数で済む。

## 端に寄せきれないとき：サンドイッチ

純粋な処理の結果を見てから、次に何を取得するかが決まることがある。
その場合は、I/O と純粋な処理を交互に並べる。

```ts
const transferPointsHandler =
  (deps: { findMember: FindMember; findCampaign: FindCampaign; saveMembers: SaveMembers }) =>
  async (input: TransferPointsInput): Promise<TransferResult> => {
    const sender = await deps.findMember(input.senderId);
    const receiver = await deps.findMember(input.receiverId);

    const transfer = planTransfer(sender, receiver, input.points);
    if (transfer.kind === "rejected") return transfer;

    const campaign = await deps.findCampaign(transfer.campaignCode);

    const completed = applyCampaignBonus(transfer, campaign);
    await deps.saveMembers([completed.sender, completed.receiver]);
    return completed;
  };
```

このときも、次を守る。

- 判断はすべて純粋関数（`planTransfer`、`applyCampaignBonus`）に置き、端には I/O と純粋関数の呼び出しだけを書く
- 純粋関数の中から I/O を呼び出さない
- 層を何段も重ねない。段が増えるなら、先にまとめて取得できないかを検討する

サンドイッチにするか、最初にまとめて取得するかは、次の基準で選ぶ。

- 後の取得が、前の判断の結果に依存しない（何を取得するかが最初から決まっている）なら、多少無駄な取得になっても最初にまとめて取得し、基本の3段にする
- 後の取得が、前の取得で得た値（ID など）だけに依存するなら、まず1回の取得にまとめられないか（JOIN、まとめての取得）を検討する
- 何を取得するかが前の判断の結果で決まる場合や、取得が重く、判断の結果によっては不要になる場合は、サンドイッチにする

絞り込みや集計を DB のクエリで行うか、取得後の純粋関数で行うかも、同じ考え方で決める。
業務のルールは純粋関数に置くのを基本とし、データ量や性能の理由があるときだけクエリに移す。
履歴やログのように、時間とともに件数が際限なく増えるデータは、最初からクエリで絞り込む。
クエリに移す場合も、条件の境界（期限の日時など）を計算する部分は純粋関数にしておく。

### 取得から保存までの間の整合性

「取得 → 判断 → 保存」の間に、別の処理が同じデータを変えることがある（同じクーポンへの同時の適用など）。
純粋関数の判断だけでは、この競合は防げない。
業務の不変条件は、端の側で保存先に守らせる。

- DB の一意制約や条件付きの更新、トランザクションで、不変条件を破る保存を拒否させる
- 制約違反は端で受け取り、業務上の失敗（「使用済み」など）として結果に変換する。想定外の障害として扱わない
- 事前の取得と純粋関数による判定は、そのまま通常の経路として残す。制約は競合したときのための備えであり、どちらの経路でも同じ業務上の失敗を返す

## 判断を値として返す

「条件によって、メールを送るか、送らないか」のように、I/O を行うかどうかの判断がある場合は、純粋関数がその判断を値として返し、端がそれに従って I/O を実行する。

```ts
type Notification =
  | { kind: "none" }
  | { kind: "email"; to: EmailAddress; template: "order-confirmed" | "order-delayed" };

const decideNotification = (order: PricedOrder, customer: Customer): Notification =>
  customer.contactInfo.kind === "postalOnly"
    ? { kind: "none" }
    : { kind: "email", to: customer.contactInfo.email, template: "order-confirmed" };
```

判断が純粋関数の中にあるので、送るかどうかと宛先・文面の選び方を、出力値ベーステストで検証できる。
端は、`kind` に応じて送信を実行するだけになる。

```ts
const createSendNotification =
  (sendMail: SendMail) =>
  async (notification: Notification): Promise<void> => {
    if (notification.kind === "none") return;
    await sendMail(notification.to, notification.template);
  };
```

## 時刻・乱数・環境変数の取り方

純粋関数は、現在時刻・乱数・環境変数を引数で受け取る。
それらを取得するのは端の役目である。

端の関数では、現在時刻などを依存として受け取り（`now: () => Date`）、処理の最初に1回だけ取得して、純粋関数に値として渡す。
エントリポイントで `() => new Date()` を渡し、インテグレーションテストでは固定の時刻を返す関数を渡す。

```ts
const applyCouponHandler =
  (deps: { findCoupon: FindCoupon; saveCouponUsage: SaveCouponUsage; now: () => Date }) =>
  async (request: ApplyCouponRequest): Promise<ApplyCouponResult> => {
    const now = deps.now();
    const coupon = await deps.findCoupon(request.couponCode);

    const result = applyCoupon(request, { coupon, now });

    if (result.kind === "applied") await deps.saveCouponUsage(result.usage);
    return result;
  };
```

1回の処理の中で何度も `deps.now()` を呼ばない。
呼ぶたびに値が変わり、同じ処理の中で判断の前提がずれる。

## 依存をカリー化で注入する

I/O を行う関数は、依存を先に受け取り、業務の入力を後から受け取るカリー化した関数にする。

```ts
type FindMember = (id: MemberId) => Promise<Member | null>;

const createFindMember =
  (db: Db): FindMember =>
  async (id) => {
    const row = await db.queryOne<MemberRow>("select * from members where id = $1", [id]);
    return row ? toMember(row) : null;
  };
```

- **依存は関数の型で表す。** `FindMember` のように、必要な操作だけを関数の型として定義する。DB のクライアント全体を渡さない
- **依存が複数あるときは、オブジェクトにまとめて最初の引数で受け取ってよい。** 1つずつカリー化すると、呼び出しが読みにくくなる
- **純粋関数には依存を渡さない。** 純粋関数が受け取るのは、取得済みの値だけにする。純粋関数が依存を受け取っているなら、I/O が中心に紛れ込んでいる

## 依存を組み立てる場所

依存は、アプリケーションの起動時（エントリポイント）の1か所でまとめて渡す。

```ts
const db = createDb(process.env.DATABASE_URL);

const placeOrder = placeOrderHandler({
  findProducts: createFindProducts(db),
  findPriceList: createFindPriceList(db),
  saveOrder: createSaveOrder(db),
  publishEvents: createPublishEvents(messageBus),
});

app.post("/orders", async (req, res) => res.json(await placeOrder(req.body)));
```

依存の組み立てが1か所に集まっていると、どの処理が何に依存しているかを見渡せる。
インテグレーションテストでも同じ組み立て方で本物の依存を渡せる。

## 避ける書き方

関数型で書くプロジェクトでの指針である。クラスを中心とするプロジェクトでは、SKILL.md の「適用の範囲」に従う。

| 避ける書き方 | 理由 | 代わりに |
|---|---|---|
| 関数の中で DB や API のクライアントを直接 import して使う | 依存が隠れ、差し替えも見通しも悪くなる | 依存をカリー化で受け取る |
| モジュールのトップレベルで状態を持つ（シングルトン、可変のキャッシュ） | 呼び出しの順序で結果が変わり、テストどうしが干渉する | 状態は引数で受け取り、新しい値を返す |
| 純粋関数の中で `new Date()`、`Math.random()`、`process.env` を参照する | 同じ入力でも結果が変わる | 端で取得し、引数で渡す |
| クラスと DI コンテナで依存を注入する | このスキルの方針（関数とカリー化）と書き方が混ざる | カリー化した関数を、エントリポイントで組み立てる |
| 端の関数に業務の判断を書く | 判断を検証するためにインテグレーションテストが増える | 判断を純粋関数に移し、端は呼び出すだけにする |
