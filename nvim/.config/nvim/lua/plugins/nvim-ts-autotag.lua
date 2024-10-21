return {
  'windwp/nvim-ts-autotag',
  config = function()
    require('nvim-ts-autotag').setup({
      aliases = {
        ['cshtml'] = 'html',
        ['cs.html.razor'] = 'html',
      },
    })
  end,
}
