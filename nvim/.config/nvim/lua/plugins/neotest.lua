return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "Issafalcon/neotest-dotnet",
    },

    config = function()
        ---@diagnostic disable-next-line: missing-fields
        require("neotest").setup({
            log_level = 1,
            adapters = {
                require("rustaceanvim.neotest"),
                require("neotest-dotnet")({
                    dap = {
                        adapter_name = "netcoredbg",
                    },
                    dotnet_additional_args = {
                        "-e ASPNETCORE_ENVIRONMENT=Development",
                    },
                }),
            },
        })
    end,
    keys = {
        {
            "<leader>dt",
            function()
                require("neotest").run.run({
                    dotnet_additional_args = { "-e ASPNETCORE_ENVIRONMENT=Development", strategy = "dap" },
                })
            end,
        },
    },
}
