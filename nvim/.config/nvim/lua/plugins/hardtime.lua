---@class LazyPluginSpec
return {
    "m4xshen/hardtime.nvim",
    lazy = false,
    dev = true,
    dependencies = { "MunifTanjim/nui.nvim" },
    ---@module "hardtime"
    ---@class hardtime.config
    opts = {
        restriction_mode = "hint",
        disabled_keys = {
            ["<Left>"] = false,
            ["<Down>"] = false,
            ["<Up>"] = false,
            ["<Right>"] = false,
        },
    },
}
