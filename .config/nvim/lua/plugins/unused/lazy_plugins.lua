
-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update

-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  
  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  -- modular approach: using `require 'path/name'` will
  -- include a plugin definition from file lua/path/name.lua


-- UI

  require('plugins/ui/kanagawa'),

  require('plugins/ui/welcome-screen'),

  require('plugins/ui/mini'),

-- editor

  require('plugins/editor/autopairs'),

  require('plugins/editor/treesitter'),

  require('plugins/editor/lspconfig'),

  require('plugins/editor/conform'),

  require('plugins/editor/cmp'),

  require('plugins/editor/sleuth'),

  require('plugins/editor/comment'),

-- data science

 require('plugins/data_science/quarto'),
 require('plugins/data_science/slime'),

-- tools

  require('plugins/tools/which-key'),

  require('plugins/tools/telescope'),
 
  require('plugins/tools/todo-comments'),

  require('plugins/tools/oil'),

  require('plugins/tools/neo-tree'),

  require('plugins/tools/nvim-tree'),

  require('plugins/tools/gx'),

  require('plugins/tools/toggleterm'), 

  require('plugins/tools/git'),

  require('plugins/tools/workspaces')

},

{
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
