local orgmode = require("plugins.orgmode")
return {
    {
        "saghen/blink.cmp",
        dependencies = {
            "onsails/lspkind.nvim",
            {
                "L3MON4D3/LuaSnip",
                dependencies = {
                    { "rafamadriz/friendly-snippets" },
                },
                build = "make install_jsregexp",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                    require("config.snippets")
                    vim.keymap.set("s", "<C-c>", function()
                        require("luasnip.extras.select_choice")()
                    end, {})
                    require("luasnip").config.setup({
                        region_check_events = "CursorHold,InsertLeave,InsertEnter",
                        delete_check_events = "TextChanged,InsertEnter",
                    })
                end,
            },
            "ribru17/blink-cmp-spell",
            "flke/lazydev.nvim",
            {
                "Kaiser-Yang/blink-cmp-dictionary",
                dependencies = { "nvim-lua/plenary.nvim" },
            },
        },
        version = "*",
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = "enter",
            },
            snippets = {
                preset = "luasnip",
            },
            completion = {
                menu = {
                    draw = {
                        columns = {
                            { "label", "label_description", gap = 1 },
                            { "kind_icon", "kind", gap = 1 },
                            { "source_name" },
                        },
                    },
                },
                documentation = {
                    auto_show = true,
                },
                accept = {
                    auto_brackets = {
                        enabled = true,
                    },
                },
            },
            sources = {
                providers = {
                    spell = {
                        name = "Spell",
                        module = "blink-cmp-spell",
                    },
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                    ["easy-dotnet"] = {
                        name = "easy-dotnet",
                        enabled = true,
                        module = "easy-dotnet.completion.blink",
                        score_offset = 10000,
                        async = true,
                    },
                    dictionary = {
                        module = "blink-cmp-dictionary",
                        name = "Dict",
                        min_keyword_length = 3,
                        max_items = 8,
                        opts = {
                            dictionary_directories = { vim.fn.expand("~/.dictionaries") },
                        },
                    },
                },
                default = {
                    "lsp",
                    "path",
                    "snippets",
                    "buffer",
                    "omni",
                },
                per_filetype = {
                    lua = { "lazydev", inherit_defaults = true },
                    csharp = { "easy-dotnet", inherit_defaults = true },
                },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" },
            cmdline = {
                enabled = true,
                sources = { "buffer", "cmdline" },
                completion = {
                    trigger = {
                        show_on_blocked_trigger_characters = {},
                        show_on_x_blocked_trigger_characters = {},
                    },
                    list = {
                        selection = {
                            preselect = true,
                            auto_insert = true,
                        },
                    },
                    menu = { auto_show = true },
                    ghost_text = { enabled = true },
                },
            },
        },
    },
}
