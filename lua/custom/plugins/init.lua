-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- Mason to install gopls
  {
    'williamboman/mason.nvim',
    opts = {
      ensure_installed = { 'gopls' },
    },
  },

  -- Mason LSP bridge
  {
    'williamboman/mason-lspconfig.nvim',
    opts = {
      ensure_installed = { 'gopls' },
    },
  },

  -- LSP config
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require 'lspconfig'
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      lspconfig.gopls.setup {
        capabilities = capabilities,
        settings = {
          gopls = {
            gofumpt = true,
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
            usePlaceholders = true,
            completeUnimported = true, -- auto-import suggestions
            importShortcut = 'Both',
          },
        },
        flags = {
          debounce_text_changes = 150,
        },
        on_attach = function(client, bufnr)
          -- Auto-organize imports on every change
          if client.server_capabilities.codeActionProvider then
            local group = vim.api.nvim_create_augroup('GoOrganizeImports', { clear = true })
            vim.api.nvim_create_autocmd('TextChanged', {
              group = group,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.code_action {
                  context = { only = { 'source.organizeImports' } },
                  apply = true,
                }
              end,
            })
          end
        end,
      }
    end,
  },

  -- Completion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
    },
    config = function()
      local cmp = require 'cmp'
      cmp.setup {
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm { select = true },
        },
        sources = cmp.config.sources {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
        },
      }
    end,
  },

  -- Formatter
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        go = { 'gofumpt', 'goimports' },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    },
    config = function(_, opts)
      require('conform').setup(opts)

      -- Format on save for Go
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*.go',
        callback = function()
          require('conform').format { bufnr = 0 }
        end,
      })

      -- Auto format + fix imports after paste
      vim.api.nvim_create_autocmd('TextYankPost', {
        pattern = '*.go',
        callback = function()
          require('conform').format { bufnr = 0 }
          vim.lsp.buf.code_action {
            context = { only = { 'source.organizeImports' } },
            apply = true,
          }
        end,
      })
    end,
  },
}
