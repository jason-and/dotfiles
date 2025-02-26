return { -- commenting with e.g. `gcc` or `gcip`
-- respects TS, so it works in quarto documents 'numToStr/Comment.nvim',
'numToStr/Comment.nvim',
version = nil,
cond = function()
  return vim.fn.has 'nvim-0.10' == 0
end,
branch = 'master',
config = true,
}