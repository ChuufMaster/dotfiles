---@module "lazy"
---@type LazyPluginSpec
return {
    "GustavEikaas/easy-dotnet.nvim",
    -- dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    ft = { "cs" },
    config = function()
        ---@module "easy-dotnet"
        require("easy-dotnet").setup({
            picker = "snacks",
        })
    end,
    keys = {
        {
            ",dap",
            "<CMD>Dotnet add package<CR>",
        },
        {
            ",drr",
            "<CMD>Dotnet restore<CR>",
        },
        {
            ",dpv",
            "<CMD>Dotnet project view<CR>",
        },
    },
}
