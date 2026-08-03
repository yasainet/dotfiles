# Claude Code
#
# ccr: 現在の repo で開いた session を fzf から選んで resume する。
# 本体は herdr の popup keybind (prefix+ctrl+r) から呼ぶ script。
# ここは herdr の外、素の端末から使うための入口。

alias ccr="$HOME/.config/herdr/scripts/claude-resume.sh"

# ccf: `@filename` に渡すパスを fzf で選ぶ。
# 本体は herdr の popup keybind (prefix+ctrl+f) から呼ぶ script。
alias ccf="$HOME/.config/herdr/scripts/claude-mention.sh"
