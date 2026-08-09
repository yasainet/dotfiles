# Writing Good Tests

この参照を読むとき: test を書くとき、変えるとき、mock を足すとき、test 用の後片付けや補助 method を足すとき。

## Overview

test は、特定の壊れ方を捕まえるために存在する。ここでの全ては二つの原則で決まる。

```
1. 全ての test は、捕まえる壊れ方を名指しする
2. 全ての test は、本物を動かす
```

厳格な TDD は両方を自然に生む。先に書かれ、実際の code に対して落ちるのを見た test は、既に落ちうることを証明している。そして mock は、実際の依存が遅いか外部にあると分かったときにだけ許される。

## Principle 1: Name the Break

test の本体を書く前に答えよ。production 側のどんな変更がこの test を落とすはずか。そしてその変更は bug か、それとも決定か。test が存在する価値を得るのは、誤った分岐、抜けた副作用、誤った引数、境界の場合、破れた契約を捕まえるときだ。

期待値は独立に導け。literal と手で確かめた fixture を使え。literal の `want` を並べた表形式の test が望ましい形だ。test 対象の code (やその補助) が計算した期待値は、その code が何をしようと通ってしまう。

```typescript
// ❌ Mirror assertion: the same builder computes both sides — always true
const expected = buildSearchQuery({ tag: 'urgent' });
expect(buildSearchQuery({ tag: 'urgent' })).toBe(expected);

// ✅ Hand-derived literal
expect(buildSearchQuery({ tag: 'urgent' })).toBe('tag:"urgent"');
```

変更検出器を作るな。意図した決定だけがその test を落とせるなら (定数の値、message の正確な文言、内部の構造など)、設計変更のたびに鳴り、bug の前では眠る。その決定に依存する振る舞いを test せよ。`expect(MAX_RETRIES).toBe(5)` ではなく、「失敗する呼び出しは 5 回再試行され、6 回目は起きない」だ。

文字ではなく振る舞いを。script や skill や設定が特定の行を含むという assert は、原本が原本であることしか証明しない。script は制御した入力で走らせ、出力、副作用、終了 code を assert せよ。agent に指示する文書は、それを読む agent の振る舞いで test する (superpowers:writing-skills)。人間向けの散文に test は要らない。

framework ではなく自分の code を。自分の code が境界で結ぶ契約を test せよ。登録する route、発行する query、生成する payload だ。上流の仕組みは、その保守者が test すべきものだ (典型例: 自分の router が登録済みの handler を呼ぶという assert。それは framework の test であって、あなたのものではない)。上流の振る舞いに本当に驚かされたなら、その前提を名指しする狭い特性 test を一つ書け。同じ境界は自分の code の中にも当てはまる。constructor、getter、定数、単なる転送に test が要るのは、検証、正規化、既定値、導出、強制、副作用があるときだけだ。そうでなければ、それに依存する最初の利用者から見える結果を assert せよ。

### Gate Function

```
test の本体を書く前に:
  この test を落とす production 側の変更を名指しせよ。

  名指しできない            → 観測できる振る舞いを中心に組み直せ
  「原本の文字が変わった」  → その成果物を走らせ、効果を assert せよ
  意図した決定だけが落とす  → 変更検出器だ。その決定に依存する
                              振る舞いを test せよ

  期待値が test 対象の code なしに導かれていることを確かめよ。
  対象の論理や補助を使い回しているなら:
    literal か手で確かめた fixture に置き換えよ
```

## Principle 2: Exercise the Real Thing

mock に assert する価値は無い。mock への assert は、mock があれば通り、無ければ落ちる。component について何も語らない。実際の component の振る舞いを assert せよ。確かめたいのが mock 自体なら、mock を外すか、その assert を消せ。

```typescript
// ✅ Real behavior
expect(screen.getByRole('navigation')).toBeInTheDocument();

// ❌ Mock existence
expect(screen.getByTestId('sidebar-mock')).toBeInTheDocument();
```

人間の相棒の指摘: 「これは mock の振る舞いを test していないか。」

正しい層で mock せよ。置き換える前に、実際の method の副作用を全て知れ。遅い操作や外部の操作を mock し、test が依存する部分は本物のまま残せ。迷うなら、まず実際の実装に対して test を走らせ、何が本当に起きる必要があるか観察せよ。

