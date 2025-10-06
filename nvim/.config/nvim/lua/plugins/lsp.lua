local lsp_callback = function(event)
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    --  To jump back, press <C-t>.
    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
    map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
    map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
        local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
            callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
            end,
        })
    end

    -- The following autocommand is used to enable inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        map("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, "[T]oggle Inlay [H]ints")
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
    callback = lsp_callback,
})

local path = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
local words = {}

for word in io.open(path, "r"):lines() do
    table.insert(words, word)
end

local servers = {
    actionlint = {},
    bashls = {},
    clangd = {},
    docker_compose_language_service = {
        cmd = { "docker-compose-langserver", "--stdio" },
        filetypes = { "yaml.docker-compose" },
    },
    dockerls = {},
    gopls = {},
    jsonls = {},
    jinja_lsp = {
        filetypes = { "jinja" },
    },
    markdownlint = {},
    marksman = {
        settings = { filetypes = { "markdown" } },
    },
    yamlls = {},
    texlab = {
        build = {
            args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
            executable = "latexmk",
            forwardSearchAfter = false,
            onSave = false,
            logDirectory = "./build",
            auxDirectory = "./build",
        },
    },
    harper_ls = {},
    gh_actions_ls = {},
    cssls = {},
}
return {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    lazy = true,
    dependencies = {
        {
            "williamboman/mason.nvim",
            config = function()
                ---@diagnostic disable-next-line: missing-fields
                require("mason").setup({
                    registries = {
                        "github:mason-org/mason-registry",
                        "github:crashdummyy/mason-registry",
                    },
                })
            end,
        },
        { "williamboman/mason-lspconfig.nvim" },
        { "WhoIsSethDaniel/mason-tool-installer.nvim" },
        { "saghen/blink.cmp" },
        { "j-hui/fidget.nvim", opts = {} },
    },

    config = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        -- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
        capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

        require("mason").setup()
        -- Ensure the servers above are installed
        local mason_lspconfig = require("mason-lspconfig")

        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            "stylua",
            "markdownlint",
            "codespell",
        })

        require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

        mason_lspconfig.setup({
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                    -- require("lspconfig")[server_name].setup(server)
                    -- require("lspconfig")[server_name].setup(server)
                    vim.lsp.config(server_name, server)
                end,
            },
            ensure_installed = {},
            automatic_installation = false,
        })

        -- require("lspconfig").prolog_ls.setup({
        --     cmd = {
        --         "swipl",
        --         "-g",
        --         "use_module(library(lsp_server)).",
        --         "-g",
        --         "lsp_server:main",
        --         "-t",
        --         "halt",
        --         "--",
        --         "stdio",
        --     },
        --     -- the filetypes to attach the server to
        --     filetypes = { "prolog" },
        --     -- root directory detection for detecting the project root
        --     root_dir = require("lspconfig.util").root_pattern("pack.pl"),
        -- })
    end,
}
