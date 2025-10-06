return {
    "maan2003/lsp_lines.nvim",
    -- lazy = false,
    enabled = false,
    opts = {},
    -- init = function()
    --     vim.diagnostic.config({
    --         virtual_text = false,
    --     })
    -- end,
    keys = {
        {
            "<leader>tl",
            function()
                require("lsp_lines").toggle()
            end,
            desc = "[T]oggle [L]sp lines",
        },
    },
}
