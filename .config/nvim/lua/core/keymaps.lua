------------------------------------------------------------------
--- Utilities
------------------------------------------------------------------
--vim.g["quarto_is_r_mode"] = nil
--vim.g["reticulate_running"] = false

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
	tmap = tmap,
}

------------------------------------------------------------------
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
------------------------------------------------------------------
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
nmap("<Esc>", "<cmd>nohlsearch<CR>", "Clear Search Highlights")

-- use jk to exit insert mode
imap("jk", "<ESC>", "Exit insert mode with jk")

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
imap("<C-s>", "<esc>:update<cr><esc>", "Save file")
nmap("<C-s>", "<cmd>:update<cr><esc>", "Save file")

-- Better command line navigation
cmap("<C-a>", "<Home>", "Go to start of command line")

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
-- LSP keymaps (basic ones that work across all LSP servers)
------------------------------------------------------------------

nmap("<leader>la", vim.lsp.buf.code_action, "LSP code [A]ction")
nmap("<leader>le", vim.diagnostic.open_float, "Show hover [E]rror")
nmap("<leader>ldd", function()
	vim.diagnostic.enable(false)
end, "[D]iagnostics [D]isable")
nmap("<leader>lde", vim.diagnostic.enable, "[D]iagnostics [E]nable")
nmap("<c-LeftMouse>", "<cmd>lua vim.lsp.buf.definition()<CR>", "Go to definition")

------------------------------------------------------------------
-- Code Formatting
-- ------------------------------------------------------------------

-- Format the current buffer (use <leader>cf for "code format" instead of bf)
nmap("<leader>cf", function()
	require("conform").format({ async = true })
end, "[C]ode [F]ormat buffer")

-- Format the selected text (visual mode)
vmap("<leader>cf", function()
	require("conform").format({
		async = true,
		lsp_format = "fallback",
		range = {
			start = vim.fn.getpos("'<"),
			["end"] = vim.fn.getpos("'>"),
		},
	})
end, "[C]ode [F]ormat selection")

-- Toggle format on save (<leader>tf for "toggle format")
nmap("<leader>tf", ":FormatToggle<CR>", "[T]oggle [F]ormat on save")

-- Format with LSP (fallback when conform doesn't have a formatter)
nmap("<leader>lf", function()
	vim.lsp.buf.format({ async = true })
end, "[L]SP [F]ormat")

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
