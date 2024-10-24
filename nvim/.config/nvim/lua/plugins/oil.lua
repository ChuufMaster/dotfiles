return {
    "stevearc/oil.nvim",
    opts = {
        default_file_explorer = true,
        --[[ ["<C-h>"] = false,
        ["<C-s>"] = false,
        ["\\"] = false, ]]
        view_options = {
            show_hidden = true,
        },

        keymaps = {
            ["<Esc>"] = { callback = "actions.close", mode = "n" },
        },
        float = {
            padding = 5,
        },
    },
    dependencies = { "echasnovski/mini.icons", opts = {} },
    keys = {
        {
            "-",
            function()
                local oil = require("oil")
                oil.set_is_hidden_file(function(name, bufnr)
                    return false
                end)
                require("oil").toggle_float()
            end,
            desc = "Open Oil in parent directory",
        },
        {
            "<leader>oi",
            function()
                -- helper function to parse output
                local function parse_output(proc)
                    local result = proc:wait()
                    local ret = {}
                    if result.code == 0 then
                        for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
                            -- Remove trailing slash
                            line = line:gsub("/$", "")
                            ret[line] = true
                        end
                    end
                    return ret
                end

                -- build git status cache
                local function new_git_status()
                    return setmetatable({}, {
                        __index = function(self, key)
                            local ignore_proc = vim.system(
                                { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
                                {
                                    cwd = key,
                                    text = true,
                                }
                            )
                            local tracked_proc = vim.system({ "git", "ls-tree", "HEAD", "--name-only" }, {
                                cwd = key,
                                text = true,
                            })
                            local ret = {
                                ignored = parse_output(ignore_proc),
                                tracked = parse_output(tracked_proc),
                            }

                            rawset(self, key, ret)
                            return ret
                        end,
                    })
                end
                local git_status = new_git_status()

                -- Clear git status cache on refresh
                local refresh = require("oil.actions").refresh
                local orig_refresh = refresh.callback
                refresh.callback = function(...)
                    git_status = new_git_status()
                    orig_refresh(...)
                end

                local oil = require("oil")
                require("oil.config").view_options.show_hidden = false
                oil.set_is_hidden_file(function(name, bufnr)
                    local dir = require("oil").get_current_dir(bufnr)
                    local is_dotfile = vim.startswith(name, ".") and name ~= ".."
                    -- if no local directory (e.g. for ssh connections), just hide dotfiles
                    if not dir then
                        return is_dotfile
                    end
                    -- dotfiles are considered hidden unless tracked
                    if is_dotfile then
                        return not git_status[dir].tracked[name]
                    else
                        -- Check if file is gitignored
                        return git_status[dir].ignored[name]
                    end
                end)
                require("oil").toggle_float()
            end,

            desc = "Open ignored Oil in a float",
        },
        {
            "<leader>oh",
            function()
                local oil = require("oil")
                local function read_gitignore_to_table(filepath)
                    local entries = {} -- Create a table to store entries

                    -- Open the file in read mode
                    local file = io.open(filepath, "r")
                    if not file then
                        print("Error: Could not open .gitignore file at " .. filepath)
                        return nil
                    end

                    -- Iterate through each line of the file
                    for line in file:lines() do
                        -- Ignore empty lines and comments (lines starting with #)
                        if line:match("^%s*$") == nil and line:sub(1, 1) ~= "#" then
                            table.insert(entries, line) -- Add valid lines to the table
                        end
                    end

                    file:close() -- Close the file after reading
                    return entries -- Return the populated table
                end

                -- Usage example
                local gitignore_path = ".gitignore" -- Adjust path if necessary
                local gitignore_entries = read_gitignore_to_table(gitignore_path)

                if gitignore_entries then
                    print(vim.inspect(gitignore_entries)) -- Display the entries
                else
                    print("Failed to read .gitignore")
                end

                oil.set_is_hidden_file(function(filename, _)
                    local ignored = {}
                    ignored = ignored or read_gitignore_to_table(".gitignore")
                    for _, extension in ipairs(ignored) do
                        if string.find(filename, extension) then
                            print(filename)
                            return true
                        end
                    end
                    return false
                end)
                -- oil.toggle_float()
                oil.toggle_hidden()
            end,
            desc = "Open Oil in a float",
        },
    },
}
