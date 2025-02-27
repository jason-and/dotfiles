return {
	{ -- Add indentation guides even on blank lines
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			indent = {
				char = "│", -- This is a slightly different character than the default |
				tab_char = "│",
			},
			scope = { enabled = true },
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
			},
		},
		config = function(_, opts)
			-- Disable the listchars for tabs and trailing spaces since we're using indent guides
			vim.opt.list = true
			vim.opt.listchars = {
				nbsp = "␣", -- Keep non-breaking space visible
				trail = "·", -- Keep trailing spaces visible but subtle
				tab = "  ", -- Hide tab markers (indent-blankline will show these)
			}

			require("ibl").setup(opts)

			-- Add a command to toggle indent guides
			vim.api.nvim_create_user_command("IndentToggle", function()
				local ibl_state = require("ibl.state")
				if ibl_state.enabled then
					require("ibl").setup_buffer(0, { enabled = false })
				else
					require("ibl").setup_buffer(0, { enabled = true })
				end
			end, { desc = "Toggle indent guides" })

			-- Add a keymap to toggle indent guides
			vim.keymap.set("n", "<leader>ti", ":IndentToggle<CR>", { desc = "[T]oggle [I]ndent guides" })
		end,
	},
}
