-- ~/.config/nvim/after/ftplugin/python.lua

-- Set Python-specific options
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4

-- Set cell delimiter for Python files
vim.b.slime_cell_delimiter = "# %%"

-- Python-specific keymaps
vim.keymap.set("n", "<leader>pr", function()
  -- Run the entire file
  vim.cmd("w")  -- Save the file first
  local filename = vim.fn.expand("%:p")
  vim.fn['slime#send']("run " .. filename .. "\n")
end, { buffer = true, desc = "Run current Python file" })

-- Set up debugging tools
vim.keymap.set("n", "<leader>db", function()
  -- Add a breakpoint at current line
  local line_content = vim.api.nvim_get_current_line()
  -- Check if we're indented and get the indentation
  local indent = string.match(line_content, "^%s+") or ""
  vim.api.nvim_put({indent .. "breakpoint()"}, "l", true, true)
end, { buffer = true, desc = "Add breakpoint" })