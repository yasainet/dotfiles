return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		explorer = { enabled = true },
		picker =  {enabled = true ,
    sources = {
      explorer = {hidden = true},
      files = {hidden = true}
    }
  }
	},
}
