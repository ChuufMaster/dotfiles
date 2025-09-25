return {
    "alex-popov-tech/store.nvim",
    dependencies = {
        "OXY2DEV/markview.nvim", -- optional, for pretty readme preview / help window
    },
    cmd = "Store",
    keys = {
        { "<leader>s", "<cmd>Store<cr>", desc = "Open Plugin Store" },
    },
    ---@module "store"
    ---@class UserConfig
    opts = {
        -- optional configuration here
        proportions = {
            list = 0.6,
            preview = 0.4,
        },
        list_fields = { "full_name", "stars", "tags" },
    },
}
