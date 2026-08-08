---
name: simplepowers-record
description: 記録 phase。レビューを通した後、commit や PR を残すときに使え
---

# 記録

冒頭で `[Record]` と宣言せよ。

## 入口

レビューを通したか確認せよ。通していないなら `simplepowers-review` へ戻れ。

## 使うもの

| やること        | 使うもの                          | 呼ぶ人 |
| --------------- | --------------------------------- | ------ |
| commit          | `/commit-commands:commit`         | 自分   |
| push と PR まで | `/commit-commands:commit-push-pr` | 自分   |
| release tag     | `/git-bump`                       | `user` |
| 積み残し        | `/git-issue`                      | `user` |

`user` の欄は自分では呼べない。実行を依頼せよ。

## 書き方

commit する前に `~/.claude/docs/github.md` を読め。type、scope、body の規約がある。

## 出口

commit の hash と変更規模を報告せよ。push していないなら、していないと言え。
