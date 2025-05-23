return {
    "lervag/vimtex",
    -- lazy = false, -- we don't want to lazy load VimTeX
    ft = { "tex", "latex" },
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
        -- VimTeX configuration goes here, e.g.
        vim.g.vimtex_view_method = "zathura"
        -- vim.g.vimtex_compiler_latexmk_engines = { ["_"] = "-lualatex" }
        vim.g.vimtex_format_enabled = true
        vim.g.vimtex_compiler_latexmk = {
            callback = 1,
            continuous = 1,
            executable = "latexmk",
            -- hooks = {},
            aux_dir = ".build",
            out_dir = ".out",
            options = {
                "-shell-escape",
                "-verbose",
                "-file-line-error",
                "-synctex=1",
                "-interaction=nonstopmode",
            },
        }
    end,
}
