-- This module provides enhanced code execution functionality for R and Python
-- Supports both Quarto documents and standalone R/Python files

local M = {}

-- Utility functions
---------------------

-- Detect if current position is in a Python chunk (for Quarto/Rmd)
M.is_in_python_chunk = function()
	-- Check if otter is available
	local ok, otter_func = pcall(require, "otter.tools.functions")
	if ok then
		local is_python = otter_func.is_otter_language_context("python")
		vim.b.quarto_is_python_chunk = is_python
		return is_python
	end
	return false
end

-- Detect if current line is part of a piped expression in R
-- For example: data %>% filter(...) %>% select(...)
M.is_piped_expression = function()
	local current_line = vim.fn.line(".")
	local current_text = vim.fn.getline(current_line)

	-- Check if line ends with a pipe operator
	if current_text:match("(|>%s*$)") or current_text:match("(%%>%%%s*$)") then
		return true
	end

	-- Check if next line begins with a pipe operator
	if current_line < vim.fn.line("$") then
		local next_text = vim.fn.getline(current_line + 1)
		if next_text:match("^%s*(|>)") or next_text:match("^%s*(%%>%%)") then
			return true
		end
	end

	return false
end

-- Get the entire piped expression (for R)
M.get_piped_expression = function()
	local current_line = vim.fn.line(".")
	local first_line = current_line
	local last_line = current_line

	-- Look backward for start of the expression
	while first_line > 1 do
		local prev_text = vim.fn.getline(first_line - 1)
		if prev_text:match("(|>%s*$)") or prev_text:match("(%%>%%%s*$)") then
			first_line = first_line - 1
		else
			-- Check if this line is a continuation of previous line
			if not prev_text:match("%s*[a-zA-Z0-9_.]") then
				break
			else
				first_line = first_line - 1
			end
		end
	end

	-- Look forward for end of the expression
	while last_line < vim.fn.line("$") do
		local line_text = vim.fn.getline(last_line)
		if line_text:match("(|>%s*$)") or line_text:match("(%%>%%%s*$)") then
			last_line = last_line + 1
		else
			break
		end
	end

	return { first_line, last_line }
end

-- Find the boundaries of the current code chunk in a Quarto/Rmd document
M.get_chunk_boundaries = function()
	local current_line = vim.fn.line(".")
	local chunk_start = nil
	local chunk_end = nil
	local chunk_lang = nil

	-- Look backward for chunk start
	for i = current_line, 1, -1 do
		local line = vim.fn.getline(i)
		local match = line:match("^%s*```{(.+)}%s*$")
		if match then
			chunk_start = i
			chunk_lang = match
			break
		end
	end

	-- If no chunk start found, return nil
	if not chunk_start then
		return nil
	end

	-- Look forward for chunk end
	for i = current_line, vim.fn.line("$") do
		local line = vim.fn.getline(i)
		if line:match("^%s*```%s*$") then
			chunk_end = i
			break
		end
	end

	-- If no chunk end found, return nil
	if not chunk_end then
		return nil
	end

	return {
		start = chunk_start,
		end_line = chunk_end,
		lang = chunk_lang,
	}
end

-- Find boundaries of Python cell marked with # %%
M.get_cell_boundaries = function()
	local current_line = vim.fn.line(".")
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local cell_start = nil
	local cell_end = nil

	-- Look backward for cell start
	for i = current_line, 1, -1 do
		if lines[i] and lines[i]:match("^%s*#%s*%%%%") then
			cell_start = i
			break
		end
	end

	-- If no cell start found, use start of file
	if not cell_start then
		cell_start = 1
	end

	-- Look forward for next cell delimiter or end of file
	for i = current_line + 1, #lines do
		if lines[i] and lines[i]:match("^%s*#%s*%%%%") then
			cell_end = i - 1
			break
		end
	end

	-- If no cell end found, use end of file
	if not cell_end then
		cell_end = #lines
	end

	return { cell_start, cell_end }
end

-- Send Functions
-----------------

