return {
    "stevearc/oil.nvim",
    opts = {
        default_file_explorer = true,
        --[[ ["<C-h>"] = false,
        ["<C-s>"] = false,
        ["\\"] = false, ]]
        view_options = {
            show_hidden = true,
        },

        keymaps = {
            ["<Esc>"] = { callback = "actions.close", mode = "n" },
        },
        float = {
            padding = 5
        },
    },
    dependencies = { "echasnovski/mini.icons", opts = {} },
    keys = {
        {
            "-",
            function()
                require("oil").toggle_float()
            end,
            desc = "Open Oil in parent directory",
        },
        {
            "<leader>-",
            function()
                require("oil").toggle_float()
            end,
            desc = "Open Oil in a float",
        },
    },
}
