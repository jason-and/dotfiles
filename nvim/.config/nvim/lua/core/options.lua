-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

------------------------------------------------
-- general settings
------------------------------------------------

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"
vim.opt.mousefocus = true -- mouse follows focus

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time for keybindings
vim.opt.timeoutlen = 300

-- add new filetypes
vim.filetype.add {
  extension = {
    ojs = 'javascript',
  },
}

------------------------------------------------
-- Appearance and window behavior
------------------------------------------------

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- hide cmdline when not used
vim.opt.cmdheight = 1

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Configure how new splits should be opened
vim.opt.splitright = true -- split default right
vim.opt.splitbelow = true -- split default below
vim.opt.winbar = '%f' -- winbar is filename

-- proper colors
vim.opt.termguicolors = true
vim.opt.background = "dark" -- colorschemes that can be light or dark will be made dark
vim.api.nvim_set_hl(0, 'TermCursor', { fg = '#A6E3A1', bg = '#A6E3A1' }) -- how insert mode in terminal buffers

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- how to show autocomplete menu
vim.opt.completeopt = 'menuone,noinsert'

-- global statusline
vim.opt.laststatus = 3

-- settings to make a specific status line
vim.cmd [[
let g:currentmode={
       \ 'n'  : '%#String# NORMAL ',
       \ 'v'  : '%#Search# VISUAL ',
       \ 's'  : '%#ModeMsg# VISUAL ',
       \ "\<C-V>" : '%#Title# V·Block ',
       \ 'V'  : '%#IncSearch# V·Line ',
       \ 'Rv' : '%#String# V·Replace ',
       \ 'i'  : '%#ModeMsg# INSERT ',
       \ 'R'  : '%#Substitute# R ',
       \ 'c'  : '%#CurSearch# Command ',
       \ 't'  : '%#ModeMsg# TERM ',
       \}
]]
vim.opt.statusline = '%{%g:currentmode[mode()]%} %{%reg_recording()%} %* %t | %y | %* %= c:%c l:%l/%L %p%% %#NonText# %*'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Keep signcolumn on by default with consistency
vim.opt.signcolumn = "yes:1"

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- diagnostics
vim.diagnostic.config {
  virtual_text = true,
  underline = true,
  signs = true,
}

------------------------------------------------
-- Indentation settings (global defaults)
------------------------------------------------
-- Default indentation: 2 spaces
vim.opt.expandtab = true           -- Use spaces instead of tabs
vim.opt.shiftwidth = 2             -- Size of an indent
vim.opt.tabstop = 2                -- Number of spaces tabs count for
vim.opt.softtabstop = 2            -- Number of spaces when editing
vim.opt.shiftround = true          -- Round indent to multiple of 'shiftwidth'
vim.opt.smartindent = true         -- Insert indents automatically

-- Add these after the indentation settings
-- Create an autocommand group for filetype-specific settings
local indent_group = vim.api.nvim_create_augroup("IndentationSettings", { clear = true })

-- Define filetype-specific indentation
vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = { "python" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = { "r", "rmd", "quarto" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = { "lua", "html", "css", "javascript", "typescript", "json", "yaml", "sql", "sh", "bash" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- When opening a new file, try to use same indent as current file
vim.g.sleuth_neighbor_limit = 5  -- Look at neighboring files within 5 lines

-- vim: ts=2 sts=2 sw=2 et
