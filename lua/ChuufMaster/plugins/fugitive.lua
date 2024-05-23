return {
  'tpope/vim-fugitive',
  lazy = false,
  event = 'VimEnter',
  config = function()
    vim.keymap.set('n', '<leader>gs', function()
      vim.cmd 'Git add .'
      local input = vim.fn.input 'Commit Message: '
      vim.cmd('Git commit -m"' .. input .. '"')
    end, { desc = 'Stage all files and write commit message' })
  end,
}
