return {
  'stevearc/oil.nvim',
  opts = {},
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('oil').setup({
      default_file_explorer = true,
      ['<C-h>'] = false,
      ['<C-s>'] = false,
      ['\\'] = false,
      view_options = {
        show_hidden = true,
      },

      keymaps = {
        ['<Esc>'] = { callback = 'actions.close', mode = 'n' },
      },
    })
    vim.keymap.set('n', '<leader>-', require('oil').toggle_float, { desc = 'Open Oil in a float' })
  end,
  keys = {
    {
      '-',
      function()
        require('oil').toggle_float()
      end,
      desc = 'Open Oil in parent directory',
    },
    -- {
    --   '<leader>-',
    --   require('oil').toggle_float(),
    --   desc = 'Open oil as a float',
    -- },
  },
}
