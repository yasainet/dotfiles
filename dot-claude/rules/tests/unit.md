---
paths:
  - "**/*.test.ts"
---

# unit test Rules

unit test を書く前に、この規範を理解してから書け。
ESLint / test-audit (`@yasainet/eslint`) が最終保証だが、error message をすり抜けるための実装はするな。
error が出たら「意図」に寄せて直せ。規約の裏をかいて黙らせるな。

unit は pure layer（utils / schemas）の 入力 → 出力を仕様から網羅することに徹せよ。

## 位置

- 置く: utils / schemas の兄弟 `*.test.ts`（test-audit が存在を強制する）
- 置かない: services / queries / entries（配線層。mock の echo になる → e2e に委ねる）
- 純粋でないロジック（env / I/O 依存）は utils へ抽出してから unit する

## 禁止

- 配線層の import 禁止。services / queries / entries を import するな（mock の echo になる）
- mock 禁止。mock が要る時点で対象が pure でない。pure を抽出してそちらを test せよ
- snapshot 禁止。実装追従の写経になり、仕様破壊に気づけなくなる

## 期待値

- 期待値は実装をなぞるな、仕様から導け（JSDoc / constants / schema の意図）
- 1 関数 = 境界値を網羅せよ（null / 空 / 上限 / 異常系）
- AAA（Arrange / Act / Assert）で 1 test 1 振る舞いに保て

> [!NOTE]
> 実装を写したテストは、実装を直すと一緒に直り、仕様破壊を検知できない。
> テストが守るのは「仕様（あるべき振る舞い）」であって「現在の実装」ではない。
> 期待値の出どころは常にコードの外（仕様）に置け。