-- Send the current line or visual selection to terminal
M.send_line_or_selection = function()
	local mode = vim.api.nvim_get_mode().mode

	-- Handle visual mode
	if mode == "v" or mode == "V" or mode:find("\22") then
		-- Use Vim's built-in function to get visual selection
		vim.cmd('noautocmd normal! "vy"')
		local text = vim.fn.getreg("v")

		if text and text ~= "" then
			-- Send to terminal with appropriate mode
			if
				vim.bo.filetype == "python"
				or (vim.b.quarto_is_python_chunk or false) and vim.g.slime_python_ipython == 1
			then
				vim.fn["slime#send"]("%cpaste -q\n")
				vim.defer_fn(function()
					vim.fn["slime#send"](text .. "\n--\n")
				end, 100)
			else
				vim.fn["slime#send"](text .. "\n")
			end
		end

		-- Return to normal mode and clear the temporary register
		vim.fn.setreg("v", "")
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
		return
	end

	-- Handle R piped expressions
	if vim.bo.filetype == "r" or vim.bo.filetype == "quarto" then
		if M.is_piped_expression() then
			local range = M.get_piped_expression()
			local lines = vim.api.nvim_buf_get_lines(0, range[1] - 1, range[2], false)

			-- Check that we have lines and they're in a table format
			if type(lines) == "table" and #lines > 0 then
				local text = table.concat(lines, "\n")
				vim.fn["slime#send"](text .. "\n")
			else
				vim.notify("Error: No text in piped expression or unexpected format", vim.log.levels.ERROR)
			end
			return
		end
	end

	-- Send the current line
	local text = vim.api.nvim_get_current_line()
	vim.fn["slime#send"](text .. "\n")
end

