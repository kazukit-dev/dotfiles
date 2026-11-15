# 原因の特定

症状の場所から原因の場所へ遡る考え方と、パッチとの違いを例で示す。
例は TypeScript で書く。

## 目次

- 症状の場所と原因の場所
- どこまで遡るか
- 例：メールアドレスの重複判定
- 例：合計金額の端数
- 同じ原因を持つ箇所の探し方

## 症状の場所と原因の場所

| | 症状の場所 | 原因の場所 |
|---|---|---|
| 意味 | 誤った結果が観察された箇所 | 間違った前提や欠けている規則がある箇所 |
| そこを直すと | 報告されたケースだけが直る | 同じ原因から生まれる症状がまとめて直る |
| 見つけ方 | エラーや誤った値が出た行を見る | その値がどこで作られ、どの規則で決まったかを遡る |

遡るときは、誤った値が「どこで作られたか」を問う。
使われる場所で値を補正するのではなく、作られる場所で正しい値にする。

## どこまで遡るか

遡るのは、そのルールを持つべき場所に着いたところで止める。

- 外部からの入力の扱いなら、入力を業務の型に変換する場所（リクエストの検証、スマートコンストラクタなど）
- 業務の規則なら、その規則を定める関数やモジュール
- 複数の箇所で使われる計算なら、その計算を持つ共通の関数

「そもそも設計が悪い」まで遡ると、修正が依頼の範囲を大きく超える。
設計の問題に気づいたら、修正はルールを持つべき場所で止め、設計の問題は別件として報告する。

## 例：メールアドレスの重複判定

報告：「A@example.com で登録済みの人が a@example.com でもう一度登録できてしまった」
仕様：「メールアドレスは大文字・小文字を区別せずに重複を判定する。前後の空白は無視する」

```ts
export const isRegistered = (members: Member[], email: string): boolean =>
  members.some((member) => member.email === email.trim());

export const register = (members: Member[], email: string): RegisterResult =>
  isRegistered(members, email)
    ? { kind: "alreadyRegistered" }
    : { kind: "registered", members: [...members, { email: email.trim() }] };
```

パッチ：症状の場所（比較）で補正している。

```ts
export const isRegistered = (members: Member[], email: string): boolean =>
  members.some((member) => member.email.toLowerCase() === email.trim().toLowerCase());
```

報告されたケースは直るが、保存されるメールアドレスは正規化されないままである。
メールアドレスで会員を検索する処理、一意制約、別の重複チェックなど、同じ値を比較する箇所ごとに同じ補正が要る。
1か所でも補正を忘れると、同じバグがまた現れる。

- 症状の場所：`isRegistered` の比較
- 原因の場所：入力のメールアドレスを正規化する規則がない（空白の除去だけが `register` と `isRegistered` に散らばっている）

根本の修正：正規化の規則を1か所に置き、正規化した値だけを比較・保存する。

```ts
export const normalizeEmail = (email: string): string => email.trim().toLowerCase();

export const isRegistered = (members: Member[], email: string): boolean =>
  members.some((member) => member.email === normalizeEmail(email));

export const register = (members: Member[], email: string): RegisterResult =>
  isRegistered(members, email)
    ? { kind: "alreadyRegistered" }
    : { kind: "registered", members: [...members, { email: normalizeEmail(email) }] };
```

ただし、保存済みの会員に大文字を含むメールアドレスがあれば、この修正だけでは重複を見逃す。
保存済みのデータの修正が必要になるので、手順6に当たる。ユーザーに選択肢を示す。

- 根本の修正：上の修正に加えて、保存済みのメールアドレスを正規化するデータの移行を行う
- 当面の修正：比較のときだけ両側を正規化する（パッチの形）。保存される値の不統一が残ることを明記する

## 例：合計金額の端数

報告：「明細の合計と請求額が1円ずれる」

パッチ：請求額を計算する箇所で、差額を足して合わせる。

```ts
const invoiceTotal = sumLines(lines) + (displayedTotal - sumLines(lines));
```

症状の場所で辻褄を合わせているだけで、なぜずれるのかが分からないままである。

遡ると、明細ごとに税額を四捨五入する画面と、合計に対して税額を計算する請求処理とで、端数処理の規則が二重に存在していた。
原因の場所は「税額の端数処理の規則が1か所にない」ことであり、規則を1つの関数にまとめて両方から使うのが根本の修正になる。
どちらの規則が正しいかが仕様から読み取れないなら、推測で選ばずに質問する。

## 同じ原因を持つ箇所の探し方

原因の場所が分かったら、次の観点で検索する。

- 同じ値（メールアドレス、金額、日時など）を比較・検索・保存している箇所
- 同じ計算や変換を複製している箇所（同じ式、同じ正規表現、同じ定数）
- 原因の関数や型を使っている箇所（呼び出し元、参照元）
- 同じ外部入力を受け取る別の入口（API、バッチ、管理画面など）

見つけた箇所ごとに、今回の修正で直るか、直らないなら再現テストを追加するか、範囲外として別件にするかを決め、報告に書く。
