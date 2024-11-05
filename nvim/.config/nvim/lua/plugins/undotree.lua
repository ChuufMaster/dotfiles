return {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    lazy = false,
    keys = {
        "<leader>tu",
        "UndotreeToggle",
        desc = "[T]oggle [U]ndotree",
    },
    opts = {},
    config = function()
        vim.keymap.set("n", "<leader>tu", vim.cmd.UndotreeToggle, { desc = "[T]oggle [U]ndotree" })
    end,
}
