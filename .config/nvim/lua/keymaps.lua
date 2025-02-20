local wk = require("which-key")
local ms = vim.lsp.protocol.Methods

------------------------------------------------------------------
--- Utilities
------------------------------------------------------------------
vim.g["quarto_is_r_mode"] = nil
vim.g["reticulate_running"] = false

-- Sets up keymapping functions for each mode
-- Normal mode mappings
local nmap = function(key, effect, desc)
	vim.keymap.set("n", key, effect, {
		silent = true,
		noremap = true,
		desc = desc,
	})
end

-- Visual mode mappings
local vmap = function(key, effect, desc)
	vim.keymap.set("v", key, effect, {
		silent = true,
		noremap = true,
		desc = desc,
	})
end

-- Insert mode mappings
local imap = function(key, effect, desc)
	vim.keymap.set("i", key, effect, {
		silent = true,
		noremap = true,
		desc = desc,
	})
end

-- Command mode mappings
local cmap = function(key, effect, desc)
	vim.keymap.set("c", key, effect, {
		silent = true,
		noremap = true,
		desc = desc,
	})
end

------------------------------------------------------------------
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
------------------------------------------------------------------
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
nmap("<Esc>", "<cmd>nohlsearch<CR>", "Clear Search Highlights")

-- use jk to exit insert mode
vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

nmap("Q", "<Nop>") -- maps Q to nothing (Q is a older command mode called ex)

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

------------------------------------------------------------------
--- WINDOW NAVIGATION
------------------------------------------------------------------

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
-- Navigate between splits
nmap("<C-h>", "<C-w>h", "Move to left split")
nmap("<C-j>", "<C-w>j", "Move to split below")
nmap("<C-k>", "<C-w>k", "Move to split above")
nmap("<C-l>", "<C-w>l", "Move to right split")

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- navigage using vim keys when in terminal mode
vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]])
vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]])
vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]])
vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]])

------------------------------------------------------------------
--- WORKING WITH TERMINAL
------------------------------------------------------------------

--- Send code to terminal with vim-slime
--- If an R terminal has been opend, this is in r_mode
--- and will handle python code via reticulate when sent
--- from a python chunk.

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- vim: ts=2 sts=2 sw=2 et
