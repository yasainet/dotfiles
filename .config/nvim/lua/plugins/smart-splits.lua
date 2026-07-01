return {
	"mrjones2014/smart-splits.nvim",
	lazy = false,
	-- herdr 運用: mux バックエンドは無い（smart-splits は tmux/wezterm/zellij/kitty のみ）。
	-- 役割分離: C-h/j/k/l は nvim 内分割専用、herdr ペイン間移動は prefix+h/j/k/l（focus_pane_*）。
	-- at_edge="stop" で端では nvim 側を動かさず、pane 越境は herdr 側 prefix ナビに委譲する。
	opts = {
		at_edge = "stop",
	},
}
