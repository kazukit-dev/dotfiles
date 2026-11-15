# DAMP（Descriptive And Meaningful Phrases）

テストコードでは、DRY（Don't Repeat Yourself）を過度に適用せず、**テストの意図や検証内容が明確であること**を優先する。

安易な共通化によって、テストの前提条件や期待値が隠れると、テストケースを読むだけでは何を検証しているのか理解しにくくなる。

そのため、DAMPの考え方に基づき、**検証に関係する入力値、実行する操作、期待値は、原則として各テストケース内に明示する。** 可読性を保つためであれば、多少のコードの重複は許容する。

DAMPはDRYを否定するものではなく、補完する考え方である。重複を減らすこと自体を目的とせず、テストの理解しやすさを基準に共通化を判断する。

この方針は、ユニットテストだけでなく、結合テストやE2Eテストなど、テストの種類を問わず適用する。

## 目次

- 検証処理の共通化
- テストデータとセットアップの共通化
- テスト対象の操作
- テストダブルの戻り値
- コード例
- 共通化の判断基準

## 検証処理の共通化

検証処理（assertion）のヘルパー化は原則として避ける。

検証処理を共通化すると、具体的な検証対象や期待値が隠れ、テストケースから何を保証しているのか把握しにくくなる。

そのため、**検証対象のプロパティや期待値は、原則として各テストケース内に直接記述する。**

ただし、単一の明確な概念を検証する処理であり、共通化によってテストの意図がより分かりやすくなる場合は例外として許容する。

特に、複雑な検証ロジックが必要な場合は、適切な名前を持つヘルパーに切り出すことで、可読性が向上することがある。

## テストデータとセットアップの共通化

テストデータの生成やセットアップ処理は、検証の意図を損なわない範囲で共通化してよい。

ただし、**検証結果に影響する重要な条件は、共通化された処理の内部に隠さず、テストケース内に明示する。**

例えば、テストデータの生成にファクトリ関数を使用する場合、検証に必要なプロパティは明示的に指定する。

```ts
test("管理者は記事を削除できる", () => {
  const user = createUser({
    role: "admin",
  });

  const result = canDeleteArticle(user);

  assert.equal(result, true);
});
```

この例では、検証に重要な `role: "admin"` が明示されているため、その他のプロパティを共通化してもテストの意図は損なわれない。

一方、ファクトリ関数のデフォルト値に検証結果が依存する場合は、その値もテストケース内に指定する。

DBの初期化やテスト環境の構築など、検証内容に直接関係しない処理は共通化してよい。

## テスト対象の操作

検証対象となる操作は、原則としてテストケース内に明示する。

操作をヘルパー化すると、何を実行しているのか分かりにくくなり、テスト対象の振る舞いを把握するために実装を確認する必要が生じる。

ただし、結合テストやE2Eテストでは、テストの前提状態を作るために複数の操作が必要になることがある。

そのような場合は、検証対象ではない操作を共通化してよい。例えば、認証済みの状態を作るためのログイン処理や、テストデータを登録するためのAPI呼び出しなどが該当する。

重要なのは、**検証対象の操作と、そのための準備処理を区別すること**である。

## テストダブルの戻り値

テストダブルは極力使わない（[test-doubles.md](test-doubles.md) を参照）。

使う場合も、**検証結果に影響する戻り値は、テストケース内で明示する。**

共通のセットアップでモックに既定の応答を持たせると、テストの結果がその既定値に依存していることがテストケースから読み取れなくなる。

```ts
test("為替APIが応答しないときは前回のレートで換算する", async () => {
  const exchangeApi = { fetchRate: mock.fn(async () => { throw new ExchangeApiUnavailableError(); }) };
  const lastKnownRates = { USD: 150 };

  const result = await convertToJpy({ amount: 10, currency: "USD" }, { exchangeApi, lastKnownRates });

  assert.equal(result, 1500);
});
```

この例では、検証の前提である「APIが応答しない」ことと「前回のレート」がテストケース内に書かれているため、期待値 `1500` の根拠が読み取れる。

## コード例

### 悪い例1：入力値を共通化している

```ts
import { test } from "node:test";
import assert from "node:assert/strict";
import { calculateDiscount } from "./discount.js";

const defaultInput = {
  price: 1000,
  discountRate: 0.1,
  premiumDiscountRate: 0.1,
  isPremium: false,
};

test("通常会員には通常の割引率だけを適用する", () => {
  const result = calculateDiscount(defaultInput);

  assert.equal(result, 900);
});

test("プレミアム会員にはプレミアム割引率を上乗せして適用する", () => {
  const result = calculateDiscount({ ...defaultInput, isPremium: true });

  assert.equal(result, 800);
});
```

この例では、検証に関係する価格や割引率が `defaultInput` に隠れている。

テストケースだけでは期待値 `900` や `800` がどの値から導かれるのか分からず、ファイルの上部にある定義を確認する必要がある。また、`defaultInput` を別のテストのために変更すると、無関係なテストが壊れる。

### 悪い例2：検証処理を共通化している

```ts
const assertDiscount = (input: DiscountInput, expected: number) => {
  assert.equal(calculateDiscount(input), expected);
};

test("通常会員には通常の割引率だけを適用する", () => {
  assertDiscount({ price: 1000, discountRate: 0.1, premiumDiscountRate: 0.1, isPremium: false }, 900);
});
```

この例では、入力値と期待値は書かれているが、テスト対象の操作と検証がヘルパーに隠れている。

テストケースを読むだけでは、何を呼び出して何と比較しているのかが分からない。この程度の処理であれば、ヘルパーにする利点はない。

### 良い例：入力値と期待値を明示している

```ts
import { test } from "node:test";
import assert from "node:assert/strict";
import { calculateDiscount } from "./discount.js";

test("通常会員には通常の割引率だけを適用する", () => {
  const result = calculateDiscount({
    price: 1000,
    discountRate: 0.1,
    premiumDiscountRate: 0.1,
    isPremium: false,
  });

  assert.equal(result, 900);
});

test("プレミアム会員にはプレミアム割引率を上乗せして適用する", () => {
  const result = calculateDiscount({
    price: 1000,
    discountRate: 0.1,
    premiumDiscountRate: 0.1,
    isPremium: true,
  });

  assert.equal(result, 800);
});
```

この例では、テストケースごとに入力値、実行する操作、期待値が明示されている。

コードの重複はあるものの、各テストケースを読むだけで、どのような条件で何を期待しているのか理解できる。

## 共通化の判断基準

|対象|方針|
|---|---|
|検証に関係する入力値|原則として明示する|
|期待値|原則として明示する|
|検証処理（assertion）|原則として共通化しない|
|検証対象の操作|原則として明示する|
|テストダブルの戻り値|検証に関係する値は明示する|
|テストデータの生成|検証に無関係な部分は共通化してよい|
|セットアップ・クリーンアップ|検証条件を隠さない範囲で共通化してよい|
|E2Eなどの前提操作|検証対象でなければ共通化してよい|

## まとめ

テストコードでは、重複を減らすこと自体を目的としない。

**テストケースを読んだだけで、どのような条件で、何を実行し、どのような結果を期待しているのか理解できること**を優先する。

共通化によってテストの意図が分かりにくくなるのであれば、重複を残すことを選ぶ。

一方、検証に関係しない処理の共通化によって、重要な条件や振る舞いがより明確になる場合は、積極的に活用してよい。

参考：_Software Engineering at Google_, Chapter 12 — Tests and Code Sharing: DAMP, Not DRY
