# Workflow

phase に応じた agent, skill を利用し、workflow を制御する。

## 原則

- `調査`, `設計`, `実装`, `検証`, `レビュー` の phase に区切って進めよ
- `user` から `skip` の指示や軽微な修正の場合は phase を skip して進めよ

## 1. 調査

次のいずれかを満たすときだけ `@Explore` を呼べ。

- 対象ファイルが不明で、探索範囲が repo 全体 / 他の repo に及ぶ
- 命名規則が複数あり、横断的に洗い出す必要がある

3 ファイル以内で済むと見込めるなら呼ぶな

探索の当てが付かず、試行錯誤が要るなら `@general-purpose` を使え。`@Explore` は読み取り専用で、途中の書き換えができない

library の仕様は記憶で答えるな。context7 で最新のドキュメントを引き、ウェブ検索をせよ。

## 2. 設計

実装後に覆せない選択を含むときだけ `@Plan` を呼べ。案を並べるな

## 3. 実装

DB schema を変えたなら `/supabase-migrate` で migration と型定義を通せ

## 4. 検証

test で足りるなら test を走らせろ

app の挙動を目で見る必要があるときだけ `/run` を使え

## 5. レビュー

既定は `/code-review`

- 認証や外部入力を触ったなら `/security-review` を足せ
- bug ではなく整理が目的なら `/simplify` を使え
- GitHub の PR が対象なら `/review` を使え

## 記録

phase の外。レビューを通してから残す

- commit は `/commit-commands:commit`
- push と PR まで通すなら `/commit-commands:commit-push-pr`
- release tag は `/git-bump`
- 積み残しは `/git-issue` で issue にせよ
