---
paths:
  - "**/lib/**/*.ts"
---

# lib Rules

`src/lib/**/*.ts` を実装する前に、この規範を理解してから書け。
ESLint (`@yasainet/eslint`) が最終保証だが、error message をすり抜けるための実装はするな。
error が出たら「意図」に寄せて直せ。規約の裏をかいて黙らせるな。

lib は 1 つの外部サービスにつき 1 ディレクトリを持つ。
責務は外部世界 (プロセスの外) とアプリ内部をつなぐ薄い境界に徹すること。

## 境界の判断

実装対象がどの層に属するかを、まず次の問いで決めよ。

- 外部に触れるか (SDK / HTTP / CLI / env) → lib `index.ts`
- 触れず、その外部に固有な純粋変換か → lib `utils.ts`
- 外部 1 回を `{ data, error }` に畳むか → features `queries`
- 分岐・合成・複数 I/O があるか → features `services`
- 外部にも層にも固有でない汎用な純粋物か → `src/utils`

判断が lib でないなら、lib には書くな。features / utils へ回せ。

## 依存方向

依存は features → lib の一方向。lib は features を import するな。

- lib は app 内部 (`@/features` 等) を import 不可。外部 SDK と `@/lib/**` のみ依存可。
- `lib/**/utils.ts` は純粋ヘルパー。`client` / `index` を import 不可、`@/lib/**/types` のみ可。
- lib は queries からのみ呼ばれる (`lib/**/utils.ts` の純粋ヘルパーは全層から可)。

## やること / やらないこと

やること。

- transport: SDK 呼び出し / fetch / execFile
- client 初期化 (credential の注入)
- その外部に固有な純粋変換 (例: `getR2PublicUrl`)

やらないこと。

- `{ data, error }` への変換 → queries が `safe` で行う
- business logic / 複数 operation の合成 → services の責務
- features の import → lib は最下層

## ディレクトリ構造

```text
lib/<service>/
  index.ts    transport (SDK / fetch / execFile) と client 初期化
  utils.ts    その外部に固有な純粋ヘルパー (副作用なし)
  types.ts    その外部の型
```

## 外部の型と検証

型の正典がどこにあるかで起こし方を変えよ。

- 公式型パッケージ / ドキュメントがある → 契約として import せよ
- CLI / 観測でしか分からない → 手で起こせ

観測ベースの型は不完全さを型に刻め。

- 未知のキーは `[key: string]: unknown` で存在を表明せよ
- 生データは `raw` で保持し後から追えるようにせよ

lib 境界で「検証する」か「キャストで信じる」かを決めよ。

- 構造 (配列 / discriminant) は検証せよ
- 壊れたら致命的な load-bearing field だけ narrow に検証せよ
- 全 schema の検証は新フィールドへの寛容さを殺すので避けよ
- 型に乗らない契約は transport で吸収せよ

> [!NOTE]
> 型は構造しか表せず、振る舞いの制約は表せない。
> 例として tweet_id は Number の安全整数を超える。
> JSON.parse の前に文字列化しないと ID が壊れる (quoteBigIntIds)。
> こうした制約は型でなく実際に叩いた観測からしか得られない。

## error の扱い

lib は error を解釈せず throw せよ (lib に try-catch / `{ data, error }` 変換を持たせるな)。

- queries の `safe` が `error: unknown` のまま畳むため診断情報を失わない
- 意味付け (分岐) は分岐が必要な features の責務とする
- 分岐が要るときは lib が型ガードを提供し、features はそれを使う
  - 例: `isAbortExtraction(error)` で gallery-dl の中断を判定し features 側で FxEmbed へ fallback する

throw する独自エラーは class にせよ (`instanceof` 区別と stack trace のため)。

- 独自フィールドは実際に読む場合のみ持たせよ (例: `GalleryDlError.code`)
- 診断情報は独自フィールドでなく標準 `Error` の `cause` に載せよ

> [!NOTE]
> 汎用な純粋物 (`safe` / `Result` / `toErrorMessage`) はどの外部にも固有でない。
> よって lib ではなく `src/utils` に置く。
> 「特定の外部に固有か / 全外部横断で汎用か」が lib と utils を分ける軸。

## env の置き場所

client 初期化に必要な credential のみ lib に置け。

- operation の引数になる設定値 (bucket 名 / webhook URL 等) は features `constants` に置け
- env = API_KEY ではなく、client を作る秘匿情報だけが lib の関心

> [!NOTE]
> `!` (non-null assertion) は「未設定だったら落ちるべきか」で判断する。
> 落ちるべき (credential / 必須 config) なら `!` をつける。
> 未設定が正常運転 (例: extractor の動作モード切替) なら `!` を禁じる。
