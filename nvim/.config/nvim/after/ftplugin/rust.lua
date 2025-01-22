vim.keymap.set(
    "n",
    "K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
    function()
        vim.cmd.RustLsp({ "hover", "actions" })
    end,
    { silent = true, buffer = bufnr }
)
