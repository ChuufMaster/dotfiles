return {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    lazy = false,
    config = function()
        require("treesitter-context").setup({
            max_lines = 5,
            multiline_threshold = 1,
        })
    end,
}
