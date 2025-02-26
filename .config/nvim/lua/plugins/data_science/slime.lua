-- Utility functions for slime
local M = {}

-- Check if the current position is in a Python chunk
M.is_in_python_chunk = function()
  local is_python = require("otter.tools.functions").is_otter_language_context("python")
  vim.b.quarto_is_python_chunk = is_python
  return is_python
end

-- Enhanced version of send_cell that handles Quarto chunks better
M.send_cell = function()
  -- Get current buffer info
  local current_line = vim.fn.line('.')
  local filetype = vim.bo.filetype
  
  -- Special handling for Quarto/RMarkdown documents
  if filetype == "quarto" or filetype == "markdown" then
    -- Check if we're inside a code chunk
    local in_chunk = false
    local chunk_start = 0
    local chunk_end = 0
    local chunk_lang = ""
    
    -- Search backwards for chunk start
    for i = current_line, 1, -1 do
      local line = vim.fn.getline(i)
      local chunk_begin = line:match("^%s*```{(.+)}%s*$")
      if chunk_begin then
        in_chunk = true
        chunk_start = i
        chunk_lang = chunk_begin
        break
      end
    end
    
    -- If we found a start, search forward for chunk end
    if in_chunk then
      for i = current_line, vim.fn.line('$') do
        local line = vim.fn.getline(i)
        if line:match("^%s*```%s*$") then
          chunk_end = i
          break
        end
      end
      
      -- If we found a complete chunk, send only the content (not the markers)
      if chunk_end > chunk_start then
        local chunk_content = vim.fn.getline(chunk_start + 1, chunk_end - 1)
        local text_to_send = table.concat(chunk_content, "\n")
        
        -- Set the language context
        if chunk_lang:match("python") then
          vim.b.quarto_is_python_chunk = true
        else
          vim.b.quarto_is_python_chunk = false
        end
        
        -- Send to terminal
        vim.fn['slime#send'](text_to_send .. "\n")
        return
      end
    end
  end
  
  -- Fall back to standard cell sending if not in a Quarto chunk
  vim.fn['slime#send_cell']()
end

-- Setup function for terminal marking and config
M.setup_terminal = function()
  local function mark_terminal()
    local job_id = vim.b.terminal_job_id
    if job_id then
      vim.print("Terminal marked! Job ID: " .. job_id)
    else
      vim.notify("Error: This buffer doesn't appear to be a terminal", vim.log.levels.ERROR)
    end
  end

  local function set_terminal()
    vim.fn.call("slime#config", {})
  end
  
  -- Set keymaps for terminal management
  vim.keymap.set("n", "<leader>cm", mark_terminal, { desc = "[m]ark terminal" })
  vim.keymap.set("n", "<leader>cs", set_terminal, { desc = "[s]et terminal" })
end

-- The actual plugin spec
return {
  "jpalardy/vim-slime",
  event = { "BufEnter *.py", "BufEnter *.qmd", "BufEnter *.Rmd", "BufEnter *.r", "BufEnter *.R" },
  init = function()
    -- Expose our utility function globally
    _G.Quarto_is_in_python_chunk = M.is_in_python_chunk
    vim.b.quarto_is_python_chunk = false
    
    -- Set cell delimiter for standard code cells
    vim.g.slime_cell_delimiter = "# %%"
    
    -- Configure slime for Quarto/RMarkdown
    vim.cmd([[
    let g:slime_dispatch_ipython_pause = 100
    
    " Function to handle different language chunks
    function! SlimeOverride_EscapeText_quarto(text)
      " First call our detection function
      call v:lua.Quarto_is_in_python_chunk()
      
      " Remove any leading ```{python} or trailing ``` lines
      let text = substitute(a:text, '^\s*```{python}$\n', '', '')
      let text = substitute(text, '\n\s*```$', '', '')
      
      " Handle different modes
      if exists('g:slime_python_ipython') && len(split(text,"\n")) > 1 && b:quarto_is_python_chunk && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
        " Python code in IPython mode
        return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, text, "--", "\n"]
      elseif exists('b:quarto_is_r_mode') && b:quarto_is_r_mode && b:quarto_is_python_chunk
        " Python code in R mode (via reticulate)
        return [text, "\n"]
      else
        " Default handling
        return [text]
      endif
    endfunction
    ]])

    -- Global slime configuration
    vim.g.slime_target = "neovim"
    vim.g.slime_no_mappings = true
    vim.g.slime_python_ipython = 1
  end,
  
  config = function()
    -- Configure the terminal behavior
    vim.g.slime_input_pid = false
    vim.g.slime_suggest_default = true
    vim.g.slime_menu_config = false
    vim.g.slime_neovim_ignore_unlisted = true
    
    -- Setup terminal marking functions
    M.setup_terminal()
    
    -- Setup keymaps for sending code
    vim.keymap.set("n", "<leader><cr>", M.send_cell, {desc = "run code cell"})
    vim.keymap.set("n", "<c-cr>", M.send_cell)
    vim.keymap.set("n", "<s-cr>", M.send_cell)
    vim.keymap.set("i", "<c-cr>", M.send_cell)
    vim.keymap.set("i", "<s-cr>", M.send_cell)
  end,
}