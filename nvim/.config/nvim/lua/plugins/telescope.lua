local builtin = require("telescope.builtin")
return { -- Fuzzy Finder (files, lsp, etc)
    "nvim-telescope/telescope.nvim",

    -- lazy = false,
    -- event = "VimEnter",
    -- branch = "0.1.x",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            config = function()
                require("telescope").load_extension("fzf")
            end,
        },
        { "nvim-telescope/telescope-ui-select.nvim" },

        -- Useful for getting pretty icons, but requires a Nerd Font.
        -- { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },

    opts = function()
        pcall(require("telescope").load_extension, "fzf")
        pcall(require("telescope").load_extension, "ui-select")
        return {
            -- You can put your default mappings / updates / etc. in here
            --  All the info you're looking for is in `:help telescope.setup()`
            --
            defaults = {
                mappings = {
                    i = {
                        ["<c-enter>"] = "to_fuzzy_refine",
                        ["<esc>"] = require("telescope.actions").close,
                    },
                },
            },
            -- pickers = {}
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
            },
        }
    end,
    keys = {

        { "<leader>fh", builtin.help_tags, desc = "[F]ind [H]elp" },
        { "<leader>fk", builtin.keymaps, desc = "[F]ind [K]eymaps" },
        { "<leader>ff", builtin.find_files, desc = "[F]ind [F]iles" },
        { "<leader>fs", builtin.builtin, desc = "[F]ind [S]elect Telescope" },
        { "<leader>fw", builtin.grep_string, desc = "[F]ind current [W]ord" },
        { "<leader>fg", builtin.live_grep, desc = "[F]ind by [G]rep" },
        { "<leader>fd", builtin.diagnostics, desc = "[F]ind [D]iagnostics" },
        { "<leader>fr", builtin.resume, desc = "[F]ind [R]esume" },
        { "<leader>f.", builtin.oldfiles, desc = '[F]ind Recent Files ("." for repeat)' },
        { "<leader><leader>", builtin.buffers, desc = "[ ] Find existing buffers" },
        { "<leader>fF", "<cmd>Telescope flutter commands<CR>", desc = "[F]ind [F]lutter commands" },
        { "<leader>fo", builtin.vim_options, desc = "[F]ind [O]ptions" },
        { "<leader>fO", "<cmd>ObsidianQuickSwitch<CR>", desc = "[F]ind [O]sidian switch" },

        { "<leader>fp", builtin.builtin, desc = "[F]ind [P]ickers" },

        --- Telescope lsp pickers
        { "<leader>lr", builtin.lsp_references, desc = "[L]sp [R]eferences" },
        { "<leader>lsd", builtin.lsp_document_symbols, desc = "[L]sp [S]ymbols [D]ocument" },
        { "<leader>lsw", builtin.lsp_workspace_symbols, desc = "[L]sp [S]ymbols [W]orkspace" },
        { "<leader>ld", builtin.diagnostics, desc = "[L]sp [D]iagnostics" },
        { "<leader>li", builtin.lsp_implementations, desc = "[L]sp [I]mplementations" },
        { "<leader>lD", builtin.lsp_definitions, desc = "[L]sp [D]efinitions" },
        { "<leader>lt", builtin.lsp_type_definitions, desc = "[L]sp [T]ype definitions" },

        -- Slightly advanced example of overriding default behavior and theme
        {
            "<leader>/",
            function()
                builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                    winblend = 10,
                    previewer = false,
                }))
            end,
            desc = "[/] Fuzzily search in current buffer",
        },

        -- It's also possible to pass additional configuration options.
        --  See `:help telescope.builtin.live_grep()` for information about particular keys
        {
            "<leader>s/",
            function()
                builtin.live_grep({
                    grep_open_files = true,
                    prompt_title = "Live Grep in open files",
                })
            end,
            desc = "[F]ind [/] in Open Files",
        },

        -- Shortcut for searching your Neovim configuration files
        {
            "<leader>fn",
            function()
                builtin.find_files({ cwd = vim.fn.stdpath("config") })
            end,
            desc = "[F]ind [N]eovim files",
        },
    },
}
