local kinds = {
    Array = " ",
    Boolean = "󰨙 ",
    Class = " ",
    Codeium = "󰘦 ",
    Color = " ",
    Control = " ",
    Collapsed = " ",
    Constant = "󰏿 ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = "󰊕 ",
    Interface = " ",
    Key = " ",
    Keyword = " ",
    Method = "󰊕 ",
    Module = " ",
    Namespace = "󰦮 ",
    Null = " ",
    Number = "󰎠 ",
    Object = " ",
    Operator = " ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Snippet = " ",
    String = " ",
    Struct = "󰆼 ",
    TabNine = "󰏚 ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = "󰀫 ",
}

local old = { -- Autocompletion
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    enabled = false,
    dependencies = {
        -- Snippet Engine & its associated nvim-cmp source
        {
            "L3MON4D3/LuaSnip",
            build = (function()
                -- Build Step is needed for regex support in snippets.
                -- This step is not supported in many windows environments.
                -- Remove the below condition to re-enable on windows.
                if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                    return
                end
                return "make install_jsregexp"
            end)(),
            dependencies = {
                -- `friendly-snippets` contains a variety of premade snippets.
                --    See the README about individual language/framework/plugin snippets:
                --    https://github.com/rafamadriz/friendly-snippets
                -- {
                --   'rafamadriz/friendly-snippets',
                --   config = function()
                --     require('luasnip.loaders.from_vscode').lazy_load()
                --   end,
                -- },
            },
        },
        "saadparwaiz1/cmp_luasnip",

        -- Adds other completion capabilities.
        --  nvim-cmp does not ship with all sources by default. They are split
        --  into multiple repos for maintenance purposes.
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
    },
    config = function()
        -- See `:help cmp`
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        luasnip.config.setup({})

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            completion = { completeopt = "menu,menuone,noinsert" },

            -- For an understanding of why these mappings were
            -- chosen, you will need to read `:help ins-completion`
            --
            -- No, but seriously. Please read `:help ins-completion`, it is really good!
            mapping = cmp.mapping.preset.insert({
                -- Select the [n]ext item
                -- ['<C-n>'] = cmp.mapping.select_next_item(),
                -- Select the [p]revious item
                -- ['<C-p>'] = cmp.mapping.select_prev_item(),

                -- Scroll the documentation window [b]ack / [f]orward
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),

                -- Accept ([y]es) the completion.
                --  This will auto-import if your LSP supports it.
                --  This will expand snippets if the LSP sent a snippet.
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),

                -- If you prefer more traditional completion keymaps,
                -- you can uncomment the following lines
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<Tab>"] = cmp.mapping.select_next_item(),
                ["<S-Tab>"] = cmp.mapping.select_prev_item(),

                -- Manually trigger a completion from nvim-cmp.
                --  Generally you don't need this, because nvim-cmp will display
                --  completions whenever it has completion options available.
                ["<C-Space>"] = cmp.mapping.complete({}),
                -- Think of <c-l> as moving to the right of your snippet expansion.
                --  So if you have a snippet that's like:
                --  function $name($args)
                --    $body
                --  end
                --
                -- <c-l> will move you to the right of each of the expansion locations.
                -- <c-h> is similar, except moving you backwards.
                -- ['<C-l>'] = cmp.mapping(function()
                --   if luasnip.expand_or_locally_jumpable() then
                --     luasnip.expand_or_jump()
                --   end
                -- end, { 'i', 's' }),
                -- ['<C-h>'] = cmp.mapping(function()
                --   if luasnip.locally_jumpable(-1) then
                --     luasnip.jump(-1)
                --   end
                -- end, { 'i', 's' }),

                -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
                --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
            }),
            sources = {
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "path" },
            },
        })
    end,
}

