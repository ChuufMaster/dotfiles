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
      view_options = {
        show_hidden = true,
      },
    })
    vim.keymap.set('n', '<leader>-', require('oil').toggle_float, { desc = 'Open Oil in a float' })
  end,
  keys = {
    {
      '-',
      '<CMD>Oil<CR>',
      desc = 'Open Oil in parent directory',
    },
    -- {
    --   '<leader>-',
    --   require('oil').toggle_float(),
    --   desc = 'Open oil as a float',
    -- },
  },
}
