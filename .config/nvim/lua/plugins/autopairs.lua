return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		local npairs = require("nvim-autopairs")
		local Rule = require("nvim-autopairs.rule")
		local cond = require("nvim-autopairs.conds")

		npairs.setup({
			check_ts = true,
			ts_config = {
				lua = { "string" },
				javascript = { "string", "template_string" },
			},
		})

		npairs.add_rules({
			Rule("```", "```", "text"):with_pair(cond.not_before_char("`", 3)),
		})
	end,
}
