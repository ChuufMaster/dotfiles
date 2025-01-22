return {
    {
        "3rd/image.nvim",
        enabled = false,
        ft = { "markdown" },
        config = function()
            local opts = {
                backend = "kitty",
                kitty_method = "normal",
                integrations = {
                    markdown = {
                        enabled = true,
                        clear_in_insert_mode = true,
                        download_remote_images = true,
                        only_render_image_at_cursor = true,
                        filetypes = { "markdown", "vimwiki" },
                    },
                    neorg = {
                        enabled = true,
                        clear_in_insert_mode = false,
                        download_remote_images = true,
                        only_render_image_at_cursor = false,
                        filetypes = { "norg" },
                    },
                    html = {
                        enabled = true,
                    },
                    css = {
                        enabled = true,
                    },
                },
                max_width = nil,
                max_height = nil,
                max_width_window_percentage = nil,

                max_height_window_percentage = 40,

                window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
                window_overlap_clear_ft_ignore = {
                    "cmp_menu",
                    "cmp_docs",
                    "snacks_notif",
                    "scrollview",
                    "scrollview_sign",
                },

                editor_only_render_when_focused = true,

                tmux_show_only_in_active_window = true,

                hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
            }
            require("image").setup(opts)
            package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua"
            package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua"
        end,
        --[[ config = function()
      require('image').setup()
    end, ]]
    },
    {
        "HakonHarnes/img-clip.nvim",
        -- event = 'VeryLazy',
        ft = { "markdown" },
        enabled = false,
        opts = {
            -- add options here
            -- or leave it empty to use the default settings
            default = {
                use_absolute_path = false,
                relative_to_current_file = true,

                dir_path = function()
                    return vim.fn.expand("%:t:r") .. "-img"
                end,
                prompt_for_file_name = false, ---@type boolean
                file_name = "%Y-%m-%d-at-%H-%M-%S", ---@type string
                extension = "jpg", ---@type string
                process_cmd = "convert - -quality 75 jpg:-", ---@type string
            },
            filtypes = {
                markdown = {
                    url_encode_path = true,
                    template = "![$FILE_NAME]($FILE_PATH)",
                },
            },
        },
        keys = {
            -- suggested keymap
            { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
        },
    },
}
