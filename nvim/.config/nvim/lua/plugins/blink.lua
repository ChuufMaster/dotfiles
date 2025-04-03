return {
    {
        "saghen/blink.cmp",
        dependencies = {
            "onsails/lspkind.nvim",
            "L3MON4D3/LuaSnip",
            "ribru17/blink-cmp-spell",
            "flke/lazydev.nvim",
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
                },
                default = {
                    "lazydev",
                    "lsp",
                    "easy-dotnet",
                    "path",
                    "snippets",
                    "buffer",
                    "spell",
                },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" },
            cmdline = {
                enabled = true,
                ---@type function|table
                sources = function()
                    local type = vim.fn.getcmdtype()
                    if type == "/" or type == "?" then
                        return { "buffer" }
                    end
                    if type == ":" or type == "@" then
                        return { "cmdline" }
                    end
                    return {}
                end,
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
