---@class LazyPluginSpec
return {
    "m4xshen/hardtime.nvim",
    lazy = false,
    -- dev = true,
    enabled = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    ---@module "hardtime"
    ---@class hardtime.config
    opts = {
        restriction_mode = "hint",
        disable_mouse = false,
        disabled_keys = {
            ["<Left>"] = false,
            ["<Down>"] = false,
            ["<Up>"] = false,
            ["<Right>"] = false,
        },
        disabled_filetypes = {
            lazy = false,
        },
    },
}
