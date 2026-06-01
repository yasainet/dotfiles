---
paths:
  - "**/*.spec.ts"
---

# e2e test Rules

e2e test を書く前に、この規範を理解してから書け。
ESLint / test-audit (`@yasainet/eslint`) が最終保証だが、error message をすり抜けるための実装はするな。
error が出たら「意図」に寄せて直せ。規約の裏をかいて黙らせるな。

e2e は entry（配線）を本物の依存越しに 1 本通すことに徹せよ。網羅は unit の仕事。

## 位置

- 置く: `tests/e2e/**/*.spec.ts`
- 対象: 1 entry（server action / route handler）= 1 e2e（存在は audit が監査する）
- 網羅しない: 分岐・境界値は unit（utils / schemas）へ押し込め

## 禁止

- CSS selector への結合禁止。`getByRole` / accessible name で取れ（実装の class に依存するな）
- snapshot 禁止。DOM 全体の写経になり、仕様破壊に気づけなくなる
- 網羅の持ち込み禁止。バリデーション全パターン等を e2e で回すな（遅く脆い → unit へ）

## 期待値

- 期待値はユーザーに見える振る舞い（表示 / 遷移 / HTTP status / header）に置け
- happy path を主に、代表的な失敗を 1〜2 本（無効入力 / not-found）添えよ

> [!NOTE]
> e2e が守るのは「配線された全体が本物で動くこと」。
> 速く脆い e2e に網羅を持ち込むと、テストピラミッドが逆立ちし、CI が遅く壊れやすくなる。
> 網羅は unit、疎通は e2e と役割を分けよ。
