---
paths:
  - "**/queries/*.ts"
---

# queries Rules

queries を実装する前に、この規範を理解してから書け。
ESLint (`@yasainet/eslint`) が最終保証だが、error message をすり抜けるための実装はするな。
error が出たら「意図」に寄せて直せ。規約の裏をかいて黙らせるな。

queries は features の最薄層。I/O を 1 回叩き `safe` で `{ data, error }` に畳むだけに徹せよ。

## 位置

- 呼ばれる: services から（entries は queries を直接 import するな、service 経由）
- 呼ぶ: `lib/*`（lib は queries からのみ import 可）
- 1 query = I/O 1 回 + `safe`。分岐も合成もしない

## 禁止構文

- try-catch 禁止。error は `{ data, error }` で返す
- if 禁止。条件分岐は services に置く
- loop 禁止。反復は services に置く（queries は薄い CRUD ラッパー）
- throw 禁止。Supabase の `{ data, error }` をそのまま返す
- logger 禁止（entries 以外）。ログ出力は entries に集約
- `@/` パスの動的 import 禁止。内部依存は `queries/<prefix>.ts` を作る（外部 npm の cold-start 遅延 import のみ可）

> [!NOTE]
> queries を薄く・分岐なしに保つのは、error 経路を 1 本に保つため。
> `safe` が `error: unknown` のまま畳むので診断情報を失わない。
> queries で if / throw を始めると error 経路が二重化し、追えなくなる。
> 分岐が要るなら、それは services の仕事。

## Supabase `.select()`

- 空 `.select()` 禁止（全列を暗黙取得する）
- `.select("*")` 禁止（スキーマ拡張時に列を暗黙露出する）
- template literal 禁止（型推論を壊す）
- 引数は文字列リテラルか `*_COLUMNS` 定数にする
- 列定数は `_COLUMNS` で終わる UPPER_SNAKE_CASE、`"col1,col2" as const`

> [!NOTE]
> `as const` を外すと `.select()` の型推論が壊れる。配列 / template literal も不可。
> 列を明示するのは、スキーマ拡張時に列が暗黙で露出 / 取得されるのを防ぐため。

## 返り値

- export 関数の返り値に `any` を残すな（public な層は型を確定させる）
- mapping（snake/camel 変換）は queries でやるな。service 境界で行う
