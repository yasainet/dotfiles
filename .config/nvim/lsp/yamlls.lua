return {
	cmd = { "yaml-language-server", "--stdio" },
	-- yaml.docker-compose は docker_compose_language_service に任せる
	filetypes = { "yaml" },
	root_markers = { ".git" },
	settings = {
		yaml = {
			-- 整形は conform (prettierd) が担うため LSP 側は無効化する
			format = { enable = false },
		},
	},
}
