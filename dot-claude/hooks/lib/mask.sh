# PreToolUse(Bash) hook 共通。コマンド文字列の quote 内と heredoc 本体を潰す
#
# grep 'pkill' や commit message 中の 'rm -rf' をコマンドと誤認しないため。
# 潰した先は X で埋め、位置がずれないよう長さは保つ

mask() {
  awk '
    BEGIN { hd = ""; sq = "\047"; dq = "\042"
            hdre = "<<-?[[:space:]]*[" sq dq "]?[A-Za-z_][A-Za-z0-9_]*[" sq dq "]?" }
    {
      line = $0
      if (hd != "") { if (line == hd || line == hd ";") hd = ""; print ""; next }
      probe = line; gsub(/<<</, "@@@", probe)
      if (match(probe, hdre)) {
        d = substr(probe, RSTART, RLENGTH)
        gsub("^<<-?[[:space:]]*[" sq dq "]?|[" sq dq "]$", "", d); hd = d
      }
      out = ""; q = ""
      for (i = 1; i <= length(line); i++) {
        c = substr(line, i, 1)
        if (q == "") {
          if (c == sq || c == dq) { q = c; out = out "X" } else out = out c
        } else {
          if (c == q) q = ""
          out = out "X"
        }
      }
      print out
    }
  '
}
