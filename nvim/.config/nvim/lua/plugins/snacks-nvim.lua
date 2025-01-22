return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        bigfile = { enabled = true },
        ---@class snacks.dim.Config
        {
            ---@type snacks.scope.Config
            scope = {
                min_size = 5,
                max_size = 20,
                siblings = true,
            },
            -- animate scopes. Enabled by default for Neovim >= 0.10
            -- Works on older versions but has to trigger redraws during animation.
            ---@type snacks.animate.Config|{enabled?: boolean}
            animate = {
                enabled = vim.fn.has("nvim-0.10") == 1,
                easing = "outQuad",
                duration = {
                    step = 20, -- ms per step
                    total = 300, -- maximum duration
                },
            },
            -- what buffers to dim
            filter = function(buf)
                return vim.g.snacks_dim ~= false and vim.b[buf].snacks_dim ~= false and vim.bo[buf].buftype == ""
            end,
        },
        dashboard = {
            enabled = true,
            sections = {
                { section = "header" },
                {
                    pane = 2,
                    section = "terminal",
                    cmd = "fortune -s | cowsay",
                    hl = "header",
                },
                {
                    section = "keys",
                    gap = 1,
                    padding = 1,
                },
                {

                    pane = 2,
                    icon = " ",
                    title = "Recent Files",
                    section = "recent_files",
                    indent = 2,
                    padding = 1,
                },
                {
                    pane = 2,
                    icon = " ",
                    title = "Projects",
                    section = "projects",
                    indent = 2,
                    padding = 1,
                },
                {
                    pane = 2,
                    icon = " ",
                    title = "Git Status",
                    section = "terminal",
                    enabled = "lua: Snacks.git.get_root() ~= nil",
                    cmd = "git status --short --branch --renames",
                    height = 5,
                    padding = 1,
                    ttl = 5 * 60,
                    indent = 3,
                },
                { section = "startup" },
            },
        },
        gitbrowse = {
            enabled = true,
        },
        picker = {
            enabled = true,
            win = {
                input = {
                    keys = {
                        ["<Esc>"] = { "close", mode = { "n", "i" } },
                    },
                },
            },
        },
    },
    -- stylua: ignore
    keys = {
        {
            "<leader>go",
            function()
                Snacks.gitbrowse.open()
            end,
            desc = "Open current repository in browser",
        },
        {
            "<leader>td",
            function()
                if Snacks.dim.enabled then
                    Snacks.dim.disable()
                else
                    Snacks.dim.enable()
                end
            end,
            desc = "[T]oggle [D]im",
        },
        -- [ Picker keys ]
        { "<leader>fh", function() Snacks.picker.help() end, desc = "[F]ind [H]elp" },
        { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "[F]ind [K]eymaps" },
        { "<leader>ff", function() Snacks.picker.files() end, desc = "[F]ind [F]iles" },
        { "<leader>fs", function() Snacks.picker.pickers() end, desc = "[F]ind [S]elect Telescope" },
        { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "[F]ind current [W]ord" },
        { "<leader>fg", function() Snacks.picker.grep() end, desc = "[F]ind by [G]rep" },
        { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "[F]ind [D]iagnostics" },
        { "<leader>fr", function() Snacks.picker.resume() end, desc = "[F]ind [R]esume" },
        { "<leader>f.", function() Snacks.picker.recent() end, desc = '[F]ind Recent Files ("." for repeat)' },
        { "<leader>fc", function() Snacks.picker.commands() end, desc = '[F]ind [C]ommands' },
        { "<leader>fa", function() Snacks.picker.autocmds() end, desc = '[F]ind [A]uto commands' },
        { "<leader><leader>", function() Snacks.picker.buffers() end, desc = "[ ] Find existing buffers" },
        -- { "<leader>fF", "<cmd>Telescope flutter commands<CR>", desc = "[F]ind [F]lutter commands" },
        -- TODO: 
        -- { "<leader>fo", function() Snacks.picker.vim_options() end, desc = "[F]ind [O]ptions" },
        { "<leader>fO", "<cmd>ObsidianQuickSwitch<CR>", desc = "[F]ind [O]sidian switch" },

        { "<leader>fp", function() Snacks.picker.pickers() end, desc = "[F]ind [P]ickers" },
        { "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "[F]ind [T]odo" },

        --- Telescope lsp pickers
        { "<leader>lr", function() Snacks.picker.lsp_references() end, desc = "[L]sp [R]eferences" },
        { "<leader>lsd", function() Snacks.picker.lsp_symbols() end, desc = "[L]sp [S]ymbols [D]ocument" },
        -- { "<leader>lsw", function() Snacks.picker.lsp_workspace_symbols() end, desc = "[L]sp [S]ymbols [W]orkspace" },
        { "<leader>ld", function() Snacks.picker.diagnostics() end, desc = "[L]sp [D]iagnostics" },
        { "<leader>li", function() Snacks.picker.lsp_implementations() end, desc = "[L]sp [I]mplementations" },
        { "<leader>lD", function() Snacks.picker.lsp_definitions() end, desc = "[L]sp [D]efinitions" },
        { "<leader>lt", function() Snacks.picker.lsp_type_definitions() end, desc = "[L]sp [T]ype definitions" },

        -- picker unique
        { "<leader>ph", function() Snacks.picker.cliphist() end, desc = "[P]ick [H]istory}" },
        { "<leader>pu", function() Snacks.picker.undo() end, desc = "[P]ick [U]dotree" },
        { "<leader>pc", function() Snacks.picker.colorschemes() end, desc = "[P]ick [C]olorscheme" }
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Setup some globals for debugging (lazy-loaded)
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd -- Override print to use snacks for `:=` command

                -- Create some toggle mappings
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
                Snacks.toggle.diagnostics():map("<leader>ud")
                Snacks.toggle.line_number():map("<leader>ul")
                Snacks.toggle
                    .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
                    :map("<leader>uc")
                Snacks.toggle.treesitter():map("<leader>uT")
                Snacks.toggle
                    .option("background", { off = "light", on = "dark", name = "Dark Background" })
                    :map("<leader>ub")
                Snacks.toggle.inlay_hints():map("<leader>uh")
            end,
        })
    end,
}
