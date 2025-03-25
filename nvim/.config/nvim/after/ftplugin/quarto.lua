-- Quarto-specific options
vim.opt_local.conceallevel = 0  -- Don't conceal Markdown syntax by default

-- Use different cell delimiter for Quarto
vim.b.slime_cell_delimiter = "```"

-- Get the code execution module
local code_exec = require('core.code_execution')

-- Helper function to insert code chunks
local function insert_code_chunk(lang)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'n', true)
  
  -- Check if we're already in a code chunk
  local in_code_chunk = false
  local ok, current_context = pcall(require('otter.keeper').get_current_language_context)
  if ok and current_context then
    in_code_chunk = true
  end
  
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

-- Keymaps for sending code in Quarto documents
-- Ctrl+Enter sends the current line (consistent with RStudio)
vim.keymap.set("n", "<C-Enter>", code_exec.send_line_or_selection, {buffer = true, desc = "Send line to terminal"})
vim.keymap.set("i", "<C-Enter>", function() 
  vim.cmd("normal! <Esc>") 
  code_exec.send_line_or_selection() 
  vim.cmd("startinsert! <End>") 
end, {buffer = true, desc = "Send line to terminal and continue"})

-- Alt+Enter also sends current line (alternative binding)
vim.keymap.set("n", "<M-Enter>", code_exec.send_line_or_selection, {buffer = true, desc = "Send line to terminal"})
vim.keymap.set("i", "<M-Enter>", function() 
  vim.cmd("normal! <Esc>") 
  code_exec.send_line_or_selection() 
  vim.cmd("startinsert! <End>") 
end, {buffer = true, desc = "Send line to terminal and continue"})
vim.keymap.set("v", "<M-Enter>", code_exec.send_line_or_selection, {buffer = true, desc = "Send selection to terminal"})

-- Shift+Enter sends the whole chunk
vim.keymap.set("n", "<S-Enter>", code_exec.send_chunk, {buffer = true, desc = "Run code chunk"})
vim.keymap.set("i", "<S-Enter>", function() 
  vim.cmd("normal! <Esc>") 
  code_exec.send_chunk()
  vim.cmd("startinsert") 
end, {buffer = true, desc = "Run code chunk and continue"})

-- Keymaps for code chunks
vim.keymap.set("n", "<leader>op", function() insert_code_chunk("python") end, 
  {buffer = true, desc = "[P]ython code chunk"})

vim.keymap.set("n", "<leader>or", function() insert_code_chunk("r") end, 
  {buffer = true, desc = "[R] code chunk"})

vim.keymap.set("n", "<leader>ol", function() insert_code_chunk("lua") end, 
  {buffer = true, desc = "[L]ua code chunk"})

vim.keymap.set("n", "<leader>oj", function() insert_code_chunk("julia") end, 
  {buffer = true, desc = "[J]ulia code chunk"})

vim.keymap.set("n", "<leader>ob", function() insert_code_chunk("bash") end, 
  {buffer = true, desc = "[B]ash code chunk"})

vim.keymap.set("n", "<leader>oo", function() insert_code_chunk("ojs") end, 
  {buffer = true, desc = "[O]JS code chunk"})

-- Toggle R mode - this affects how python chunks are processed
vim.keymap.set("n", "<leader>qR", function()
  vim.b.quarto_is_r_mode = not vim.b.quarto_is_r_mode
  local status = vim.b.quarto_is_r_mode and "enabled" or "disabled"
  vim.notify("R mode " .. status)
  
  -- Reset reticulate status when toggling
  vim.b.reticulate_running = false
end, {buffer = true, desc = "Toggle [R] mode"})

-- Quarto preview functions
vim.keymap.set("n", "<leader>qp", function()
  require('quarto').quartoPreview()
end, {buffer = true, desc = "[P]review"})

vim.keymap.set("n", "<leader>qq", function()
  require('quarto').quartoClosePreview()
end, {buffer = true, desc = "[Q]uiet preview"})

-- Quarto document navigation
vim.keymap.set("n", "<leader>qn", function()
  -- Find next code chunk
  vim.cmd([[/^```{]])
end, {buffer = true, desc = "[N]ext chunk"})

vim.keymap.set("n", "<leader>qN", function()
  -- Find previous code chunk
  vim.cmd([[?^```{]])
end, {buffer = true, desc = "Previous chunk"})

-- Export document
vim.keymap.set("n", "<leader>qe", function()
  if vim.fn.exists(":QuartoExport") > 0 then
    vim.cmd("QuartoExport")
  else
    -- Fallback to rendering with quarto CLI
    local filename = vim.fn.expand("%:p")
    vim.fn.system("quarto render " .. filename)
    vim.notify("Document rendered with quarto CLI")
  end
end, {buffer = true, desc = "[E]xport document"})

