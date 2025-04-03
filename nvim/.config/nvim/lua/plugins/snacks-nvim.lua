return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        bigfile = { enabled = true },
        indent = {
            enabled = true,
        },
        scroll = {
            enabled = false,
        },
        image = {
            enabled = true,
            doc = {
                inline = false,
            },
        },
        ---@class snacks.dim.Config
        dim = {
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
        notifier = {
            enabled = true,
            style = "fancy",
        },
        picker = {
            enabled = true,
            sources = {
                explorer = {
                    layout = {
                        layout = { position = "right" },
                    },
                },
            },
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
        { "<leader><leader>", function() Snacks.picker.buffers() end, desc = "[ ] Find existing buffers" },
        { "<leader>f.", function() Snacks.picker.recent() end, desc = '[F]ind Recent Files ("." for repeat)' },
        { "<leader>fO", "<cmd>ObsidianQuickSwitch<CR>", desc = "[F]ind [O]sidian switch" },
        { "<leader>fa", function() Snacks.picker.autocmds() end, desc = '[F]ind [A]uto commands' },
        { "<leader>fc", function() Snacks.picker.commands() end, desc = '[F]ind [C]ommands' },
        { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "[F]ind [D]iagnostics" },
        { "<leader>fe", function() Snacks.picker.explorer() end, desc = "[F]ind [E]xplorer" },
        { "<leader>ff", function() Snacks.picker.files({ hidden = true }) end, desc = "[F]ind [F]iles" },
        { "<leader>fg", function() Snacks.picker.grep() end, desc = "[F]ind by [G]rep" },
        { "<leader>fh", function() Snacks.picker.help() end, desc = "[F]ind [H]elp" },
        { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "[F]ind [K]eymaps" },
        { "<leader>fl", function() Snacks.picker.lazy() end, desc = "[F]ind [L]azy" },
        { "<leader>fn", function() Snacks.picker.notifications() end, desc = "[F]ind [P]ickers" },
        { "<leader>fp", function() Snacks.picker.pickers() end, desc = "[F]ind [P]ickers" },
        { "<leader>fq", function() Snacks.picker.gflist() end, desc = "[F]ind [Q]uick Fix List" },
        { "<leader>fr", function() Snacks.picker.resume() end, desc = "[F]ind [R]esume" },
        { "<leader>fs", function() Snacks.picker.spelling() end, desc = "[F]ind [S]pelling" },
        { "<leader>fS", function() Snacks.picker.smart() end, desc = "[F]ind [S]mart" },
        { "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "[F]ind [T]odo" },
        { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "[F]ind current [W]ord" },
        -- TODO: 
        -- { "<leader>fo", function() Snacks.picker.vim_options() end, desc = "[F]ind [O]ptions" },
        -- { "<leader>fF", "<cmd>Telescope flutter commands<CR>", desc = "[F]ind [F]lutter commands" },

        -- Git Pickers
        { "<leader>gS", function() Snacks.picker.git_status() end, desc = "[G]it [S]tatus" },
        { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "[G]it [B]ranches" },
        { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "[G]it [D]iff" },
        { "<leader>gf", function() Snacks.picker.git_files() end, desc = "[G]it [F]iles" },
        { "<leader>gl", function() Snacks.picker.git_log() end, desc = "[G]it [L]og" },
        { "<leader>gs", function() Snacks.picker.git_stash() end, desc = "[G]it [S]tash" },

        --- Telescope lsp pickers
        { "<leader>lc", function() Snacks.picker.lsp_config() end, desc = "[L]sp [C]onfig" },
        { "<leader>lD", function() Snacks.picker.lsp_declarations() end, desc = "[L]sp [D]eclarations" },
        { "<leader>ld", function() Snacks.picker.lsp_definitions() end, desc = "[L]sp [D]efinitions" },
        { "<leader>li", function() Snacks.picker.lsp_implementations() end, desc = "[L]sp [I]mplementations" },
        { "<leader>lr", function() Snacks.picker.lsp_references() end, desc = "[L]sp [R]eferences" },
        { "<leader>ls", function() Snacks.picker.lsp_symbols() end, desc = "[L]sp [S]ymbols [D]ocument" },
        { "<leader>lS", function() Snacks.picker.treesitter() end, desc = "[L]sp tree[S]itter" },
        { "<leader>lt", function() Snacks.picker.lsp_type_definitions() end, desc = "[L]sp [T]ype definitions" },
        { "<leader>lw", function() Snacks.picker.lsp_workspace_symbols() end, desc = "[L]sp [S]ymbols [W]orkspace" },

        -- picker unique
        { "<leader>sc", function() Snacks.picker.colorschemes() end, desc = "[S]earch [C]olorscheme" },
        { "<leader>sh", function() Snacks.picker.cliphist() end, desc = "[S]earch [H]istory}" },
        { "<leader>si", function() Snacks.picker.icons() end, desc = "[S]earch [I]con" },
        { "<leader>su", function() Snacks.picker.undo() end, desc = "[S]earch [U]dotree" },
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
                Snacks.toggle.scroll():map("<leader>tS")
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
