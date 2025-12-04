return {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
        require("tiny-inline-diagnostic").setup({
            preset = "modern",
            options = {
                multilines = {
                    enabled = true,
                    always_show = false,
                },
                show_source = {
                    enabled = true,
                },
                show_related = {
                    max_count = 5,
                },
            },
        })
        vim.diagnostic.config({
            virtual_text = false,
        })
    end,
}
