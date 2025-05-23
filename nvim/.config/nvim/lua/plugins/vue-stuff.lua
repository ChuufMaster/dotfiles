return {
    -- tailwind-tools.lua
    {
        "luckasRanarison/tailwind-tools.nvim",
        name = "tailwind-tools",
        build = ":UpdateRemotePlugins",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim", -- optional
            "neovim/nvim-lspconfig", -- optional
        },
        opts = {}, -- your configuration
    },
    {
        "pmizio/typescript-tools.nvim",
        event = "LspAttach",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "neovim/nvim-lspconfig",
            {
                "saghen/blink.cmp",
                -- Ensure blink.cmp is loaded before typescript-tools
                lazy = false,
                priority = 1000,
            },
        },
    },
    {
        "axelvc/template-string.nvim",
        event = "InsertEnter",
        ft = {
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
        },
        config = true, -- run require("template-string").setup()
    },
}
