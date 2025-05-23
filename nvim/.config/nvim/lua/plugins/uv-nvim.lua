return {
    "benomahony/uv.nvim",
    ft = { "python" },
    config = function()
        require("uv").setup()
    end,
}
