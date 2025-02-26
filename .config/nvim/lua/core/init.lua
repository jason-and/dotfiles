-- Load core modules in specific order
local modules = {
  "options",   -- Basic Vim options
  "autocmds",  -- Global autocommands
  "keymaps",   -- Global keymaps
  "utils"      -- Utility functions
}

-- Load each module
for _, module in ipairs(modules) do
  local ok, err = pcall(require, "core/" .. module)
end

-- Return the module for use in other places
return {
  -- Add core constants or functions that should be available globally
  constants = {
    CONFIG_PATH = vim.fn.stdpath('config'),
    DATA_PATH = vim.fn.stdpath('data'),
    CACHE_PATH = vim.fn.stdpath('cache'),
  }
}