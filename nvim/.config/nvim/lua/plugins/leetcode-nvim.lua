local leet_arg = "leetcode"
return {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
    lazy = leet_arg ~= vim.fn.argv(0, -1),
    dependencies = {
        -- include a picker of your choice, see picker section for more details
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    opts = {
        arg = leet_arg,
        lang = "rust",
        storage = {
            home = os.getenv("HOME") .. "/projects/leetcode",
        },
        image_support = false,
        injector = {
            ["rust"] = {
                before = { "#[allow(dead_code)]", "fn main(){}", "#[allow(dead_code)]", "struct Solution;" },
            },
        },
        hooks = {
            ---@type fun(question: lc.ui.Question)[]
            ["question_enter"] = {
                function(question)
                    if question.lang ~= "rust" then
                        return
                    end
                    local problem_dir = os.getenv("HOME") .. "/projects/leetcode/Cargo.toml"
                    local content = [[
                      [package]
                      name = "leetcode"
                      edition = "2024"

                      [lib]
                      name = "%s"
                      path = "%s"

                      [dependencies]
                      rand = "0.8"
                      regex = "1"
                      itertools = "0.14.0"
                    ]]
                    local file = io.open(problem_dir, "w")
                    if file then
                        local formatted = (content:gsub(" +", "")):format(question.q.frontend_id, question:path())
                        file:write(formatted)
                        file:close()
                    else
                        print("Failed to open file: " .. problem_dir)
                    end
                end,
            },
        },
    },
    keys = {
        { "<localleader>lt", "<cmd>Leet test<cr>", desc = "[L]eet [T]est" },
        { "<localleader>ls", "<cmd>Leet submit<cr>", desc = "[L]eet [S]ubmit" },
        { "<localleader>lm", "<cmd>Leet<cr>", desc = "[L]eet [M]enu" },
    },
}
