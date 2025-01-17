return {
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    lazy = false,
    main = "ibl",
    opts = {
        exclude = {
            filetypes = { "help", "packer", "nvimtree", "dashboard", "neo-tree" },
            buftypes = { "terminal", "nofile", "quickfix" },
        },
    },
}
