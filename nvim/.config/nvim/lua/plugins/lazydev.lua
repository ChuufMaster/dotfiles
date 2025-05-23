return {
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        dependencies = {
            { "gonstoll/wezterm-types", lazy = true },
        },
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
                { path = "snacks.nvim", words = { "Snacks" } },
                { path = "wezterm-types", mods = { "wezterm" } },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
}
