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
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                    require("config.snippets")
                    vim.keymap.set("s", "<C-c>", function()
                        require("luasnip.extras.select_choice")()
                    end, {})
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
                default = function(ctx)
                    local default_sources = {
                        "lsp",
                        "lazydev",
                        "easy-dotnet",
                        "path",
                        "snippets",
                        "buffer",
                        "omni",
                    }
                    local ft = vim.bo.filetype
                    if ft == "lua" then
                        return vim.tbl_extend("keep", { "lazydev" }, default_sources)
                    elseif ft == "markdown" then
                        return vim.tbl_extend("keep", { "dictionary", "spell" }, default_sources)
                    elseif ft == "csharp" then
                        return vim.tbl_extend("keep", { "easy-dotnet" }, default_sources)
                    end
                    return default_sources
                end,
                per_filetype = {
                    lua = { "lazydev" },
                    markdown = { "lsp", "snippets", "dictionary", "buffer", "spell", "path", "omni" },
                    csharp = { "easy-dotnet" },
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