local new = {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-emoji",
            "chrisgrieser/cmp-nerdfont",
            "saadparwaiz1/cmp_luasnip",
            "kdheepak/cmp-latex-symbols",
        },
        opts = function()
            vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
            local cmp = require("cmp")
            local defaults = require("cmp.config.default")()
            local compare = require("cmp.config.compare")
            local types = require("cmp.types")
            local auto_select = true
            ---@type table<integer, integer>
            local modified_priority = {
                [types.lsp.CompletionItemKind.Variable] = types.lsp.CompletionItemKind.Method,
                [types.lsp.CompletionItemKind.Snippet] = 0, -- top
                [types.lsp.CompletionItemKind.Keyword] = 0, -- top
                [types.lsp.CompletionItemKind.Text] = 100, -- bottom
            }
            ---@param kind integer: kind of completion entry
            local function modified_kind(kind)
                return modified_priority[kind] or kind
            end

            -- `/` cmdline setup.
            cmp.setup.cmdline("/", {
                preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
                mapping = cmp.mapping.preset.cmdline({

                    ["<CR>"] = cmp.mapping.confirm({ select = auto_select }),
                }),
                sources = {
                    { name = "buffer" },
                },
            })
            -- `:` cmdline setup.
            cmp.setup.cmdline(":", {
                preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
                mapping = cmp.mapping.preset.cmdline({
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
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
            return {
                auto_brackets = {},
                completion = {
                    completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
                },
                window = {
                    documentation = cmp.config.window.bordered(),
                    completion = cmp.config.window.bordered(),
                },
                preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-Space>"] = cmp.mapping.complete({}),
                    ["<CR>"] = cmp.mapping.confirm({ select = auto_select }),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                    ["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<C-CR>"] = function(fallback)
                        cmp.abort()
                        fallback()
                    end,
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    {
                        name = "buffer",
                        keyword_length = 5,
                        option = {
                            get_bufnrs = function()
                                local bufs = {}
                                for _, win in ipairs(vim.api.nvim_list_wins()) do
                                    bufs[vim.api.nvim_win_get_buf(win)] = true
                                end
                                return vim.tbl_keys(bufs)
                            end,
                        },
                    },
                    { name = "emoji" },
                    { name = "nerdfont" },
                    { name = "latex_symbols" },
                    { name = "path" },
                }),
                formatting = {
                    format = function(entry, item)
                        local icons = kinds
                        if icons[item.kind] then
                            item.kind = icons[item.kind] .. item.kind
                        end

                        local widths = {
                            abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
                            menu = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 30,
                        }

                        for key, width in pairs(widths) do
                            if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                                item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
                            end
                        end
                        return item
                    end,
                },
                sorting = {
                    comparators = {
                        compare.exact,
                        function(entry1, entry2) -- sort by length ignoring "=~"
                            local len1 = string.len(string.gsub(entry1.completion_item.label, "[=~()_]", ""))
                            local len2 = string.len(string.gsub(entry2.completion_item.label, "[=~()_]", ""))
                            if len1 ~= len2 then
                                return len1 - len2 < 0
                            end
                        end,
                        compare.recently_used,
                        function(entry1, entry2) -- sort by compare kind (Variable, Function etc)
                            local kind1 = modified_kind(entry1:get_kind())
                            local kind2 = modified_kind(entry2:get_kind())
                            if kind1 ~= kind2 then
                                return kind1 - kind2 < 0
                            end
                        end,
                        function(entry1, entry2) -- score by lsp, if available
                            local t1 = entry1.completion_item.sortText
                            local t2 = entry2.completion_item.sortText
                            if t1 ~= nil and t2 ~= nil and t1 ~= t2 then
                                return t1 < t2
                            end
                        end,
                        compare.score,
                        compare.order,
                    },
                },
            }
        end,
    },
    {
        "nvim-cmp",
        dependencies = {
            {
                "garymjr/nvim-snippets",
                opts = {
                    friendly_snippets = true,
                },
                dependencies = { "rafamadriz/friendly-snippets" },
            },
        },
        opts = function(_, opts)
            opts.snippet = {
                expand = function(item)
                    return LazyVim.cmp.expand(item.body)
                end,
            }
            if LazyVim.has("nvim-snippets") then
                table.insert(opts.sources, { name = "snippets" })
            end
        end,
        keys = {
            {
                "<Tab>",
                function()
                    return vim.snippet.active({ direction = 1 }) and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>"
                end,
                expr = true,
                silent = true,
                mode = { "i", "s" },
            },
            {
                "<S-Tab>",
                function()
                    return vim.snippet.active({ direction = -1 }) and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<S-Tab>"
                end,
                expr = true,
                silent = true,
                mode = { "i", "s" },
            },
        },
    },
}
return new
