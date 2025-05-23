require("config.lazy")

vim.lsp.config("ts_ls", {
    init_options = {
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = "/usr/lib/node_modules/@vue/typescript-plugin",
                languages = { "javascript", "typescript", "vue" },
            },
        },
    },
    filetypes = {
        "javascript",
        "typescript",
        "vue",
    },
})

-- You must make sure volar is setup
-- e.g. vim.lsp.config('volar')
-- See volar's section for more information

vim.lsp.enable({
    "hyprls",
    "ruby_lsp",
    "solargraph",
    "lua_ls",
    "ansiblels",
    "markdown_oxide",
    -- "ruff",
    "pylsp",
    "volar",
    "tailwindcss",
    "ts_ls",
})

vim.filetype.add({
    extension = {
        yml = "yaml.ansible",
        zsh = "bash",
    },
    pattern = {
        ["${HOME}/.ssh/*"] = "sshconfig",
    },
})
