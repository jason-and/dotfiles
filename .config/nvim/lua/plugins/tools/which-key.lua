-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `opts` key (recommended), the configuration runs
-- after the plugin has been loaded as `require(MODULE).setup(opts)`.

return {
	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		opts = {
			-- delay between pressing a key and opening which-key (milliseconds)
			-- this setting is independent of vim.opt.timeoutlen
			delay = 0,
			icons = {
				-- set icon mappings to true if you have a Nerd Font
				mappings = vim.g.have_nerd_font,
				-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
				-- default which-key.nvim defined Nerd Font icons, otherwise define a string table
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},

			-- Document all groups
			spec = {
				-- Development tools
				{ "<leader>c", group = "[C]ode / [C]ell / [C]hunk", mode = { "n", "x" } },
				{ "<leader>d", group = "[D]ebug", mode = { "n" } },
				{ "<leader>dt", group = "[D]ebug [T]est", mode = { "n" } },
				{ "<leader>s", group = "[S]end code" },

				-- File/Buffer operations
				--{"<leader>b", group = "[B]uffers" },
				{ "<leader>e", group = "[E]dit", mode = { "n" } },
				{ "<leader>f", group = "[F]ind (Telescope)", mode = { "n" } },

				-- Git groups
				{ "<leader>g", group = "[G]it", mode = { "n", "v" } },
				{ "<leader>gb", group = "Git [B]lame", mode = { "n" } },
				{ "<leader>gc", group = "Git [C]onflict", mode = { "n" } },
				{ "<leader>gd", group = "Git [D]iff", mode = { "n" } },
				{ "<leader>gt", group = "Git [T]oggle", mode = { "n" } },

				-- Language and LSP
				{ "<leader>l", group = "[L]anguage/LSP", mode = { "n" } },
				{ "<leader>ld", group = "[L]anguage [D]iagnostics", mode = { "n" } },
				{ "<leader>lr", group = "[L]SP [R]ename" },

				-- Tools and integrations
				{ "<leader>o", group = "[O]tter & C[O]de", mode = { "n" } },
				{ "<leader>q", group = "[Q]uarto", mode = { "n" } },
				{ "<leader>qr", group = "[Q]uarto [R]un", mode = { "n" } },
				{ "<leader>r", group = "[R] tools", mode = { "n" } },
				{ "<leader>rf", desc = "[R] [F]ormat", mode = { "n" } },
				{ "<leader>p", group = "[P]ython tools" },

				-- System and editor
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>tf", desc = "[T]oggle [F]ormat", mode = { "n" } },
				{ "<leader>v", group = "[V]im", mode = { "n" } },
				{ "<leader>w", group = "[W]orkspace" },
				{ "<leader>x", group = "E[X]ecute", mode = { "n" } },
			},
		},
	},
}

-- vim: ts=2 sts=2 sw=2 et
