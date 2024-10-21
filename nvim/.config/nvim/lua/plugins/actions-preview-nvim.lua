return {
    "aznhe21/actions-preview.nvim",
    event = "VeryLazy",
    config = function()
        local hl = require("actions-preview.highlight")
        require("actions-preview").setup({
            backend = { "telescope" },
            telescope = {
                sorting_strategy = "ascending",
                layout_strategy = "vertical",
                layout_config = {
                    prompt_position = "top",
                    height = 0.9,
                    width = 0.8,
                    preview_cutoff = 20,
                    preview_height = 0.5,
                },
            },
            diff = {
                algorithm = "patience",
                ignore_whitespace = true,
            },
            highlight_command = {
                hl.delta("delta --no-gitconfig --side-by-side --paging=always"),
            },
        })
        vim.keymap.set({ "v", "n" }, "<leader>a", require("actions-preview").code_actions)
    end,

}
