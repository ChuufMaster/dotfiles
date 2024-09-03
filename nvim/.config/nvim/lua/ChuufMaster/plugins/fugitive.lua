return {
  'tpope/vim-fugitive',
  lazy = false,
  event = 'VimEnter',
  config = function()
    --[[ vim.keymap.set('n', '<leader>gs', function()
      vim.cmd('Git add .')
      local input = vim.fn.input('Commit Message: ')
      vim.cmd('Git commit -m"' .. input .. '"')
    end, { desc = 'Stage all files and write commit message' })

    vim.keymap.set('n', '<leader>gS', function()
      vim.cmd('Git add .')
      local input = vim.fn.input('Commit Message: ')
      vim.cmd('Git commit -m"' .. input .. '"')
      vim.cmd('Git push')
    end, { desc = 'Stage all files, add a commit message and push' }) ]]
  end,
  keys = {
    {
      '<leader>gs',
      function()
        vim.cmd('Git add .')
        local input = vim.fn.input('Commit Message: ')
        vim.cmd('Git commit -m"' .. input .. '"')
      end,
      desc = 'Stage all files and write commit message',
    },
    {
      '<leader>gS',
      function()
        vim.cmd('Git add .')
        local input = vim.fn.input('Commit Message: ')
        vim.cmd('Git commit -m"' .. input .. '"')
        vim.cmd('Git push')
      end,
      desc = 'Stage all files, add a commit message and push',
    },
  },
}
