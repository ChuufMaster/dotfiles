return { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    {
        "folke/tokyonight.nvim",
        priority = 1001, -- Make sure to load this before all the other start plugins.
        -- enabled = false,
        init = function()
            vim.api.nvim_set_hl(0, "CursorLine", { underline = true, bg = "#292e42" })
            require("tokyonight").setup({
                -- use the night style
                style = "storm",
                -- disable italic for functions
                styles = {
                    functions = {},
                },
                on_colors = function(colors)
                    colors.bg = "#000000"
                    -- colors.comment = "#ffffff"
                end,
            })
            -- vim.cmd.colorscheme("tokyonight")
            -- vim.cmd("hi ColorColumn ctermbg=white guibg=darkcyan")
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1001,
    },
    { "ellisonleao/gruvbox.nvim", priority = 1000, config = true, opts = ... },
    {
        "uZer/pywal16.nvim",
        priority = 1000, -- Make sure to load this before all the other start plugins.
        enabled = false,
        config = true,
        init = function()
            vim.cmd.colorscheme("pywal16")
            vim.cmd.hi("Comment gui=none")
        end,
    },
}
