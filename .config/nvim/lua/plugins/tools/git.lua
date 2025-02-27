-- git plugins

return {
	{ "sindrets/diffview.nvim" },

	-- handy git ui
	{
		"NeogitOrg/neogit",
		lazy = true,
		cmd = "Neogit",
		keys = {
			{ "<leader>gg", ":Neogit<cr>", desc = "neo[g]it" },
		},
		config = function()
			require("neogit").setup({
				disable_commit_confirmation = true,
				integrations = {
					diffview = true,
				},
			})
		end,
	},

	-- Here is a more advanced example where we pass configuration
	-- options to `gitsigns.nvim`. This is equivalent to the following Lua:
	--    require('gitsigns').setup({ ... })
	--
	-- See `:help gitsigns` to understand what the configuration keys do
	{
		{ -- Adds git related signs to the gutter, as well as utilities for managing changes
			"lewis6991/gitsigns.nvim",
			opts = {
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", bang = true })
						else
							gitsigns.nav_hunk("next")
						end
					end, { desc = "Jump to next git [c]hange" })

					map("n", "[c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							gitsigns.nav_hunk("prev")
						end
					end, { desc = "Jump to previous git [c]hange" })

					--   -- Actions
					--   -- visual mode
					--   map('v', '<leader>hs', function()
					--     gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
					--   end, { desc = 'git [s]tage hunk' })
					--   map('v', '<leader>hr', function()
					--     gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
					--   end, { desc = 'git [r]eset hunk' })
					--   -- normal mode
					--   map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
					--   map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
					--   map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
					--   map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
					--   map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
					--   map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
					--   map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
					--   map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
					--   map('n', '<leader>hD', function()
					--     gitsigns.diffthis '@'
					--   end, { desc = 'git [D]iff against last commit' })
					--   -- Toggles
					--   map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
					--   map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
				end,
			},
		},
	},

	{
		"akinsho/git-conflict.nvim",
		init = function()
			require("git-conflict").setup({
				default_mappings = false,
				disable_diagnostics = true,
			})
		end,
		keys = {
			{ "<leader>gco", ":GitConflictChooseOurs<cr>" },
			{ "<leader>gct", ":GitConflictChooseTheirs<cr>" },
			{ "<leader>gcb", ":GitConflictChooseBoth<cr>" },
			{ "<leader>gc0", ":GitConflictChooseNone<cr>" },
			{ "]x", ":GitConflictNextConflict<cr>" },
			{ "[x", ":GitConflictPrevConflict<cr>" },
		},
	},
	{
		"f-person/git-blame.nvim",
		init = function()
			require("gitblame").setup({
				enabled = false,
			})
			vim.g.gitblame_display_virtual_text = 1
			-- vim.g.gitblame_enabled = 0
		end,
	},

	{ -- github PRs and the like with gh - cli
		"pwntester/octo.nvim",
		enabled = true,
		cmd = "Octo",
		config = function()
			require("octo").setup()
			vim.keymap.set("n", "<leader>gpl", ":Octo pr list<cr>", { desc = "octo [p]r list" })
			vim.keymap.set("n", "<leader>gpr", ":Octo review start<cr>", { desc = "octo [r]eview" })
		end,
	},
}
