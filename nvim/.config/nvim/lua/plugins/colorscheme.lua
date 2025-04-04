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
            -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
            -- vim.cmd.colorscheme("tokyonight-night")

            vim.api.nvim_set_hl(0, "CursorLine", { underline = true, bg = "#292e42" })
            require("tokyonight").setup({
                -- use the night style
                style = "day",
                -- disable italic for functions
                styles = {
                    functions = {},
                },
                -- Change the "hint" color to the "orange" color, and make the "error" color bright red
                on_colors = function(colors)
                    colors.bg = "#000000"
                    -- colors.comment = "#ffffff"
                end,
            })
            vim.cmd.colorscheme("tokyonight-night")
            vim.cmd("hi ColorColumn ctermbg=white guibg=darkcyan")
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1001,
    },
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
