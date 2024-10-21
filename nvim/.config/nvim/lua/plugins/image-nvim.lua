return {
  {
    '3rd/image.nvim',
    ft = { 'markdown' },
    opts = {
      backend = 'kitty',
      kitty_method = 'normal',
      integrations = {
        -- Notice these are the settings for markdown files
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          -- Set this to false if you don't want to render images coming from
          -- a URL
          download_remote_images = true,
          -- Change this if you would only like to render the image where the
          -- cursor is at
          -- I set this to true, because if the file has way too many images
          -- it will be laggy and will take time for the initial load
          only_render_image_at_cursor = true,
          -- markdown extensions (ie. quarto) can go here
          filetypes = { 'markdown', 'vimwiki' },
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { 'norg' },
        },
        -- This is disabled by default
        -- Detect and render images referenced in HTML files
        -- Make sure you have an html treesitter parser installed
        -- ~/github/dotfiles-latest/neovim/nvim-lazyvim/lua/plugins/treesitter.lua
        html = {
          enabled = true,
        },
        -- This is disabled by default
        -- Detect and render images referenced in CSS files
        -- Make sure you have a css treesitter parser installed
        -- ~/github/dotfiles-latest/neovim/nvim-lazyvim/lua/plugins/treesitter.lua
        css = {
          enabled = true,
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,

      -- This is what I changed to make my images look smaller, like a
      -- thumbnail, the default value is 50
      -- max_height_window_percentage = 20,
      max_height_window_percentage = 40,

      -- toggles images when windows are overlapped
      window_overlap_clear_enabled = false,
      window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },

      -- auto show/hide images when the editor gains/looses focus
      editor_only_render_when_focused = true,

      -- auto show/hide images in the correct tmux window
      -- In the tmux.conf add `set -g visual-activity off`
      tmux_show_only_in_active_window = true,

      -- render image files as images when opened
      hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' },
    },
    --[[ config = function()
      require('image').setup()
    end, ]]
  },
  {
    'HakonHarnes/img-clip.nvim',
    -- event = 'VeryLazy',
    ft = { 'markdown' },
    opts = {
      -- add options here
      -- or leave it empty to use the default settings
      default = {
        use_absolute_path = false,
        relative_to_current_file = true,

        dir_path = function()
          return vim.fn.expand('%:t:r') .. '-img'
        end,
        prompt_for_file_name = false, ---@type boolean
        file_name = '%Y-%m-%d-at-%H-%M-%S', ---@type string
        extension = 'avif', ---@type string
        process_cmd = 'convert - -quality 75 avif:-', ---@type string
      },
      filtypes = {
        markdown = {
          url_encode_path = true,
          template = '![$FILE_NAME]($FILE_PATH)',
        },
      },
    },
    keys = {
      -- suggested keymap
      { '<leader>p', '<cmd>PasteImage<cr>', desc = 'Paste image from system clipboard' },
    },
  },
}
