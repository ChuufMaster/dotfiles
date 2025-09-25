return { -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    event = "VimEnter", -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
        require("which-key").setup()

        require("which-key").add({
            { "<leader>\t", group = "[T]ab" },
            { "<leader>b", group = "[B]uffer", icon = "󰈔" },
            { "<leader>c", group = "[C]ode", icon = "" },
            { "<leader>d", group = "[D]ocument", icon = "󰈙" },
            { "<leader>f", group = "[F]ind", icon = "🕵" },
            { "<leader>g", group = "[G]it", icon = "" },
            { "<leader>h", group = "Git [H]unk", icon = "" },
            { "<leader>i", group = "[I]mage", icon = "" },
            { "<leader>l", group = "[L]SP", icon = "" },
            { "<leader>m", group = "[M]ultiplexer", icon = "" },
            { "<leader>o", group = "[O]orgmode", icon = "" },
            { "<leader>r", group = "[R]ename" },
            { "<leader>s", group = "[S]earch", icon = "" },
            { "<leader>t", group = "[T]oggle", icon = "" },
            { "<leader>u", group = "[U]ntoggle/Toggle", icon = "" },
            { "<leader>w", group = "[W]orkspace", icon = "" },
            { "[", group = "Previous" },
            { "]", group = "Next" },
            { "s", group = "[S]urround" },
        })
    end,
}
