-- Set Python-specific options
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4

-- Set cell delimiter for Python files
vim.b.slime_cell_delimiter = "# %%"

-- Get the code execution module
local code_exec = require('core.code_execution')

-- Python-specific keymaps
-- Line execution (like RStudio)
vim.keymap.set("n", "<M-Enter>", code_exec.send_line_or_selection, {buffer = true, desc = "Send line to terminal"})
vim.keymap.set("i", "<M-Enter>", function() 
  vim.cmd("normal! <Esc>") 
  code_exec.send_line_or_selection() 
  vim.cmd("startinsert! <End>") 
end, {buffer = true, desc = "Send line to terminal and continue"})
vim.keymap.set("v", "<M-Enter>", code_exec.send_line_or_selection, {buffer = true, desc = "Send selection to terminal"})

-- IMPORTANT: Map Ctrl+Enter to send current line, not cell
vim.keymap.set("n", "<C-Enter>", code_exec.send_line_or_selection, {buffer = true, desc = "Send current line to terminal"})
vim.keymap.set("i", "<C-Enter>", function() 
  vim.cmd("normal! <Esc>") 
  code_exec.send_line_or_selection() 
  vim.cmd("startinsert! <End>") 
end, {buffer = true, desc = "Send line to terminal and continue"})

-- Map something else for cell execution
vim.keymap.set("n", "<leader>sc", code_exec.send_cell, {buffer = true, desc = "Send code cell (# %% delimiter)"})
vim.keymap.set("n", "<S-Enter>", code_exec.send_cell, {buffer = true, desc = "Send code cell"})

-- Additional convenience keymaps
vim.keymap.set("n", "<leader>pr", function()
  -- Run the entire file
  vim.cmd("w")  -- Save the file first
  local filename = vim.fn.expand("%:p")
  vim.fn['slime#send']("run " .. filename .. "\n")
end, {buffer = true, desc = "Run current Python file"})

vim.keymap.set("n", "<leader>pc", function()
  -- Clear IPython terminal
  vim.fn['slime#send']("%clear\n")
end, {buffer = true, desc = "Clear IPython terminal"})

vim.keymap.set("n", "<leader>pd", function()
  -- Add a breakpoint at current line
  local line_content = vim.api.nvim_get_current_line()
  -- Check if we're indented and get the indentation
  local indent = string.match(line_content, "^%s+") or ""
  vim.api.nvim_put({indent .. "breakpoint()"}, "l", true, true)
end, {buffer = true, desc = "Add breakpoint"})
