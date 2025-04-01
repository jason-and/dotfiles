return {

	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},

	{
		"thesimonho/kanagawa-paper.nvim",
		lazy = false,
		priority = 500,
		opts = {},
	},
	{
		"alexxGmZ/e-ink.nvim",
		priority = 500,
		config = function()
			require("e-ink").setup()
			vim.cmd.colorscheme("e-ink")

			-- choose light mode or dark mode
			-- vim.opt.background = "dark"
			-- vim.opt.background = "light"
			--
			-- or do
			-- :set background=dark
			-- :set background=light
		end,
	},
}
-- vim: ts=2 sts=2 sw=2 et
