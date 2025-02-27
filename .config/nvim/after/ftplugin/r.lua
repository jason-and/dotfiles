-- Set R-specific options
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2  -- R typically uses 2-space indentation
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2

-- Set buffer-local variable to indicate R mode
vim.b.quarto_is_r_mode = true

-- Get the code execution module
local code_exec = require('core.code_execution')


-- Global keymaps for code execution
-- Send line with Ctrl+Enter (consistent with RStudio behavior)
vim.keymap.set("n", "<C-Enter>", code_exec.send_line_or_selection, {desc = "Send current line to terminal"})
vim.keymap.set("i", "<C-Enter>", function() 
  vim.cmd("normal! <Esc>") 
  code_exec.send_line_or_selection() 
  vim.cmd("startinsert! <End>") 
end, {desc = "Send line to terminal and continue"})

-- Alt+Enter is also mapped to line execution for consistency with RStudio
vim.keymap.set("n", "<M-Enter>", code_exec.send_line_or_selection, {desc = "Send current line to terminal"})
vim.keymap.set("v", "<M-Enter>", code_exec.send_line_or_selection, {desc = "Send selection to terminal"})

-- Cell execution with Shift+Enter
vim.keymap.set("n", "<S-Enter>", code_exec.send_cell, {desc = "Send code cell/chunk"})
vim.keymap.set("i", "<S-Enter>", function() 
  vim.cmd("normal! <Esc>") 
  code_exec.send_cell() 
  vim.cmd("startinsert! <End>") 
end, {desc = "Send code cell/chunk and continue"})

-- Additional mappings with leader key
vim.keymap.set("n", "<leader><cr>", code_exec.send_cell, {desc = "Run code cell/chunk"})
vim.keymap.set("n", "<leader>sl", code_exec.send_line_or_selection, {desc = "Send current line to terminal"})
vim.keymap.set("v", "<leader>sl", code_exec.send_line_or_selection, {desc = "Send selection to terminal"})


-- Additional R-specific features
-- ------------------------------
vim.keymap.set("n", "<leader>rv", function()
  -- View the structure of an object
  local cword = vim.fn.expand("<cword>")
  vim.fn['slime#send']("str(" .. cword .. ")\n")
end, {buffer = true, desc = "View object structure"})

vim.keymap.set("n", "<leader>rh", function()
  -- View help for an R function
  local cword = vim.fn.expand("<cword>")
  vim.fn['slime#send']("??" .. cword .. "\n")
end, {buffer = true, desc = "R help for word under cursor"})

vim.keymap.set("n", "<leader>rp", function()
  -- Print an object
  local cword = vim.fn.expand("<cword>")
  vim.fn['slime#send']("print(" .. cword .. ")\n")
end, {buffer = true, desc = "Print R object"})

vim.keymap.set("n", "<leader>rs", function()
  -- Create a summary of an object
  local cword = vim.fn.expand("<cword>")
  vim.fn['slime#send']("summary(" .. cword .. ")\n")
end, {buffer = true, desc = "Summarize R object"})

vim.keymap.set("n", "<leader>rt", function()
  -- Create an HTML table view of a data frame
  local cword = vim.fn.expand("<cword>")
  vim.fn['slime#send']("if (require('DT')) { DT::datatable(" .. cword .. ") } else { print(" .. cword .. ") }\n")
end, {buffer = true, desc = "View as table"})

vim.keymap.set("n", "<leader>rl", function()
  -- List all objects in environment
  vim.fn['slime#send']("ls()\n")
end, {buffer = true, desc = "List objects"})

