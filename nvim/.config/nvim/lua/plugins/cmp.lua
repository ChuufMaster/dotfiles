return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    enabled = false,
    lazy = false,
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
        -- "hrsh7th/cmp-emoji",
        "chrisgrieser/cmp-nerdfont",
        -- "kdheepak/cmp-latex-symbols",
        {
            "micangl/cmp-vimtex",
            ft = { "latex" },
            -- keys = {
            --     {
            --         "<M-S>",
            --         function()
            --             require("cmp_vimtex.search").perform_search({ engine = "google_scholar" })
            --         end,
            --         mode = "n",
            --         desc = "Search Latex Bib Sources Online",
            --     },
            -- },
        },
        "onsails/lspkind.nvim",
        {
            "L3MON4D3/LuaSnip",
            dependencies = {
                "rafamadriz/friendly-snippets",
            },
            build = "make install_jsregexp",
        },
        { "f3fora/cmp-spell" },
    },
    config = function(opts)
        local cmp = require("cmp")
        local compare = require("cmp.config.compare")
        local types = require("cmp.types")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")

        ---@type table<integer, integer>
        local modified_priority = {
            [types.lsp.CompletionItemKind.Variable] = types.lsp.CompletionItemKind.Method,
            [types.lsp.CompletionItemKind.Snippet] = 20, -- top
            [types.lsp.CompletionItemKind.Keyword] = 0, -- top
            [types.lsp.CompletionItemKind.Text] = 100, -- bottom
        }

        ---@param kind integer: kind of completion entry
        local function modified_kind(kind)
            return modified_priority[kind] or kind
        end
        require("luasnip.loaders.from_vscode").lazy_load()

        opts = {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "lazydev", group_index = 0 },
                { name = "luasnip", keyword_length = 3 },
                { name = "path" },
                { name = "vimtex", keyword_length = 2 },
            }, {

                {
                    name = "spell",
                    option = {
                        keep_all_entries = false,
                        enable_in_context = function(params)
                            return require("cmp.config.context").in_treesitter_capture("spell")
                        end,
                        preselect_correct_word = true,
                    },
                },
                {
                    name = "buffer",
                    keyword_length = 3,
                    option = {
                        get_bufnrs = function()
                            local bufs = vim.api.nvim_list_bufs()
                            local result = {}
                            for _, v in ipairs(bufs) do
                                local byt_size = vim.api.nvim_buf_get_offset(v, vim.api.nvim_buf_line_count(v))
                                if byt_size < 1024 * 1024 then
                                    result[#result + 1] = v
                                end
                            end
                            return result
                            --[[ for _, win in ipairs(vim.api.nvim_list_wins()) do
                                bufs[vim.api.nvim_win_get_buf(win)] = true
                            end
                            return vim.tbl_keys(bufs) ]]
                        end,
                    },
                },
                -- { name = "emoji" },
                { name = "nerdfont" },
                -- { name = "latex_symbols" },
            }),
            formatting = {
                format = lspkind.cmp_format({
                    maxwidth = {
                        menu = 30,
                        abbr = 30,
                    },
                    ellipsis_char = "...",
                    show_labelDetails = true,
                }),
            },
            sorting = {
                comparators = {
                    function(entry1, entry2) -- score by lsp, if available
                        local t1 = entry1.completion_item.sortText
                        local t2 = entry2.completion_item.sortText
                        if t1 ~= nil and t2 ~= nil and t1 ~= t2 then
                            return t1 < t2
                        end
                    end,
                    compare.exact,
                    compare.recently_used,
                    function(entry1, entry2) -- sort by compare kind (Variable, Function etc)
                        local kind1 = modified_kind(entry1:get_kind())
                        local kind2 = modified_kind(entry2:get_kind())
                        if kind1 ~= kind2 then
                            return kind1 - kind2 < 0
                        end
                    end,
                    compare.score,
                    compare.order,
                    function(entry1, entry2) -- sort by length ignoring "=~"
                        local len1 = string.len(string.gsub(entry1.completion_item.label, "[=~()_]", ""))
                        local len2 = string.len(string.gsub(entry2.completion_item.label, "[=~()_]", ""))
                        if len1 ~= len2 then
                            return len1 - len2 < 0
                        end
                    end,
                },
            },
            view = {
                entries = { name = "custom", selection_order = "near_cursor" },
            },
            completion = {
                completeopt = "menuone,preview,noinsert",
            },
            window = {
                documentation = cmp.config.window.bordered(),
                completion = cmp.config.window.bordered(),
            },
            -- preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
            mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.expandable() then
                        luasnip.expand()
                    elseif luasnip.jumpable(1) then
                        luasnip.jump(1)
                        --NOTE:look at tabout for tabbing out of brackets and such
                        -- elseif vim.api.nvim_get_mode().mode == 'i' then
                        --     tabout.tabout()
                    elseif cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    elseif cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<C-Space>"] = cmp.mapping.complete({}),
                ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                ["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ["<C-CR>"] = function(fallback)
                    cmp.abort()
                    fallback()
                end,
            }),
        }

        cmp.setup(opts)

        --[[ cmp.setup.filetype("tex", {
            sources = {
                { name = "vimtex" },
                { name = "buffer" },
            },
        }) ]]
        -- `/` cmdline setup.
        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline({
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
            }),
            sources = {
                { name = "buffer" },
            },
        })
        -- `:` cmdline setup.
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline({
                ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                ["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
            }),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                {
                    name = "cmdline",
                    option = {
                        ignore_cmds = { "Man", "!" },
                    },
                },
            }),
        })
    end,
}
