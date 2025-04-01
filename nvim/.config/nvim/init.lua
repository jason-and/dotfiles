-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Define a simple print function for troubleshooting
-- Usage: _G.debug_print("Some message", someTable)
_G.debug_print = function(...)
	local args = { ... }
	for i, v in ipairs(args) do
		if type(v) == "table" then
			args[i] = vim.inspect(v)
		end
	end
	print(unpack(args))
end

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
require("core")

-- [[ Install `lazy.nvim` plugin manager ]]
-- [[ Configure and install plugins ]]
require("plugins")

vim.cmd("colorscheme kanagawa")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