-- Send the current chunk in a Quarto/Rmd document
M.send_chunk = function()
	local chunk = M.get_chunk_boundaries()

	if not chunk then
		vim.notify("No code chunk found at cursor position", vim.log.levels.WARN)
		return
	end

	-- Set the language context
	if chunk.lang:match("python") then
		vim.b.quarto_is_python_chunk = true

		-- If in R mode, make sure Python works via reticulate
		if vim.b.quarto_is_r_mode and not vim.b.reticulate_running then
			vim.fn["slime#send"]("reticulate::repl_python()" .. "\r")
			vim.b.reticulate_running = true
		end
	else
		vim.b.quarto_is_python_chunk = false

		-- If exiting Python mode within R, switch back to R
		if vim.b.quarto_is_r_mode and vim.b.reticulate_running then
			vim.fn["slime#send"]("exit" .. "\r")
			vim.b.reticulate_running = false
		end
	end

	-- Get chunk content (excluding the markers)
	local content = vim.api.nvim_buf_get_lines(0, chunk.start, chunk.end_line - 1, false)
	if #content > 0 then
		-- Remove first and last line (the chunk markers)
		content = vim.list_slice(content, 2, #content)
		local text = table.concat(content, "\n")
		vim.fn["slime#send"](text .. "\n")
	end
end

-- Send the current cell (Python with # %% markers)
M.send_cell = function()
	local filetype = vim.bo.filetype

	-- Handle Quarto/Rmd documents
	if filetype == "quarto" or filetype == "markdown" then
		local chunk = M.get_chunk_boundaries()
		if chunk then
			M.send_chunk()
			return
		end
	end

	-- Handle standard code cells (# %%)
	if filetype == "python" or filetype == "quarto" or filetype == "markdown" then
		-- Try standard vim-slime cell function
		vim.fn["slime#send_cell"]()
	else
		vim.notify("Cell execution not supported for this filetype", vim.log.levels.WARN)
	end
end

-- Terminal Management Functions
---------------------------------

-- Mark a terminal buffer for sending code
M.mark_terminal = function()
	local buf = vim.api.nvim_get_current_buf()
	local buftype = vim.bo[buf].buftype

	if buftype ~= "terminal" then
		vim.notify("Not a terminal buffer", vim.log.levels.ERROR)
		return
	end

	local job_id = vim.b[buf].terminal_job_id
	if job_id then
		-- Configure slime to use this terminal
		vim.g.slime_target = "neovim"
		vim.g.slime_default_config = { jobid = job_id }

		-- Detect language based on terminal process
		local term_name = vim.api.nvim_buf_get_name(buf)
		if string.match(term_name, "R") then
			vim.b.quarto_is_r_mode = true
			vim.notify("Terminal marked for R", vim.log.levels.INFO)
		elseif string.match(term_name, "python") or string.match(term_name, "ipython") then
			vim.b.quarto_is_r_mode = false
			vim.g.slime_python_ipython = string.match(term_name, "ipython") and 1 or 0
			vim.notify("Terminal marked for Python", vim.log.levels.INFO)
		else
			vim.notify("Terminal marked (generic)", vim.log.levels.INFO)
		end
	else
		vim.notify("Error: No job ID found for this terminal", vim.log.levels.ERROR)
	end
end

-- Create a new terminal with appropriate settings
M.new_terminal = function(lang)
	local height = math.floor(vim.api.nvim_win_get_height(0) * 0.33)
	vim.cmd(height .. "split term://" .. lang)

	-- Automatically mark the terminal
	vim.defer_fn(function()
		M.mark_terminal()
	end, 500)

	-- 	-- Set focus to the terminal
	-- 	vim.cmd("startinsert")
end
--
-- Create terminals for different languages
M.new_terminal_python = function()
	M.new_terminal("python")
end
M.new_terminal_ipython = function()
	M.new_terminal("ipython --no-autoindent --no-confirm-exit")
end
M.new_terminal_r = function()
	M.new_terminal("radian")
end
M.new_terminal_julia = function()
	M.new_terminal("julia")
end
M.new_terminal_shell = function()
	M.new_terminal("$SHELL")
end

-- Define setup_diagnostics as a separate function
M.setup_diagnostics = function()
	-- Register the command to make it accessible
	vim.api.nvim_create_user_command("CheckSlime", M.check_slime, {})
end

-- Setup function to be called from the plugin config
M.setup = function()
	-- Initialize buffer-local variables
	vim.b.quarto_is_python_chunk = false
	vim.b.quarto_is_r_mode = false
	vim.b.reticulate_running = false

	-- Set cell delimiter for standard code cells
	vim.g.slime_cell_delimiter = "# %%"

	-- Configure slime for different filetypes
	vim.cmd([[
  function! SlimeOverride_EscapeText_quarto(text)
    " First check if we're in a python chunk
    call v:lua.require'core.code_execution'.is_in_python_chunk()
    
    " Handle Python in IPython mode
    if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
      return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
    elseif exists('b:quarto_is_r_mode') && b:quarto_is_r_mode && b:quarto_is_python_chunk
      " Python code in R mode (via reticulate)
      return [a:text, "\n"]
    else
      " Default handling
      return [a:text, "\n"]
    endif
  endfunction
  ]])

	-- Create diagnostic command
	M.setup_diagnostics()
end

-- Create a diagnostic report for slime and code execution
M.check_slime = function()
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

	local lines = {
		"=== Slime & Code Execution Configuration ===",
		"",
		"Global settings:",
		"  slime_target = " .. tostring(vim.g.slime_target),
		"  slime_cell_delimiter = " .. tostring(vim.g.slime_cell_delimiter),
		"  slime_python_ipython = " .. tostring(vim.g.slime_python_ipython),
		"  slime_default_config = " .. vim.inspect(vim.g.slime_default_config or "not set"),
		"",
		"Buffer settings:",
		"  filetype = " .. vim.bo.filetype,
		"  buffer slime_cell_delimiter = " .. tostring(vim.b.slime_cell_delimiter or "not set"),
		"",
		"Quarto/R settings:",
		"  quarto_is_python_chunk = " .. tostring(vim.b.quarto_is_python_chunk or "not set"),
		"  quarto_is_r_mode = " .. tostring(vim.b.quarto_is_r_mode or "not set"),
		"  reticulate_running = " .. tostring(vim.b.reticulate_running or "not set"),
		"",
		"Open terminals:",
	}

	-- List open terminals
	local terminal_count = 0
	for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
		-- Replace nvim_buf_get_option with bo
		if vim.bo[buf_id].buftype == "terminal" then
			terminal_count = terminal_count + 1
			local name = vim.api.nvim_buf_get_name(buf_id)
			local job_id = vim.b[buf_id].terminal_job_id or "unknown"
			table.insert(lines, string.format("  %d: %s (job_id: %s)", buf_id, name, job_id))
		end
	end

	if terminal_count == 0 then
		table.insert(lines, "  No terminal buffers found")
	end

	-- Add troubleshooting tips
	table.insert(lines, "")
	table.insert(lines, "Troubleshooting tips:")
	table.insert(lines, "  1. Ensure a terminal is open (<leader>ci, <leader>cr, etc.)")
	table.insert(lines, "  2. Mark the terminal with <leader>cm while in the terminal buffer")
	table.insert(lines, "  3. For R with Python via reticulate, ensure reticulate is installed:")
	table.insert(lines, '     install.packages("reticulate")')
	table.insert(lines, "  4. Toggle R mode with <leader>qR if working with mixed R/Python")

	-- Add the diagnostic information to the buffer
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	-- Open the buffer in a new window
	local win_height = math.min(#lines + 2, 20)
	vim.cmd(win_height .. "new")
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, buf)

	-- Replace nvim_win_set_option with wo
	vim.wo[win].wrap = true

	-- Replace nvim_buf_set_option with bo
	vim.bo[buf].modifiable = false
	vim.api.nvim_buf_set_name(buf, "Slime Diagnostics")
end

-- Return the module
return M
