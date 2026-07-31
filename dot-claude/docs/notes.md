# Notes

ドキュメントの置き場所を規定する

## 置き場所

- repo 単体で完結する内容は、その repo の `docs/*.md` に書け
- 複数 repo にまたがる内容は、`~/ghq/github.com/yasainet/notes/` に書け

## Rules

判断基準は一つ。その repo を消したとき、ドキュメントも一緒に消えていいか

- 消えていいなら `docs/`、困るなら `notes/`
- 迷ったら `docs/` に書け。横断だと分かった時点で `notes/` へ移せばよい
- `notes/` には対象 repo 名を書け。repo 名から `rg` で辿れる状態を保て
