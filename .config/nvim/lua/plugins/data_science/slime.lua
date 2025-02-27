return {
	"jpalardy/vim-slime",
	event = { "BufEnter *.py", "BufEnter *.qmd", "BufEnter *.Rmd", "BufEnter *.r", "BufEnter *.R" },
	init = function()
		-- Global slime configuration
		vim.g.slime_target = "neovim"
		vim.g.slime_no_mappings = true -- We'll define our own mappings
		vim.g.slime_python_ipython = 1 -- Enable IPython special paste mode
		vim.g.slime_cell_delimiter = "# %%"
		vim.g.slime_dispatch_ipython_pause = 100

		-- Initialize buffer-local variables
		vim.b.quarto_is_python_chunk = false
		vim.b.quarto_is_r_mode = false
		vim.b.reticulate_running = false

		-- Make our utility functions available to VimL
		_G.Quarto_is_in_python_chunk = function()
			return require("core.code_execution").is_in_python_chunk()
		end

		-- Configure slime for Quarto/Rmd
		vim.cmd([[
			function! SlimeOverride_EscapeText_quarto(text)
			" First call our detection function
			call v:lua.Quarto_is_in_python_chunk()
			
			" Remove any leading ```{python} or trailing ``` lines
			let text = substitute(a:text, '^\s*```{python}$\n', '', '')
			let text = substitute(text, '\n\s*```$', '', '')
			
			" Handle different modes
			if exists('g:slime_python_ipython') && len(split(text,"\n")) > 1 && b:quarto_is_python_chunk && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
				" Python code in IPython mode
				return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, text, "--", "\n"]
			elseif exists('b:quarto_is_r_mode') && b:quarto_is_r_mode && b:quarto_is_python_chunk
				" Python code in R mode (via reticulate)
				return [text, "\n"]
			else
				" Default handling
				return [text]
			endif
			endfunction
			]])
	end,

	config = function()
		-- Load our code execution module
		local code_exec = require("core.code_execution")

		-- Configure the terminal behavior
		vim.g.slime_input_pid = false
		vim.g.slime_suggest_default = true
		vim.g.slime_menu_config = false
		vim.g.slime_neovim_ignore_unlisted = true

		-- Initialize our code execution module
		code_exec.setup()

		-- Global keymaps for code execution
		-- Send line with Ctrl+Enter (consistent with RStudio behavior)
		vim.keymap.set("n", "<C-Enter>", code_exec.send_line_or_selection, { desc = "Send current line to terminal" })
		vim.keymap.set("i", "<C-Enter>", function()
			vim.cmd("normal! <Esc>")
			code_exec.send_line_or_selection()
			vim.cmd("startinsert! <End>")
		end, { desc = "Send line to terminal and continue" })

		-- in visual mode send code with enter
		vim.keymap.set("v", "<CR>", code_exec.send_line_or_selection, { desc = "Send selection to terminal" })

		-- Cell execution with Shift+Enter
		vim.keymap.set("n", "<S-Enter>", code_exec.send_cell, { desc = "Send code cell/chunk" })
		vim.keymap.set("i", "<S-Enter>", function()
			vim.cmd("normal! <Esc>")
			code_exec.send_cell()
			vim.cmd("startinsert! <End>")
		end, { desc = "Send code cell/chunk and continue" })

		-- Additional mappings with leader key
		vim.keymap.set("n", "<leader><cr>", code_exec.send_cell, { desc = "Run code cell/chunk" })
		vim.keymap.set("n", "<leader>sl", code_exec.send_line_or_selection, { desc = "Send current line to terminal" })
		vim.keymap.set("v", "<leader>sl", code_exec.send_line_or_selection, { desc = "Send selection to terminal" })

		-- Terminal management keymaps
		vim.keymap.set("n", "<leader>cm", code_exec.mark_terminal, { desc = "[M]ark terminal for code" })
		vim.keymap.set("n", "<leader>ct", function()
			vim.fn.call("slime#config", {})
		end, { desc = "Configure [t]erminal" })

		-- Create new terminal keymaps
		vim.keymap.set("n", "<leader>ci", code_exec.new_terminal_ipython, { desc = "New [i]Python terminal" })
		vim.keymap.set("n", "<leader>cp", code_exec.new_terminal_python, { desc = "New [p]ython terminal" })
		vim.keymap.set("n", "<leader>cr", code_exec.new_terminal_r, { desc = "New [r] terminal" })
		vim.keymap.set("n", "<leader>cj", code_exec.new_terminal_julia, { desc = "New [j]ulia terminal" })
		vim.keymap.set("n", "<leader>cn", code_exec.new_terminal_shell, { desc = "[n]ew shell terminal" })
	end,
}
