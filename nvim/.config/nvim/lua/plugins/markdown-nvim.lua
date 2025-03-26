local markdown_plugins = {
    {
        "iamcco/markdown-preview.nvim",
        enabled = false,
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    {
        "ChuufMaster/markdown-toc",
        opts = {
            ask_for_heading_level = true,
        },
        lazy = true,
        dev = false,
        ft = "markdown",
    },
    {
        "bullets-vim/bullets.vim",
        ft = { "markdown" },
        -- init = function()
        --     vim.g.bullets_mapping_leader = "\\"
        -- end,
    },
    {
        "OXY2DEV/markview.nvim",
        branch = "dev",
        enabled = true,
        ft = { "markdown", "yaml", "yaml.ansible" },
        -- lazy = false,
        ---@module "markview"
        ---@type mkv.config
        opts = {
            preview = {
                enable = true,
                modes = { "n", "no", "c" },
                -- filetypes = { "markdown", "yaml", "yaml.ansible" },
                filetypes = { "markdown", "yaml" },
                -- hybrid_modes = { "n", "no", "c" },
                -- linewise_hybrid_mode = true,
            },
            yaml = {
                enable = true,
            },
            markdown = {
                list_items = {
                    shift_width = function(buffer, item)
                        --- Reduces the `indent` by 1 level.
                        ---
                        ---         indent                      1
                        --- ------------------------- = 1 ÷ --------- = new_indent
                        --- indent * (1 / new_indent)       new_indent
                        ---
                        local parent_indnet = math.max(1, item.indent - vim.bo[buffer].shiftwidth)

                        return item.indent * (1 / (parent_indnet * 2))
                    end,
                    marker_minus = {
                        add_padding = function(_, item)
                            return item.indent > 1
                        end,
                    },
                },
            },
        },
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        enabled = false,
        name = "render-markdown",
        dependencies = { "nvim-treesitter" },
        ft = "markdown",
        -- cmd = { "RenderMarkdownToggle" },
        ---@type render.md.Config
        ---@diagnostic disable-next-line: missing-fields
        opts = {
            win_options = {
                conceallevel = {
                    default = vim.api.nvim_get_option_value("conceallevel", {}),
                    rendered = 3,
                },
            },
            pipe_table = {
                style = "normal",
            },
        },
        --[[ config = function()
            require("render-markdown").setup({
                win_options = {
                    -- conceallevel = {
                    --   defualt = vim.api.nvim_get_option_value('conceallevel', {}),
                    --   rendered = 2,
                    -- },
                },

                vim.keymap.set(
                    "n",
                    "<leader>tm",
                    "<cmd>RenderMarkdownToggle<CR>",
                    { desc = "[T]oggle [M]arkdown-render" }
                ),
            })
        end, ]]
        keys = {
            {
                "<lead>tm",
                "<cmd>RenderMarkdownToggle<CR>",
                desc = "[T]oggle [M]arkdown-render",
            },
        },
    },
}

local tadmccorkle_markdown = {
    "tadmccorkle/markdown.nvim",
    ft = "markdown", -- or 'event = "VeryLazy"'
    opts = {
        -- configuration here or empty for defaults
        -- Disable all keymaps by setting mappings field to 'false'.
        -- Selectively disable keymaps by setting corresponding field to 'false'.
        mappings = {
            inline_surround_toggle = "gs", -- (string|boolean) toggle inline style
            inline_surround_toggle_line = "gss", -- (string|boolean) line-wise toggle inline style
            inline_surround_delete = "ds", -- (string|boolean) delete emphasis surrounding cursor
            inline_surround_change = "cs", -- (string|boolean) change emphasis surrounding cursor
            link_add = "gl", -- (string|boolean) add link
            link_follow = "gx", -- (string|boolean) follow link
            go_curr_heading = "]c", -- (string|boolean) set cursor to current section heading
            go_parent_heading = "]p", -- (string|boolean) set cursor to parent section heading
            go_next_heading = "]]", -- (string|boolean) set cursor to next section heading
            go_prev_heading = "[[", -- (string|boolean) set cursor to previous section heading
        },
        inline_surround = {
            -- For the emphasis, strong, strikethrough, and code fields:
            -- * 'key': used to specify an inline style in toggle, delete, and change operations
            -- * 'txt': text inserted when toggling or changing to the corresponding inline style
            emphasis = {
                key = "i",
                txt = "*",
            },
            strong = {
                key = "b",
                txt = "**",
            },
            strikethrough = {
                key = "s",
                txt = "~~",
            },
            code = {
                key = "c",
                txt = "`",
            },
        },
        link = {
            paste = {
                enable = true, -- whether to convert URLs to links on paste
            },
        },
        toc = {
            -- Comment text to flag headings/sections for omission in table of contents.
            omit_heading = "toc omit heading",
            omit_section = "toc omit section",
            -- Cycling list markers to use in table of contents.
            -- Use '.' and ')' for ordered lists.
            markers = { "-" },
        },
        -- Hook functions allow for overriding or extending default behavior.
        -- Called with a table of options and a fallback function with default behavior.
        -- Signature: fun(opts: table, fallback: fun())
        hooks = {
            -- Called when following links. Provided the following options:
            -- * 'dest' (string): the link destination
            -- * 'use_default_app' (boolean|nil): whether to open the destination with default application
            --   (refer to documentation on <Plug> mappings for explanation of when this option is used)
            follow_link = nil,
        },
        on_attach = function(bufnr)
            local map = vim.keymap.set
            local opts = { buffer = bufnr }
            map({ "n", "i" }, "<M-a><M-o>", "<Cmd>MDListItemBelow<CR>", opts)
            map({ "n", "i" }, "<M-A><M-O>", "<Cmd>MDListItemAbove<CR>", opts)
            map("n", "<M-c>", "<Cmd>MDTaskToggle<CR>", opts)
            map("x", "<M-c>", ":MDTaskToggle<CR>", opts)
        end,
    },
}

return markdown_plugins
