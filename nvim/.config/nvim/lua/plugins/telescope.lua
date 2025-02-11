-- local builtin = require("telescope.builtin")
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

        -- { "<leader>fO", "<cmd>ObsidianQuickSwitch<CR>", desc = "[F]ind [O]sidian switch" },
        { "<leader>fo", require("telescope.builtin").vim_options, desc = "[F]ind [O]ptions" },
        -- Slightly advanced example of overriding default behavior and theme
        {
            "<leader>/",
            function()
                require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
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
                require("telescope.builtin").live_grep({
                    grep_open_files = true,
                    prompt_title = "Live Grep in open files",
                })
            end,
            desc = "[F]ind [/] in Open Files",
        },

        -- Shortcut for searching your Neovim configuration files
        -- {
        --     "<leader>fn",
        --     function()
        --         builtin.find_files({ cwd = vim.fn.stdpath("config") })
        --     end,
        --     desc = "[F]ind [N]eovim files",
        -- },
    },
}
