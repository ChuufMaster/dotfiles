---@module "lazy"
---@type LazyPluginSpec
return {
    "numToStr/Comment.nvim",
    ---@module "Comment"
    ---@type CommentConfig
    opts = {},
    event = "VeryLazy",
}
