return { -- Autoformat
    "stevearc/conform.nvim",
    event = { "VeryLazy" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>fm",
            function()
                require("conform").format({ async = true })
            end,
            mode = "",
            desc = "[F]ormat buffer",
        },
        {
            "<leader>fM",
            function()
                require("conform").format({
                    async = true,
                    formatters = { "codespell" },
                    sp_format = "fallback",
                })
            end,
            mode = "",
            desc = "Format spelling in a range",
        },
    },
    opts = {
        notify_on_error = true,
        format_on_save = function(bufnr)
            local disable_filetypes = {
                "c",
                "cpp",
                -- "python",
                "css",
                "json",
                "toml",
                "yaml.ansible",
                "yaml",
            }
            if vim.tbl_contains(disable_filetypes, vim.bo[bufnr].filetype) then
                return
            end

            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
            end

            local bufname = vim.api.nvim_buf_get_name(bufnr)
            if bufname:match("/node_modules/") then
                return
            end
            return {
                timeout_ms = 500,
                lsp_format = "fallback",
            }
        end,
        formatters_by_ft = {
            lua = { "stylua" },
            markdown = { "prettier", "markdownlint-cli2" },
            tex = { "latexindent" },
            -- json = { "clang-format" },
            -- ["*"] = { "codespell" },
            -- yaml = { 'prettier'}
            -- Conform can also run multiple formatters sequentially
            -- python = { "isort", "black" },
            --
            -- You can use a sub-list to tell conform to run *until* a formatter
            -- is found.
            -- javascript = { { "prettierd", "prettier" } },
            javascript = { "prettier" },
            typescript = { "prettier" },
            javascriptreact = { "prettier" },
            typescriptreact = { "prettier" },
            svelte = { "prettier" },
            vue = { "prettier" },
            css = { "prettier" },
            html = { "prettier" },
            json = { "prettier" },
            graphql = { "prettier" },
            python = { "isort", "black" },
        },
        default_format_opts = {
            lsp_format = "fallback",
        },
    },
    init = function()
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        vim.api.nvim_create_user_command("FormatSpelling", function(args)
            local range = nil
            if args.count ~= -1 then
                local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                range = {
                    start = { args.line1, 0 },
                    ["end"] = { args.line2, end_line:len() },
                }
            end
            vim.print(range)
            require("conform").format({
                async = true,
                formatters = { "codespell" },
                lsp_format = "fallback",
                range = range,
            })
        end, { range = true })
    end,
}
