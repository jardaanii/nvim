-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim
return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    { '<leader>bb', ':Neotree filesystem reveal left<CR>', desc = 'NeoTree filesystem left', silent = true },
    { '<leader>bf', ':Neotree buffers reveal float<CR>', desc = 'NeoTree buffers float', silent = true },
  },
  opts = {
    close_if_last_window = false,
    enable_git_status = true,
    enable_diagnostics = true,
    filesystem = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
    buffers = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
    },
    event_handlers = {
      {
        event = 'file_opened',
        handler = function(file_path)
          -- auto close
          -- vimc.cmd("Neotree close")
          -- OR
          require('neo-tree.command').execute { action = 'close' }
        end,
      },
    },
  },
}
