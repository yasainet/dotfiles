---
paths:
  - "**/services/*.ts"
---

# services Rules

services を実装する前に、この規範を理解してから書け。
ESLint (`@yasainet/eslint`) が最終保証だが、error message をすり抜けるための実装はするな。
error が出たら「意図」に寄せて直せ。規約の裏をかいて黙らせるな。

services は features の orchestration 層。分岐・合成・複数 I/O をまとめるのが責務。

## 位置

- 呼ばれる: entries から（原則 1:1）。`shared/services/*` は横断副作用（通知等）の例外
- 呼ぶ: 同一 feature の queries。他 feature の service / queries は直接 import するな
- error 処理はしない（entries の catch に集約する）

## 禁止構文

- try-catch 禁止。error 処理は entries に集約する
- throw 禁止。失敗は値で返す:
  - `T | null` / `{ data, error }` / 空デフォルト のいずれか
  - lib の native 例外は entry の catch に自動伝播する（services で握るな）
- logger 禁止（entries 以外）。ログ出力は entries に集約
- `@/` パスの動的 import 禁止。内部依存は `services/<prefix>.ts` を作る（外部 npm の cold-start 遅延 import のみ可）

## dead fallback の禁止

- error message の dead fallback を書くな。この分岐に来た時点で error は既知 — error をそのまま返す
- nullable error の dead fallback を書くな。`if (error)` で判定し error をそのまま返す

> [!NOTE]
> error 処理を entries に集約するのは、ログ・通知・HTTP 変換を 1 箇所に集めるため。
> services が try-catch すると集約が崩れ、同じ error が二重処理される。
> 「失敗を値で返す」だけに徹し、意味付けは entries に委ねよ。

## 責務

- 分岐・合成・複数 query の orchestration はここに置く
- mapping（snake/camel 変換）は services でのみ行う（service 境界で DB ⇄ app を変換）
- export 関数の返り値に `any` を残すな（public な層は型を確定させる）

> [!NOTE]
> 失敗の表現はケースで選ぶ。
> `T | null` は単純な不在、`{ data, error }` は呼び出し側が error を見たいとき、
> 空デフォルト（空配列等）は失敗を正常系に畳んでよいとき。
