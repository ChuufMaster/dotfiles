-- local functions
local function set_file_type(_pattern, _filetype)
  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufEnter' }, {
    pattern = { _pattern },
    command = 'set filetype=' .. _filetype,
  })
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = 'config.kbd',
  callback = function()
    print('filtype kanata detected')
  end,
})

-- Hyprlang LSP
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { '*.hl', 'hypr*.conf', '*/hypr/*.conf' },
  callback = function(event)
    print(string.format('starting hyprls for %s', vim.inspect(event)))
    vim.lsp.start({
      name = 'hyprlang',
      cmd = { 'hyprls' },
      root_dir = vim.fn.getcwd(),
    })
  end,
})

set_file_type('*/hypr/*.conf', 'hyprlang')
set_file_type('*.kbd', 'scheme')
set_file_type('*.rasi', 'rasi')
