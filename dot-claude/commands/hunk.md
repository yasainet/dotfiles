---
description: herdr タブに hunk diff HEAD --watch を spawn
---

現在フォーカスされている herdr workspace に新規タブを作り、`hunk diff HEAD --watch` を起動する。

以下を Bash で実行:

```
bash ~/ghq/github.com/yasainet/dotfiles/dot-claude/scripts/spawn-hunk-tab.sh
```

成功した場合はスクリプトの出力 (pane id と base sha) をそのまま報告。エラーが出た場合は stderr の内容をそのまま伝える。
