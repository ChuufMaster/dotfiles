return {
    {
        "obsidian-nvim/obsidian.nvim",
        version = "*",
        lazy = true,
        -- ft = { "markdown" },
        event = {
            "BufReadPre " .. vim.fn.expand("~/Modules/Brain") .. "/*.md",
            "BufNewFile " .. vim.fn.expand("~/Modules/Brain") .. "/*.md",
        },

        ---@module "obsidian"
        ---@class obsidian.config
        opts = {
            legacy_commands = false,
            workspaces = {
                {
                    name = "Brain",
                    path = "~/Modules/Brain",
                },
            },
            daily_notes = {
                folder = "notes/dailies",
                default_tags = { "dailies" },
            },
            preferred_link_style = "markdown",
            completion = {
                nvim_cmp = false,
                blink = true,
            },
            picker = {
                name = "snacks.pick",
            },
            new_notes_location = "current_dir",
            note_id_func = function(title)
                -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
                -- In this case a note with the title 'My new note' will be given an ID that looks
                -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'.
                -- You may have as many periods in the note ID as you'd like—the ".md" will be added automatically
                local suffix = ""
                if title ~= nil then
                    -- If title is given, transform it into valid file name.
                    suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", "")
                else
                    -- If title is nil, just add 4 random uppercase letters to the suffix.
                    for _ = 1, 4 do
                        suffix = suffix .. string.char(math.random(65, 90))
                    end
                    suffix = tostring(os.time()) .. "-" .. suffix
                end
                return suffix
            end,
        },
        keys = {
            { "<leader>ot", "<cmd>Obsidian today<cr>", "[O]bsidian [T]oday" },
            { "<leader>oP", "<cmd>Obsidian yesterday<cr>", "[O]bsidian [P]revious day" },
            { "<leader>oN", "<cmd>Obsidian tomorrow<cr>", "[O]bsidian [N]ext day" },
            { "<leader>od", "<cmd>Obsidian dailies<cr>", "[O]bsidian [D]ailies" },
            { "<leader>oT", "<cmd>Obsidian tags<cr>", "[O]bsidian [T]ags" },
            {
                "<leader>on",
                function()
                    local note_name = vim.fn.input("Note Name: ")
                    vim.cmd("Obsidian new " .. note_name)
                    -- return "<cmd>Obsidian new " .. vim.fn.input("Note Name: ") .. "<cr>"
                end,
                "[O]bsidian [N]ew",
            },
        },
    },
    {
        "oflisback/obsidian-bridge.nvim",
        opts = {
            -- your config here
        },
        event = {
            "BufReadPre " .. vim.fn.expand("~/Modules/Brain") .. "/*.md",
            "BufNewFile " .. vim.fn.expand("~/Modules/Brain") .. "/*.md",
        },
        lazy = true,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
}
