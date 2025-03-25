-- Load core modules in specific order
local modules = {
  "keymaps", -- Global keymaps
  "options", -- Basic Vim options
  "autocommands", -- Global autocommands
  "utils", -- Utility functions
  "code_execution"
}

-- Load each module
for _, module in ipairs(modules) do
  local ok, result = pcall(require, "core." .. module)
  if not ok then
    -- If there was an error loading the module, print it
    vim.notify("Error loading module 'core." .. module .. "': " .. tostring(result), vim.log.levels.ERROR)
  end
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
