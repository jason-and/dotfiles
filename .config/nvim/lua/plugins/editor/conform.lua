return {
  {  -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format({ 
            async = true, 
            lsp_format = 'fallback' 
          })
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable for languages without standardized coding style
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { "isort", "black" },  -- Run multiple formatters sequentially
        quarto = { 'injected' },
      },
    },
    config = function()
      -- Customize the "injected" formatter
      require('conform').formatters.injected = {
        options = {
          ignore_errors = false,
          lang_to_ext = {
            bash = 'sh',
            c_sharp = 'cs',
            elixir = 'exs',
            javascript = 'js',
            julia = 'jl',
            latex = 'tex',
            markdown = 'md',
            python = 'py',
            ruby = 'rb',
            rust = 'rs',
            teal = 'tl',
            r = 'r',
            typescript = 'ts',
          },
          lang_to_formatters = {},
        },
      }
    end,
  }
}
-- vim: ts=2 sts=2 sw=2 et
