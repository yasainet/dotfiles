# IME Reset

herdr の pane 移動時に macOS の入力ソースを ABC へ強制リセットしていた仕組みを記録する。
`.config/herdr/scripts/nvim-nav.sh` から退避した。

## 退避した理由

日本語入力モードでは `C-hjkl` による移動が発火しないと考えていた。
優先度が低くクリティカルでもないため、navigation の実装から切り離した。

## 退避後に分かったこと

退避した結果、日本語入力モードでも `C-hjkl` の移動ができるようになった。
つまりこのコードは不要だっただけでなく、回避しようとしていた問題そのものを引き起こしていた。

原因は未検証だが、`macism` による入力ソース切り替えが原因である可能性が高い。
切り替えは非同期に実行され、実測で ~40ms かかる。
キー転送との競合が起きていたと考えられる。

復活させる場合は、この点を先に検証すること。

## 退避したコード

```sh
# ペイン移動は ABC 起点 (操作イベントでの IME 強制リセット)
# 同期実行すると実測 ~40ms がペイン移動レイテンシに乗るためバックグラウンド化
if [ -x /opt/homebrew/bin/macism ]; then
	/opt/homebrew/bin/macism com.apple.keylayout.ABC >/dev/null 2>&1 &
fi
```

`macism` は Homebrew でインストールする外部依存である。

## 層の問題

このコードは navigation script の中にあった。
しかし「移動したら入力ソースをリセットする」は navigation とは独立した横断的関心事である。
script に置く限り、pane 移動と nvim へのキー転送のどちらで効かせたいのかを構造的に表現できない。

## 復活させる場合

まず herdr 本体の設定を検討する。
`.config/herdr/config.toml` に `switch_ascii_input_source_in_prefix` があり、現在は `false` である。
prefix 操作に限れば herdr 本体で同等のことができる。

herdr 本体で足りない場合に限り、外部コマンドの呼び出しを検討する。
その際も navigation script ではなく、独立した層に置くこと。
