return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		highlight = {
			comments_only = false, -- match outside of comments (for markdown callouts)
			pattern = {
				[[.*<(KEYWORDS)\s*:]], -- default: TODO:
				[=[.*>\s*\[!(KEYWORDS)\]]=], -- obsidian: > [!TODO]
			},
		},
		search = {
			pattern = [=[\b(KEYWORDS):|>\s*\[!(KEYWORDS)\]]=], -- both patterns
		},
	},
}
