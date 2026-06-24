require("config.lazy")

vim.o.background = "dark"
-- vim.o.background = "light"
vim.cmd([[colorscheme gruvbox]])
-- vim.cmd([[colorscheme desert]])

-- vim.cmd.colorscheme("tokyonight")
-- vim.cmd("hi ColorColumn ctermbg=white guibg=darkcyan")

vim.lsp.config("taplo", { root_markers = { ".taplo.toml", "taplo.toml", ".git", "starship.toml" } })

vim.lsp.config("harper_ls", {
    settings = {
        ["harper-ls"] = {
            linters = {
                LongSentences = false,
            },
        },
    },
})

vim.lsp.enable({
    "hyprls",
    "ruby_lsp",
    "solargraph",
    "lua_ls",
    "ansiblels",
    "markdown_oxide",
    "ruff",
    -- "pylsp",
    "ty",
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