```typescript
// ❌ The mock swallows the config write that duplicate detection reads
vi.mock('ToolCatalog', () => ({
  discoverAndCacheTools: vi.fn().mockResolvedValue(undefined)
}));

// ✅ Mock only the slow server startup; the config write stays real
vi.mock('MCPServerManager');
```

代役は具体的に作れ。引数、呼び出し回数、順序が契約の一部なら、それを assert せよ。何でも受け取る偽物は何も確かめない。分岐ごとに (成功、error、壊れた入力) それぞれの fixture や spy を用意せよ。誤った分岐が期待を満たせなくなる。

実際の data を丸ごと写せ。現実にある通りの完全な構造を mock せよ。文書化された field を全て含めよ。test が読む field だけでは足りない。部分的な mock は、下流の code が省いた field を読むときに静かに失敗する。test は通り、統合は壊れる。

production の class は production の method だけを持つ。test だけが必要とする後片付けは test の道具に置け。production の class の `destroy()` にするな。問え。この method は test からしか呼ばれないか。この class はこの資源の一生を所有しているか。答えが否なら test の道具へ。

込み入った mock より実際の component を選べ。次のときは、実際の component を使う統合 test に切り替えよ。mock の準備が test の論理より大きくなったとき。mock に実際の component の method が欠けているとき。mock が変わると test が壊れるとき。人間の相棒の問い: 「ここで mock を使う必要があるか。」

### Gate Function

```
mock や test の補助を足す前に:
  実際の method の副作用を並べよ。test が依存するものは本物のまま残し、
  その下の遅い層や外部の層を mock せよ。

  mock の応答は、実際の構造を丸ごと写すこと。

  test からしか呼ばれない method は test の道具に置き、production に置くな。

  mock 自体に assert しようとしているか。
    mock を外すか、その assert を消せ。
```

## Tests Ship With the Implementation

TDD の周期 — 落ちる test、最小の実装、refactor — が「完了」の意味だ。その振る舞いに必要な test だけを出せ。ささいな code と人間向けの散文に test は要らない。手続きを満たすためだけに書いた test は、永久に保守の費用を食う。

## The Mutation Check

終える前に、production の code を頭の中で変異させよ。現実的な変異のそれぞれについて、少なくとも一つの test が落ちるはずだ。

- 定数や引数が誤っている
- 分岐の処理が誤っている
- 状態の変更や副作用が抜けている
- 空や既定値を返す
- 0、空、nil、権限なし、壊れた入力の検証が抜けている

どの test も捕まえない変異は、その振る舞いが守られていないか、test が同語反復である印だ。

## Quick Reference

| こんなとき | こうせよ |
|-------------|-----|
| test を書く | 捕まえる壊れ方を名指しせよ。決定ではなく bug を |
| 期待値を作る | 手で導け。test 対象の code で導くな |
| script や文書を test する | 走らせよ / 読む側に負荷を掛けよ。文字を grep するな |
| 依存の test を書きたくなる | 相手の文書化された仕組みではなく、自分の境界の契約を test せよ |
| mock した要素に assert したくなる | 実際の component を test するか、mock を外せ |
| method を mock しようとする | 副作用を知れ。遅い層や外部の層で mock せよ |
| mock の応答を作る | 実際の構造を丸ごと写せ |
| test だけが使う後片付けが要る | test の道具に置け |
| mock の準備が膨らむ | 実際の component を使う統合 test に切り替えよ |
| test file を書き終える | 変異の確認を回せ |

## Warning Signs

- 準備と assert が同じ object を共有し、等しさが保証されている
- panic、crash、selector の欠落でしか test が落ちない
- 意図した変更のたびに落ち、偶発的な破壊では落ちない
- 期待値が loop や builder や補助の陰に隠れている
- 原本の文字を grep している。消した記号が消えたままだと assert している
- framework だけが残っても、その test に意味がある
- 網羅率のためだけに存在し、副作用も結果も確かめていない
- `*-mock` の test ID を確かめる assert がある。mock を外すと落ちる
- test file からしか呼ばれない method がある
- mock の準備が test の半分を超える。なぜ mock が要るか説明できない
- 「念のため」の mock
