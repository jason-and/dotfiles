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

-- Terminal mode mappings
local tmap = function(key, effect, desc)
	vim.keymap.set("t", key, effect, {
		silent = true,
		noremap = true,
		desc = desc,
	})
end

-- Make utility functions globally available
_G.keymap_util = {
  nmap = nmap,
  vmap = vmap,
  imap = imap,
  cmap = cmap,
  tmap = tmap
}

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
nmap("<leader>q", vim.diagnostic.setloclist, "Open diagnostic [Q]uickfix list")

-- Disable ex mode (Q is often accidentally pressed)
nmap("Q", "<Nop>") -- maps Q to nothing (Q is a older command mode called ex)

-- Disable arrow keys to encourage hjkl usage
nmap("<left>", '<cmd>echo "Use h to move!!"<CR>', "Disable left arrow")
nmap("<right>", '<cmd>echo "Use l to move!!"<CR>', "Disable right arrow")
nmap("<up>", '<cmd>echo "Use k to move!!"<CR>', "Disable up arrow")
nmap("<down>", '<cmd>echo "Use j to move!!"<CR>', "Disable down arrow")

-- Quick save
imap('<C-s>', '<esc>:update<cr><esc>', "Save file")
nmap('<C-s>', '<cmd>:update<cr><esc>', "Save file")

-- Better command line navigation
cmap('<C-a>', '<Home>', "Go to start of command line")

-- Search centered
nmap("n", "nzzzv", "Next search result (centered)")
nmap("gN", "Nzzzv", "Previous search result (centered)")

-- Quick buffer close
nmap("<c-q>", "<cmd>q<cr>", "Close buffer")

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

-- Terminal mode navigation
tmap("<Esc><Esc>", "<C-\\><C-n>", "Exit terminal mode")
tmap("<C-h>", [[<Cmd>wincmd h<CR>]], "Move to left split from terminal")
tmap("<C-j>", [[<Cmd>wincmd j<CR>]], "Move to split below from terminal")
tmap("<C-k>", [[<Cmd>wincmd k<CR>]], "Move to split above from terminal")
tmap("<C-l>", [[<Cmd>wincmd l<CR>]], "Move to right split from terminal")


------------------------------------------------------------------
-- File/code navigation keymaps
------------------------------------------------------------------

-- Quick file navigation
nmap("gf", ":e <cfile><CR>", "Edit file under cursor")
nmap("gl", "<c-]>", "Open help link")

-- Quickfix navigation
nmap("[q", ":silent cprev<cr>", "[Q]uickfix prev")
nmap("]q", ":silent cnext<cr>", "[Q]uickfix next")

-- Spell checking
nmap("z?", ":setlocal spell!<cr>", "Toggle [z]pellcheck")
nmap("zl", ":Telescope spell_suggest<cr>", "[L]ist spelling suggestions")

------------------------------------------------------------------
-- Visual mode keymaps
------------------------------------------------------------------

-- Repeat last normal mode command
vmap(".", ":norm .<cr>", "Repeat last normal mode command")

-- Move lines up and down
vmap("<M-j>", ":m'>+<cr>`<my`>mzgv`yo`z", "Move line down")
vmap("<M-k>", ":m'<-2<cr>`>my`<mzgv`yo`z", "Move line up")

-- Better register management in visual mode
vmap("<leader>d", '"_d', "Delete without overwriting register")
vmap("<leader>p", '"_dP', "Replace without overwriting register")

-- Repeat q macro in visual mode
vmap("q", ":norm @q<cr>", "Repeat q macro")

------------------------------------------------------------------
-- Insert mode keymaps
------------------------------------------------------------------

-- Quick completion
imap("<c-x><c-x>", "<c-x><c-o>", "Trigger omnifunc completion")

-- Common R/Python operators
imap("<m-->", " <- ", "R assignment operator")
imap("<m-m>", " |>", "R pipe operator")

------------------------------------------------------------------
-- Which-key groups
------------------------------------------------------------------

-- Define which-key groups for normal mode
wk.add({
  {
  { "<leader>c", group = "[C]ode / [C]ell / [C]hunk" },
  { "<leader>d", group = "[D]ebug" },
  { "<leader>dt", group = "[D]ebug [T]est" },
  { "<leader>e", group = "[E]dit" },
  { "<leader>f", group = "[F]ind (Telescope)" },
  { "<leader>g", group = "[G]it" },
  { "<leader>gb", group = "[G]it [B]lame" },
  { "<leader>gd", group = "[G]it [D]iff" },
  { "<leader>h", group = "[H]elp / [H]ide / Debug" },
  { "<leader>hc", group = "[H]ide [C]onceal" },
  { "<leader>ht", group = "[H]elp [T]reesitter" },
  { "<leader>i", group = "[I]mage" },
  { "<leader>l", group = "[L]anguage/LSP" },
  { "<leader>ld", group = "[L]anguage [D]iagnostics" },
  { "<leader>o", group = "[O]tter & C[O]de" },
  { "<leader>q", group = "[Q]uarto" },
  { "<leader>qr", group = "[Q]uarto [R]un" },
  { "<leader>r", group = "[R] R specific tools" },
  { "<leader>v", group = "[V]im" },
  { "<leader>x", group = "E[X]ecute" },
}
}, { mode = 'n'})

------------------------------------------------------------------
-- LSP keymaps (basic ones that work across all LSP servers)
------------------------------------------------------------------

nmap("<leader>la", vim.lsp.buf.code_action, "LSP code [A]ction")
nmap("<leader>le", vim.diagnostic.open_float, "Show hover [E]rror")
nmap("<leader>ldd", function() vim.diagnostic.enable(false) end, "[D]iagnostics [D]isable")
nmap("<leader>lde", vim.diagnostic.enable, "[D]iagnostics [E]nable")
nmap("<c-LeftMouse>", "<cmd>lua vim.lsp.buf.definition()<CR>", "Go to definition")

------------------------------------------------------------------
-- Vim-specific commands
------------------------------------------------------------------

nmap("<leader>vc", ":Telescope colorscheme<cr>", "Change [C]olortheme")
nmap("<leader>vh", ':execute "h " . expand("<cword>")<cr>', "Vim [H]elp for current word")
nmap("<leader>vl", ":Lazy<cr>", "[L]azy package manager")
nmap("<leader>vm", ":Mason<cr>", "[M]ason installer")
nmap("<leader>vs", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k<cr>", "[S]ettings, edit vimrc")
nmap("<leader>xx", ":w<cr>:source %<cr>", "Source current file")

-- Return keymap utility functions to make them available to other modules
return _G.keymap_util

