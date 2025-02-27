------------------------------------------------
-- Autocommands
------------------------------------------------

-- don't continue comments automagically
-- https://neovim.io/doc/user/options.html#'formatoptions'
vim.opt.formatoptions:remove 'c'
vim.opt.formatoptions:remove 'r'
vim.opt.formatoptions:remove 'o'



vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- checks if any open files have been modified outside of Neovim
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
  pattern = { '*' },
  command = 'checktime',
})
-- settings to clean up terminal when open
vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  pattern = { '*' },
  callback = function(_)
    vim.cmd.setlocal 'nonumber' -- no numbers
    vim.wo.signcolumn = 'no' --removes gutter
  end,
})

-- make terminal go to last command automatically
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*", -- any terminal
  callback = function()
    vim.cmd("startinsert") -- go into insert mode
    vim.wo.scrolloff = 0 -- go to end of terminal
    vim.api.nvim_create_autocmd({"TermLeave", "BufEnter"}, {
      buffer = 0,
      command = "normal! G"
    })
  end
})

vim.filetype.add({
  extension = {
    njk = "htmldjango"  -- Use Django HTML syntax as it's very similar to Nunjucks
  }
})
