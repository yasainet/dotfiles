return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		signs = false,
		highlight = {
			comments_only = false,
			pattern = {
				[[.*<(KEYWORDS)\s*:]],
				[=[.*>\s*\[!TODO\]]=], -- `> [!TODO]`
				[[.*Todo]], -- `Todo`
			},
		},
		search = {
			pattern = [=[\b(KEYWORDS):|>\s*\[!TODO\]]=],
		},
	},
}
