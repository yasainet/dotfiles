# dot-pi

pi の設定を dotfiles 管理下に置く。

## Summary

- pi 本体は mba2026 で動く。設定、web 取得、file 操作はすべてこちら
- LLM は mbp2023 の llama.cpp。Tailscale 経由で叩く
- `~/.pi/` 配下は dotfiles への symlink

## Architecture

```text
mba2026            mbp2023
  pi ── Tailscale ── llama.cpp
        (:8080)      Qwen3.8-Flash-Next (context 262144)
```
