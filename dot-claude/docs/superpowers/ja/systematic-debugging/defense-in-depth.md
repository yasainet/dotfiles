# Defense-in-Depth Validation

## Overview

不正な data が原因の bug を直すとき、一箇所に検証を足せば十分に思える。しかしその一つの確認は、別の経路、refactoring、mock によって迂回されうる。

核となる原則: data が通る層の全てで検証せよ。その bug を構造的に不可能にせよ。

## Why Multiple Layers

一つの検証: 「bug を直した」
複数の層: 「bug を不可能にした」

層ごとに捕まえるものが違う。
- 入口の検証がほとんどの bug を捕まえる
- 業務の論理が境界の場合を捕まえる
- 環境の番人が、文脈に固有の危険を防ぐ
- debug の log が、他の層が破れたときに助けになる

## The Four Layers

### Layer 1: Entry Point Validation
目的: API の境界で、明らかに不正な入力を拒む

```typescript
function createProject(name: string, workingDirectory: string) {
  if (!workingDirectory || workingDirectory.trim() === '') {
    throw new Error('workingDirectory cannot be empty');
  }
  if (!existsSync(workingDirectory)) {
    throw new Error(`workingDirectory does not exist: ${workingDirectory}`);
  }
  if (!statSync(workingDirectory).isDirectory()) {
    throw new Error(`workingDirectory is not a directory: ${workingDirectory}`);
  }
  // ... proceed
}
```

### Layer 2: Business Logic Validation
目的: その操作にとって data が筋の通ったものか確かめる

```typescript
function initializeWorkspace(projectDir: string, sessionId: string) {
  if (!projectDir) {
    throw new Error('projectDir required for workspace initialization');
  }
  // ... proceed
}
```

### Layer 3: Environment Guards
目的: 特定の文脈で危険な操作を防ぐ

```typescript
async function gitInit(directory: string) {
  // In tests, refuse git init outside temp directories
  if (process.env.NODE_ENV === 'test') {
    const normalized = normalize(resolve(directory));
    const tmpDir = normalize(resolve(tmpdir()));

    if (!normalized.startsWith(tmpDir)) {
      throw new Error(
        `Refusing git init outside temp dir during tests: ${directory}`
      );
    }
  }
  // ... proceed
}
```

### Layer 4: Debug Instrumentation
目的: 後の解析のために文脈を残す

```typescript
async function gitInit(directory: string) {
  const stack = new Error().stack;
  logger.debug('About to git init', {
    directory,
    cwd: process.cwd(),
    stack,
  });
  // ... proceed
}
```

## Applying the Pattern

bug を見つけたら:

1. data の流れを辿れ — 誤った値はどこで生まれ、どこで使われるか
2. 通過点を全て並べよ — data が通る点を全て挙げる
3. 層ごとに検証を足せ — 入口、業務、環境、debug
4. 層ごとに試せ — layer 1 を迂回してみて、layer 2 が捕まえることを確かめる

## Example from Session

bug: 空の `projectDir` が原因で、source code の中で `git init` が走った

data の流れ:
1. test の準備 → 空文字列
2. `Project.create(name, '')`
3. `WorkspaceManager.createWorkspace('')`
4. `git init` が `process.cwd()` で走る

足した 4 層:
- Layer 1: `Project.create()` が、空でない/存在する/書き込める、を検証
- Layer 2: `WorkspaceManager` が projectDir が空でないことを検証
- Layer 3: `WorktreeManager` が test 中の tmpdir の外での git init を拒む
- Layer 4: git init の前に stack trace を log

結果: 1847 件の test が全て通り、bug は再現できなくなった

## Key Insight

4 層とも必要だった。試す中で、それぞれの層が他の層が見落とした bug を捕まえた。
- 別の経路が入口の検証を迂回した
- mock が業務の論理の確認を迂回した
- platform ごとの境界の場合には、環境の番人が要った
- debug の log が、構造的な誤用を明らかにした

検証を一箇所で止めるな。全ての層で確かめよ。
