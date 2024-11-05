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

local for_future = {
    textlsp = {
        settings = {
            analysers = {
                --[[ languagetool = {
                    enabled = true,
                    check_text = {
                        on_open = true,
                        on_save = true,
                        on_change = false,
                    },
                }, ]]
                --[[ ollama = {
                    enabled = true,
                    check_text = {
                        on_open = false,
                        on_save = true,
                        on_change = false,
                    },
                    model = "phi3:3.8b-instruct", -- smaller but faster model
                    -- model = "phi3:14b-instruct",  -- more accurate
                    max_token = 50,
                }, ]]
                gramformer = {
                    -- gramformer dependency needs to be installed manually
                    enabled = false,
                    gpu = false,
                    check_text = {
                        on_open = false,
                        on_save = true,
                        on_change = false,
                    },
                },
                hf_checker = {
                    enabled = false,
                    gpu = false,
                    quantize = 32,
                    model = "pszemraj/flan-t5-large-grammar-synthesis",
                    min_length = 40,
                    check_text = {
                        on_open = false,
                        on_save = true,
                        on_change = false,
                    },
                },
                hf_instruction_checker = {
                    enabled = false,
                    gpu = false,
                    quantize = 32,
                    model = "grammarly/coedit-large",
                    min_length = 40,
                    check_text = {
                        on_open = false,
                        on_save = true,
                        on_change = false,
                    },
                },
                hf_completion = {
                    enabled = false,
                    gpu = false,
                    quantize = 32,
                    model = "bert-base-multilingual-cased",
                    topk = 5,
                },
            },
            documents = {
                -- the language of the documents, could be set to `auto` of `auto:<fallback>`
                -- to detect automatically, default: auto:en
                language = "auto:en",
                -- do not autodetect documents with fewer characters
                min_length_language_detect = 20,
                org = {
                    org_todo_keywords = {
                        "TODO",
                        "IN_PROGRESS",
                        "DONE",
                    },
                },
                txt = {
                    parse = true,
                },
            },
        },
    },
}

local servers = {
    marksman = {
        settings = { filetypes = { "markdown" } },
    },
    markdownlint = {},
    -- omnisharp = {},
    -- pylsp = {},
    ruff_lsp = {},
    yamlls = {},
    actionlint = {},
    dockerls = {},
    -- ruby_lsp = {},
    solargraph = {},
    -- csharp_ls = {},
    docker_compose_language_service = {},
    sqlls = {
        filetypes = { "sql" },
    },
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
    ltex = {
        settings = {
            ltex = {
                -- language = "en",
                dictionary = {
                    ["en"] = words,
                    ["en-US"] = words,
                    ["en-GB"] = words,
                },
            },
        },
    },
    lua_ls = {
        -- cmd = {...},
        -- filetypes = { ...},
        -- capabilities = {},
        settings = {
            Lua = {
                completion = {
                    callSnippet = "Replace",
                },
                -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                -- diagnostics = { disable = { 'missing-fields' } },
            },
        },
    },
    taplo = {},
}
return {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    lazy = false,
    dependencies = {
        { "williamboman/mason.nvim", config = true },
        { "williamboman/mason-lspconfig.nvim" },
        { "WhoIsSethDaniel/mason-tool-installer.nvim" },
        { "j-hui/fidget.nvim", opts = {} },
    },

    config = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

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

        require("mason-lspconfig").setup({
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                    require("lspconfig")[server_name].setup(server)
                    --[[ require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = servers[server_name],
                        filetypes = (servers[server_name] or {}).filetypes,
                    }) ]]
                end,
            },
        })

        -- require("lspconfig").jdtls.setup({})
        require("lspconfig").racket_langserver.setup({})
        require("lspconfig").prolog_ls.setup({
            cmd = {
                "swipl",
                "-g",
                "use_module(library(lsp_server)).",
                "-g",
                "lsp_server:main",
                "-t",
                "halt",
                "--",
                "stdio",
            },
            -- the filetypes to attach the server to
            filetypes = { "prolog" },
            -- root directory detection for detecting the project root
            root_dir = require("lspconfig.util").root_pattern("pack.pl"),
        })
    end,
}
