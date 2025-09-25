require("config.lazy")

vim.o.background = "dark"
-- vim.o.background = "light"
vim.cmd([[colorscheme gruvbox]])
-- vim.cmd([[colorscheme desert]])

-- vim.cmd.colorscheme("tokyonight")
-- vim.cmd("hi ColorColumn ctermbg=white guibg=darkcyan")

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

vim.lsp.config("taplo", { root_markers = { ".taplo.toml", "taplo.toml", ".git", "starship.toml" } })

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
    "vue_ls",
    -- "tailwindcss",
    "ts_ls",
    "taplo",
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

vim.env.OBSIDIAN_REST_API_KEY = "7aa92ea9789c4abe6957e687185631f7f51278b1ea781704ae8c15cc45e2d633"
