vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
-- vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
-- vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
-- vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
-- vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Vim remap overides
-- vim.keymap.set("i", "<C-b>", "<Esc><S-I>", { desc = "Beginning of line" })
vim.keymap.set("i", "<C-b>", "<End>", { desc = "Beginning of line" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "End of line" })

-- navigate within insert mode
vim.keymap.set("i", "<C-h>", "<Left>", { desc = "Move left" })
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "Move right" })
vim.keymap.set("i", "<C-j>", "<Down>", { desc = "Move down" })
vim.keymap.set("i", "<C-k>", "<Up>", { desc = "Move up" })

vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move cursor to middle" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move cursor to middle" })
vim.keymap.set("n", "G", "Gzz", { desc = "Move cursor to bottom of buffer and center" })
vim.keymap.set("n", "<Esc>", "<cmd> noh <CR><cmd>Noice dismiss<CR>", { desc = "Clear highlights" })

vim.keymap.set("n", "<C-s>", "<CMD>w<CR>zz", { desc = "Save file" })

-- Copy all
vim.keymap.set("n", "<C-c>", "<cmd> %y+ <CR>", { desc = "Copy whole file" })
vim.keymap.set("n", "<C-q>", "ggVG", { desc = "Select the whole file" })

vim.keymap.set("n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
vim.keymap.set("n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
vim.keymap.set({ "v", "n" }, "H", "^", { desc = "Go to Beginning of line" })
vim.keymap.set({ "v", "n" }, "L", "$", { desc = "Go to End of line" })

vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })

vim.keymap.set("i", "<C-O>", "<Esc>o", { desc = "Insert new line below", remap = true })

vim.keymap.set("n", "<leader>ic", function()
    -- This is the command that clears the images
    -- I'm using [[ ]] to escape the special characters in a command
    vim.cmd([[lua require("image").clear()]])
    print("Images cleared")
end, { desc = "Clear images" })

vim.keymap.set("n", "<leader>ir", function()
    -- First I clear the images
    -- I'm using [[ ]] to escape the special characters in a command
    vim.cmd([[lua require("image").clear()]])
    -- Reloads the file to reflect the changes
    vim.cmd("edit!")
    print("Images refreshed")
end, { desc = "Refresh images" })

vim.keymap.set("n", "<leader>ts", "<cmd>set spell!<CR>", { desc = "[T]oggle [S]pelling" })
-- stylua: ignore
vim.keymap.set("n", "[s", "[s<cmd>WhichKey z=<cr>", { remap = true, desc = "go to spelling mistake and prompt for correction" })
-- stylua: ignore
vim.keymap.set("n", "]s", "]s<cmd>WhichKey z=<cr>", { remap = true, desc = "go to spelling mistake and prompt for correction" })
vim.keymap.set("n", "yc", "yygccp", { remap = true, desc = "[Y]ank [C]omment" })
vim.keymap.set("n", "yp", "yyp", { remap = true, desc = "[Y]ank [P]ut" })

-- Alt + jk to move line up/down
vim.keymap.set("n", "<A-j>", ":m .+1<cr>==", { noremap = true, silent = true, desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<cr>==", { noremap = true, silent = true, desc = "Move line up" })
vim.keymap.set(
    "i",
    "<A-j>",
    "<Esc>:m .+1<cr>==gi",
    { noremap = true, silent = true, desc = "Move line down (insert mode)" }
)
vim.keymap.set(
    "i",
    "<A-k>",
    "<Esc>:m .-2<cr>==gi",
    { noremap = true, silent = true, desc = "Move line up (insert mode)" }
)
vim.keymap.set("x", "<A-j>", ":m '>+1<cr>gv=gv", { noremap = true, silent = true, desc = "Move block down" })
vim.keymap.set("x", "<A-k>", ":m '<-2<cr>gv=gv", { noremap = true, silent = true, desc = "Move block up" })

vim.keymap.set("n", "<leader>L", "<CMD>Lazy<CR>", { desc = "Open the lazy UI" })

vim.keymap.set("n", "gG", "gg<S-v>G", { desc = "Select all" })

vim.keymap.set("n", "<leader>v", "<cmd>vsplit<cr>", { silent = false, desc = "vertically split buffer" })
vim.keymap.set("n", "<leader>S", "<cmd>split<cr>", { silent = false, desc = "horizontally split buffer" })

vim.keymap.set("n", "<leader>G", "G<cmd>%norm! gww<cr>zz", { desc = "format and go to the bottom of buffer" })

local surround_map = function(character)
    vim.keymap.set("v", "<leader>" .. character, "sa" .. character, { remap = true, desc = "Surround selection" })
end

local surround_char = { "'", '"', "[", "]", "{", "}", "(", ")", "`", "<", ">", "*", "?" }
for _, char in pairs(surround_char) do
    surround_map(char)
end

vim.keymap.set("n", "<leader>x", "<CMD>bdelete<CR>", { noremap = true, desc = "Close buffer" })

vim.keymap.set({ "n", "v" }, "<A-x>", "<C-a>", { desc = "Increase Number" })

vim.keymap.set("n", "gK", function()
    local new_config = not vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = "Toggle diagnostic virtual_lines" })

vim.keymap.set("i", "<C-Z>", "<ESC>zzi", { desc = "Centre screen" })
