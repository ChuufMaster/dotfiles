-- local functions
local function set_file_type(_pattern, _filetype)
    vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter" }, {
        pattern = { _pattern },
        command = "set filetype=" .. _filetype,
    })
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = "**/kanata/**.kbd",
    callback = function()
        print("filtype kanata detected")
    end,
})

-- Fix bufferline when restoring a session
vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
    callback = function()
        vim.schedule(function()
            pcall(nvim_bufferline)
        end)
    end,
})

set_file_type("*/hypr/*.conf", "hyprlang")
set_file_type("*.kbd", "scheme")
set_file_type("*.rasi", "rasi")
set_file_type("*.pl", "prolog")
set_file_type("Fastfile", "ruby")
set_file_type("Appfile", "ruby")
set_file_type("Pluginfile", "ruby")
-- set_file_type('*.cshtml', 'cs.html.razor')
-- set_file_type('*.razor', 'razor')

local function augroup(name)
    return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
--[[ vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = augroup("checktime"),
    callback = function()
        if vim.o.buftype ~= "nofile" then
            vim.cmd("checktime")
        end
    end,
}) ]]

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = augroup("highlight_yank"),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = augroup("resize_splits"),
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup("last_loc"),
    callback = function(event)
        local exclude = { "gitcommit" }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
            return
        end
        vim.b[buf].lazyvim_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("close_with_q"),
    pattern = {
        "PlenaryTestPopup",
        "help",
        "lspinfo",
        "notify",
        "qf",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "neotest-output",
        "checkhealth",
        "neotest-summary",
        "neotest-output-panel",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("man_unlisted"),
    pattern = { "man" },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
    end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("wrap_spell"),
    pattern = { "gitcommit", "markdown", "tex", "latex" },
    callback = function()
        vim.opt_local.wrap = false
        vim.opt_local.spell = true
        vim.opt_local.formatoptions = "btcqln"
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.keymap.set(
            "v",
            "<leader>b",
            "sa*<esc>F*vf*sa*f*l",
            { remap = true, desc = "Surround selection in two stars" }
        )
        vim.keymap.set("i", "<C-o>", "<Esc>o", { desc = "Make ctrl-o be enter in markdown", remap = true })

        vim.keymap.set("v", "<leader>C", "sa?```bash<CR>```<CR>", { remap = true, desc = "Add a bash codeblock" })

        vim.keymap.set("i", "<C-V>", "<ESC>[s", { remap = true, desc = "Goto previous spelling mistak" })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup("ansible"),
    pattern = { "yaml.ansible" },
    callback = function()
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.expandtab = true
        vim.opt_local.smartindent = true
    end,
})

-- Set local options for vimtex
-- vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
--     group = augroup("vimtex"),
--     pattern = { "tex", "latex" },
--     callback = function()
--         vim.opt_local.foldmethod = "expr"
--         vim.opt_local.foldexpr = "vimtex#fold#level(v:lnum)"
--         vim.opt_local.foldtext = "vimtex#fold#text()"
--     end,
-- })

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = augroup("json_conceal"),
    pattern = { "json", "jsonc", "json5" },
    callback = function()
        vim.opt_local.conceallevel = 0
    end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = augroup("auto_create_dir"),
    callback = function(event)
        if event.match:match("^%w%w+:[\\/][\\/]") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- When leaving vim fix the cursor
-- without this I was always having the cursor be a block when leaving vim

vim.cmd([[
  au VimLeave * set guicursor=a:ver10-blinkwait800
]])

-- -- Dim inactive windows
-- vim.cmd("highlight default DimInactiveWindows guifg=#666666")
--
-- -- When leaving a window, set all highlight groups to a "dimmed" hl_group
-- vim.api.nvim_create_autocmd({ "WinLeave" }, {
--     callback = function()
--         local highlights = {}
--         for hl, _ in pairs(vim.api.nvim_get_hl(0, {})) do
--             table.insert(highlights, hl .. ":DimInactiveWindows")
--         end
--         vim.wo.winhighlight = table.concat(highlights, ",")
--     end,
-- })
--
-- -- when entering a window, restore all highlight groups to original
-- vim.api.nvim_create_autocmd({ "WinEnter" }, {
--     callback = function()
--         vim.wo.winhighlight = ""
--     end,
-- })

-- split help to the right
vim.api.nvim_create_autocmd("FileType", {
    desc = "Automatically Split help Buffers to the right",
    pattern = "help",
    command = "wincmd L",
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "kitty.conf",
    callback = function()
        require("which-key").add({
            {
                "<S-K>",
                function()
                    local current_line = vim.fn.getline(".")
                    local first_word = current_line:match("^%s*(%S+)")
                    if first_word then
                        local url = "https://sw.kovidgoyal.net/kitty/conf/#opt-kitty." .. first_word
                        vim.fn.system({ "xdg-open", url })
                    else
                        print("No valid option found on the current line.")
                    end
                end,
                icon = "i",
                desc = "show information about the current cursor position",
            },
        })
    end,
})
