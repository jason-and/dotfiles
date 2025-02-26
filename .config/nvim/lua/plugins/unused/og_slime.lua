{ -- send code from python/r/qmd documets to a terminal or REPL
-- like ipython, R, bash
"jpalardy/vim-slime",
dev = false,
init = function()
  vim.b["quarto_is_python_chunk"] = false
  Quarto_is_in_python_chunk = function()
    require("otter.tools.functions").is_otter_language_context("python")
  end
-- Set cell delimiter
-- This sets the cell delimiter pattern for vim-slime
-- vim.g.slime_cell_delimiter = "# %%"  -- For Python (matches the VS Code/Jupyter style)
-- If you use R, you may want to also set this for R style comments:
vim.g.slime_cell_delimiter = "# %%|```"  -- This works for both Python and R Markdown chunks

-- Make sure this is defined before your keymaps that call vim-slime functions       vim.g.slime_cell_delimiter = "# %%"


  vim.cmd([[
  let g:slime_dispatch_ipython_pause = 100
  function SlimeOverride_EscapeText_quarto(text)
  call v:lua.Quarto_is_in_python_chunk()
  if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
  return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
  else
  if exists('b:quarto_is_r_mode') && b:quarto_is_r_mode && b:quarto_is_python_chunk
  return [a:text, "\n"]
  else
  return [a:text]
  end
  end
  endfunction
  ]])

  vim.g.slime_target = "neovim"
  vim.g.slime_no_mappings = true
  vim.g.slime_python_ipython = 1
end,
config = function()
  vim.g.slime_input_pid = false
  vim.g.slime_suggest_default = true
  vim.g.slime_menu_config = false
  vim.g.slime_neovim_ignore_unlisted = true

  local function mark_terminal()
    local job_id = vim.b.terminal_job_id
    vim.print("job_id: " .. job_id)
  end

  local function set_terminal()
    vim.fn.call("slime#config", {})
  end
  vim.keymap.set("n", "<leader>cm", mark_terminal, { desc = "[m]ark terminal" })
  vim.keymap.set("n", "<leader>cs", set_terminal, { desc = "[s]et terminal" })
end,
}