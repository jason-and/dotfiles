-- Basic markdown settings
vim.opt_local.conceallevel = 0
vim.opt_local.wrap = true
vim.opt_local.linebreak = true

-- Use the same cell delimiter for Rmd compatibility
vim.b.slime_cell_delimiter = "```"

-- Get the code execution module
local code_exec = require("core.code_execution")

-- Similar functionality to Quarto but more limited
-- Helper function to insert code chunks
local function insert_code_chunk(lang)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", true)

	-- Check if we're already in a code chunk (if otter is available)
	local in_code_chunk = false
	local ok, current_context = pcall(require("otter.keeper").get_current_language_context)
	if ok and current_context then
		in_code_chunk = true
	end

	local keys
	if in_code_chunk then
		-- Split the current chunk
		keys = [[o```<cr><cr>```]] .. lang .. [[<esc>o]]
	else
		-- Create a new chunk
		keys = [[o```]] .. lang .. [[<cr>```<esc>O]]
	end

	keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
end

-- Keymaps for sending code in Markdown documents (for R Markdown)
vim.keymap.set("n", "<C-Enter>", code_exec.send_line_or_selection, { buffer = true, desc = "Send line to terminal" })
vim.keymap.set("n", "<M-Enter>", code_exec.send_line_or_selection, { buffer = true, desc = "Send line to terminal" })
vim.keymap.set(
	"v",
	"<M-Enter>",
	code_exec.send_line_or_selection,
	{ buffer = true, desc = "Send selection to terminal" }
)

-- Common code chunk insertion
vim.keymap.set("n", "<leader>op", function()
	insert_code_chunk("python")
end, { buffer = true, desc = "[P]ython code chunk" })
vim.keymap.set("n", "<leader>or", function()
	insert_code_chunk("r")
end, { buffer = true, desc = "[R] code chunk" })

-- For chunk execution
vim.keymap.set("n", "<S-Enter>", code_exec.send_chunk, { buffer = true, desc = "Run code chunk" })
