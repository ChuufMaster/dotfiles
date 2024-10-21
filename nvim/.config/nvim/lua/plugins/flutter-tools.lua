return {
  'akinsho/flutter-tools.nvim',
  ft = { 'dart' },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim', -- optional for vim.ui.select
  },
opts = function()
        pcall(require("telescope").load_extension, "flutter")
    end,
  config = true,
}
