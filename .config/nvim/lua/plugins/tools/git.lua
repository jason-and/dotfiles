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

	-- Git signs in the gutter and enhanced Git commands
	{
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

				-- Actions - organize under <leader>g prefix for Git
				-- Visual mode
				map("v", "<leader>gs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Git [s]tage hunk" })

				map("v", "<leader>gr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Git [r]eset hunk" })

				-- Normal mode
				map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Git [s]tage hunk" })
				map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Git [r]eset hunk" })
				map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Git [S]tage buffer" })
				map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Git [u]ndo stage hunk" })
				map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Git [R]eset buffer" })
				map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Git [p]review hunk" })
				map("n", "<leader>gb", gitsigns.blame_line, { desc = "Git [b]lame line" })
				map("n", "<leader>gd", gitsigns.diffthis, { desc = "Git [d]iff against index" })
				map("n", "<leader>gD", function()
					gitsigns.diffthis("~")
				end, { desc = "Git [D]iff against last commit" })

				-- Toggles
				map("n", "<leader>gtb", gitsigns.toggle_current_line_blame, { desc = "Toggle git show [b]lame line" })
				map("n", "<leader>gtd", gitsigns.toggle_deleted, { desc = "Toggle git show [d]eleted" })
			end,
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
			{ "<leader>gco", ":GitConflictChooseOurs<cr>", desc = "Git conflict: choose [o]urs" },
			{ "<leader>gct", ":GitConflictChooseTheirs<cr>", desc = "Git conflict: choose [t]heirs" },
			{ "<leader>gcb", ":GitConflictChooseBoth<cr>", desc = "Git conflict: choose [b]oth" },
			{ "<leader>gc0", ":GitConflictChooseNone<cr>", desc = "Git conflict: choose [0] none" },
			{ "]x", ":GitConflictNextConflict<cr>", desc = "Next conflict" },
			{ "[x", ":GitConflictPrevConflict<cr>", desc = "Previous conflict" },
		},
	},

	{
		"f-person/git-blame.nvim",
		init = function()
			require("gitblame").setup({
				enabled = false,
			})
			vim.g.gitblame_display_virtual_text = 1
		end,
		keys = {
			{ "<leader>gbb", ":GitBlameToggle<cr>", desc = "Git blame toggle virtual text" },
			{ "<leader>gbc", ":GitBlameCopyCommitURL<cr>", desc = "Git blame [c]opy" },
			{ "<leader>gbo", ":GitBlameOpenCommitURL<cr>", desc = "Git blame [o]pen" },
		},
	},

	{ -- github PRs and the like with gh-cli
		"pwntester/octo.nvim",
		enabled = true,
		cmd = "Octo",
		config = function()
			require("octo").setup()
			vim.keymap.set("n", "<leader>gpl", ":Octo pr list<cr>", { desc = "Octo [p]r list" })
			vim.keymap.set("n", "<leader>gpr", ":Octo review start<cr>", { desc = "Octo [r]eview" })
		end,
	},
}
