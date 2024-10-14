return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local function isRecording()
      local reg = vim.fn.reg_recording()
      if reg == '' then
        return ''
      end
      return 'recording to ' .. reg
    end
    require('lualine').setup({
      sections = {
        lualine_a = { 'mode', { isRecording, color = 'Substitute' } },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        --[[ lualine_x = {
          {
            require('noice').api.status.message.get_hl,
            cond = require('noice').api.status.message.has,
          },
          {
            require('noice').api.status.command.get,
            cond = require('noice').api.status.command.has,
            color = { fg = '#ff9e64' },
          },
          {
            require('noice').api.status.mode.get,
            cond = require('noice').api.status.mode.has,
            color = { fg = '#ff9e64' },
          },
          {
            require('noice').api.status.search.get,
            cond = require('noice').api.status.search.has,
            color = { fg = '#ff9e64' },
          },
        }, ]]
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
    })
  end,
}
