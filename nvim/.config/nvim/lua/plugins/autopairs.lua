-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
    {
        "altermo/ultimate-autopair.nvim",
        event = { "InsertEnter", "CmdlineEnter" },
        branch = "v0.6", --recommended as each new version will have breaking changes
        opts = {
            --Config goes here
            cmap = false,
        },
    },
    {
        "RRethy/nvim-treesitter-endwise",
        event = "InsertEnter",
    },
    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter",
        ft = {
            "astro",
            "glimmer",
            "handlebars",
            "html",
            "javascript",
            "jsx",
            "liquid",
            "markdown",
            "php",
            "rescript",
            "svelte",
            "tsx",
            "twig",
            "typescript",
            "vue",
            "xml",
        },
    },
    {
        "windwp/nvim-autopairs",
        -- enabled = false,
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({})
            -- local Rule = require("nvim-autopairs.rule")
            local npairs = require("nvim-autopairs")
            -- local cond = require("nvim-autopairs.conds")
            --
            -- npairs.add_rule(Rule("$", "$", { "tex", "latex" }))
            -- npairs.add_rule(Rule("|", "|", { "ruby", "eruby" }))
            -- local function rule2(a1, ins, a2, lang)
            --     npairs.add_rule(Rule(ins, ins, lang)
            --         :with_pair(function(opts)
            --             return a1 .. a2 == opts.line:sub(opts.col - #a1, opts.col + #a2 - 1)
            --         end)
            --         :with_move(cond.none())
            --         :with_cr(cond.none())
            --         :with_del(function(opts)
            --             local col = vim.api.nvim_win_get_cursor(0)[2]
            --             return a1 .. ins .. ins .. a2 == opts.line:sub(col - #a1 - #ins + 1, col + #ins + #a2) -- insert only works for #ins == 1 anyway
            --         end))
            -- end
            --
            -- rule2("(", " ", ")")
            -- rule2("[", " ", "]")
            -- rule2("{", " ", "}")
            -- rule2("$", " ", "$")
            -- rule2("|", " ", "|")
            --
            -- for _, punct in pairs({ ",", ";" }) do
            --     require("nvim-autopairs").add_rules({
            --         require("nvim-autopairs.rule")("", punct)
            --             :with_move(function(opts)
            --                 return opts.char == punct
            --             end)
            --             :with_pair(function()
            --                 return false
            --             end)
            --             :with_del(function()
            --                 return false
            --             end)
            --             :with_cr(function()
            --                 return false
            --             end)
            --             :use_key(punct),
            --     })
            -- end
            for _, i in ipairs(npairs.config.rules) do
                i.key_map = nil
            end
        end,
    },
}
