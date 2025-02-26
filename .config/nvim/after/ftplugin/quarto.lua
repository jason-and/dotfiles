-- ~/.config/nvim/after/ftplugin/quarto.lua

-- Quarto-specific options
vim.opt_local.conceallevel = 0  -- Don't conceal Markdown syntax by default

-- Use different cell delimiter for Quarto
vim.b.slime_cell_delimiter = "```"

-- Helper function to insert code chunks
local function insert_code_chunk(lang)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'n', true)
  
  -- Check if we're already in a code chunk
  local in_code_chunk = require('otter.keeper').get_current_language_context()
  local keys
  
  if in_code_chunk then
    -- Split the current chunk
    keys = [[o```<cr><cr>```{]] .. lang .. [[}<esc>o]]
  else
    -- Create a new chunk
    keys = [[o```{]] .. lang .. [[}<cr>```<esc>O]]
  end
  
  keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(keys, 'n', false)
end

-- Keymaps for different code chunks
vim.keymap.set("n", "<leader>op", function() insert_code_chunk("python") end, 
  { buffer = true, desc = "[p]ython code chunk" })

vim.keymap.set("n", "<leader>or", function() insert_code_chunk("r") end, 
  { buffer = true, desc = "[r] code chunk" })

vim.keymap.set("n", "<leader>ol", function() insert_code_chunk("lua") end, 
  { buffer = true, desc = "[l]ua code chunk" })

vim.keymap.set("n", "<leader>oj", function() insert_code_chunk("julia") end, 
  { buffer = true, desc = "[j]ulia code chunk" })

-- Toggle R mode
vim.keymap.set("n", "<leader>qR", function()
  vim.b.quarto_is_r_mode = not vim.b.quarto_is_r_mode
  local status = vim.b.quarto_is_r_mode and "enabled" or "disabled"
  vim.notify("R mode " .. status)
end, { buffer = true, desc = "Toggle [R] mode" })

-- Preview functions
vim.keymap.set("n", "<leader>qp", function()
  require('quarto').quartoPreview()
end, { buffer = true, desc = "[p]review" })

vim.keymap.set("n", "<leader>qq", function()
  require('quarto').quartoClosePreview()
end, { buffer = true, desc = "[q]uiet preview" })