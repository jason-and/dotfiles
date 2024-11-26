-- global options

-- proper colors
vim.opt.termguicolors = true

-- show insert mode in terminal buffers
vim.api.nvim_set_hl(0, 'TermCursor', { fg = '#A6E3A1', bg = '#A6E3A1' })

-- disable fill chars (the ~ after the buffer)
vim.o.fillchars = 'eob: '
-- backspace
vim.opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position
-- cursor line
vim.opt.cursorline = true -- highlight the current cursor line

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
vim.opt.termguicolors = true
vim.opt.background = "dark" -- colorschemes that can be light or dark will be made dark
vim.opt.signcolumn = "yes" -- show sign column so that text doesn't shifted

-- more opinionated
vim.opt.mouse = 'a' -- enable mouse
vim.opt.mousefocus = true
vim.opt.clipboard:append 'unnamedplus' -- use system clipboard

vim.opt.timeoutlen = 400 -- until which-key pops up
vim.opt.updatetime = 250 -- for autocommands and hovers

-- line numbers
vim.opt.relativenumber = true
vim.opt.number = true -- show linenumbers
-- don't ask about existing swap files
vim.opt.shortmess:append 'A'

-- directory tree style
-- vim.cmd("let g:netrw_liststyle = 3")
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- mode is already in statusline
vim.opt.showmode = false

-- use less indentation
-- tabs & indentation
vim.opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
vim.opt.shiftwidth = 2 -- 2 spaces for indent width
vim.opt.expandtab = true -- expand tab to spaces
vim.opt.autoindent = true -- copy indent from current line when starting new one

-- space as leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- smarter search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- indent
vim.opt.smartindent = true
vim.opt.breakindent = true

-- Sets how neovim will display certain whitespace in the editor.
--  See :help 'list'
--  and :help 'listchars'
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- consistent number column
vim.opt.signcolumn = 'yes:1'

-- how to show autocomplete menu
vim.opt.completeopt = 'menuone,noinsert'

-- global statusline
vim.opt.laststatus = 3

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

math.randomseed(os.time())

vim.opt.statusline = '%{%g:currentmode[mode()]%} %{%reg_recording()%} %* %t | %y | %* %= c:%c l:%l/%L %p%% %#NonText# %*'

-- hide cmdline when not used
vim.opt.cmdheight = 1

-- split right and below by default
vim.opt.splitright = true
vim.opt.splitbelow = true

--tabline
vim.opt.showtabline = 1

--windowline
vim.opt.winbar = '%f'

-- don't continue comments automagically
-- https://neovim.io/doc/user/options.html#'formatoptions'
vim.opt.formatoptions:remove 'c'
vim.opt.formatoptions:remove 'r'
vim.opt.formatoptions:remove 'o'

-- scroll before end of window
vim.opt.scrolloff = 5

-- (don't == 0) replace certain elements with prettier ones
vim.opt.conceallevel = 0

-- diagnostics
vim.diagnostic.config {
  virtual_text = true,
  underline = true,
  signs = true,
}

-- add new filetypes
vim.filetype.add {
  extension = {
    ojs = 'javascript',
  },
}

-- additional builtin vim packages
-- filter quickfix list with Cfilter
vim.cmd.packadd 'cfilter'
