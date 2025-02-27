return {
	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({
						async = true,
						lsp_format = "fallback",
					})
				end,
				mode = "",
				desc = "[C]ode [F]ormat",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable for languages without standardized coding style
				local disable_filetypes = { c = true, cpp = true }
				local lsp_format_opt

				if disable_filetypes[vim.bo[bufnr].filetype] then
					lsp_format_opt = "never"
				else
					lsp_format_opt = "fallback"
				end

				return {
					timeout_ms = 500,
					lsp_format = lsp_format_opt,
				}
			end,
			-- Define formatter preferences per filetype
			formatters_by_ft = {
				-- Lua
				lua = { "stylua" },

				-- Python
				python = { "isort", "black" },

				-- Web development
				html = { "prettier" },
				css = { "prettier" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },

				-- Markup
				markdown = { "prettier" },
				quarto = { "injected" },

				-- R
				r = { "styler" },

				-- SQL
				sql = { "sqlfluff" },

				-- Shell/Bash
				sh = { "shfmt" },
				bash = { "shfmt" },

				-- Docker
				dockerfile = { "hadolint" },

				-- Jinja/Nunjucks - use prettier with HTML mode
				jinja = { "prettier" },
				njk = { "prettier" },

				-- Fallback - try using LSP
				["*"] = { "lsp" },
			},

			-- Configure formatters
			formatters = {
				-- Make prettier work with Nunjucks/Jinja
				prettier = {
					options = {
						-- Use HTML parser for Nunjucks files
						ft_parsers = {
							njk = "html",
							jinja = "html",
						},
					},
				},

				-- Configure shfmt
				shfmt = {
					args = { "-i", "2", "-ci" }, -- 2 space indentation
				},

				-- Configure black
				black = {
					args = { "--line-length", "88" },
				},

				-- Configure sqlfluff
				sqlfluff = {
					args = { "fix", "--dialect", "postgres", "--disable-progress-bar", "-" },
				},

				-- Configure styler for R
				styler = {
					prepend_args = { "--indention=2" }, -- Set 2 space indentation
				},

				-- Customize the "injected" formatter (for quarto/rmd)
				injected = {
					options = {
						ignore_errors = false,
						lang_to_ext = {
							bash = "sh",
							javascript = "js",
							python = "py",
							r = "r",
							yaml = "yaml",
						},
						lang_to_formatters = {
							python = { "isort", "black" },
							r = { "styler" },
							lua = { "stylua" },
							javascript = { "prettier" },
							bash = { "shfmt" },
							yaml = { "prettier" },
						},
					},
				},
			},
		},
		-- Install formatters automatically through Mason
		config = function(_, opts)
			local conform = require("conform")

			-- Setup with provided options
			conform.setup(opts)

			-- Create commands to toggle formatting
			vim.api.nvim_create_user_command("FormatToggle", function()
				local bufnr = vim.api.nvim_get_current_buf()
				vim.b[bufnr].format_disabled = not vim.b[bufnr].format_disabled
				local status = vim.b[bufnr].format_disabled and "disabled" or "enabled"
				vim.notify("Format on save " .. status .. " for buffer " .. bufnr)
			end, { desc = "Toggle format on save for current buffer" })

			vim.api.nvim_create_user_command("FormatDisable", function()
				local bufnr = vim.api.nvim_get_current_buf()
				vim.b[bufnr].format_disabled = true
				vim.notify("Format on save disabled for buffer " .. bufnr)
			end, { desc = "Disable format on save for current buffer" })

			vim.api.nvim_create_user_command("FormatEnable", function()
				local bufnr = vim.api.nvim_get_current_buf()
				vim.b[bufnr].format_disabled = false
				vim.notify("Format on save enabled for buffer " .. bufnr)
			end, { desc = "Enable format on save for current buffer" })
		end,
	},
}
