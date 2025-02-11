return {
    "akinsho/flutter-tools.nvim",
    ft = { "dart" },
    enabled = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "stevearc/dressing.nvim", -- optional for vim.ui.select
    },
    opts = function()
        pcall(require("telescope").load_extension, "flutter")
    end,
    config = true,
    keys = {
        { "<leader>fF", "<cmd>Telescope flutter commands<CR>", desc = "[F]ind [F]lutter commands" },
    },
}
