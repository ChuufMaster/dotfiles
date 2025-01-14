local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WaningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
    end
    vim.fn.getchar()
    os.exit(1)
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- vim.g.maplocalleader = "\\"

require("config.options")
require("config.keymaps")
require("config.autocmds")

-- LazyVim utils
local lazyvimpath = vim.fn.stdpath("data") .. "/lazy/LazyVim"
if not vim.uv.fs_stat(lazyvimpath) then
    local lazyrepo = "https://github.com/LazyVim/LazyVim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", lazyrepo, lazyvimpath })
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazyvimpath)
_G.LazyVim = require("lazyvim.util")
LazyVim.plugin.lazy_file()

require("lazy").setup({
    spec = {
        { "LazyVim/LazyVim" },
        { import = "plugins" },
    },
    defaults = { lazy = true },

    dev = {
        path = "~/projects/plugins",
    },
    checker = {
        enabled = true,
    },
    --[[ changed_detection = {
        notify = false,
    }, ]]
    rocks = { hererocks = true },
    performance = {
        cache = {
            enabled = true,
        },
        rtp = {
            disabled_plugins = {
                "gzip",
                -- "matchit",
                -- "matchparen",
                "netrwPlugin",
                "rplugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

_G.icons = {
    misc = {
        dots = "󰇘",
    },
    ft = {
        octo = "",
    },
    dap = {
        Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
        Breakpoint = " ",
        BreakpointCondition = " ",
        BreakpointRejected = { " ", "DiagnosticError" },
        LogPoint = ".>",
    },
    diagnostics = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
    },
    git = {
        added = " ",
        modified = " ",
        removed = " ",
    },
    kinds = {
        Array = " ",
        Boolean = "󰨙 ",
        Class = " ",
        Codeium = "󰘦 ",
        Color = " ",
        Control = " ",
        Collapsed = " ",
        Constant = "󰏿 ",
        Constructor = " ",
        Copilot = " ",
        Enum = " ",
        EnumMember = " ",
        Event = " ",
        Field = " ",
        File = " ",
        Folder = " ",
        Function = "󰊕 ",
        Interface = " ",
        Key = " ",
        Keyword = " ",
        Method = "󰊕 ",
        Module = " ",
        Namespace = "󰦮 ",
        Null = " ",
        Number = "󰎠 ",
        Object = " ",
        Operator = " ",
        Package = " ",
        Property = " ",
        Reference = " ",
        Snippet = " ",
        String = " ",
        Struct = "󰆼 ",
        TabNine = "󰏚 ",
        Text = " ",
        TypeParameter = " ",
        Unit = " ",
        Value = " ",
        Variable = "󰀫 ",
    },
}

---@type table<string, string[]|boolean>?
kind_filter = {
    default = {
        "Class",
        "Constructor",
        "Enum",
        "Field",
        "Function",
        "Interface",
        "Method",
        "Module",
        "Namespace",
        "Package",
        "Property",
        "Struct",
        "Trait",
    },
    markdown = false,
    help = false,
    -- you can specify a different filter for each filetype
    lua = {
        "Class",
        "Constructor",
        "Enum",
        "Field",
        "Function",
        "Interface",
        "Method",
        "Module",
        "Namespace",
        -- "Package", -- remove package since luals uses it for control flow structures
        "Property",
        "Struct",
        "Trait",
    },
}
