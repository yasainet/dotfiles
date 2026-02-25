return {
	"MagicDuck/grug-far.nvim",
	config = function()
		require("grug-far").setup({
			engines = {
				ripgrep = {
					extraArgs = "--hidden",
				},
			},
		})
	end,
}
