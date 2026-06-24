-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

local dap = require("dap")

function pick_executable(under_git_root, subdir)
    return coroutine.create(function(dap_run_co)
        local root = "."
        if under_git_root then
            root = Snacks.git.get_root()
        end
        if subdir ~= nil then
            root = root .. "/" .. subdir
        end
        Snacks.picker.files({
            hidden = true,
            ignored = true,
            dirs = { root },
            cmd = "fd",
            type = { "x" },
            confirm = function(picker, item)
                picker:norm(function()
                    picker:close()
                    coroutine.resume(dap_run_co, item.text)
                end)
            end,
        })
    end)
end

function cpp_setup()
    local mason_dap = require("mason-nvim-dap")
    local dap = require("dap")
    local ui = require("dapui")
    local dap_virtual_text = require("nvim-dap-virtual-text")

    -- Dap Virtual Text
    dap_virtual_text.setup()

    mason_dap.setup({
        ensure_installed = { "cppdbg" },
        automatic_installation = true,
        handlers = {
            function(config)
                require("mason-nvim-dap").default_setup(config)
            end,
        },
    })

    -- Configurations
    dap.configurations = {
        cpp = {
            {
                name = "Launch file",
                type = "codelldb",
                request = "launch",
                program = function()
                    return pick_executable(true, "")
                end,
                cwd = "${workspaceFolder}",
                stopAtEntry = false,
                stopOnEntry = false,
                -- MIMode = "lldb",
            },
            {
                name = "Attach to lldbserver :1234",
                type = "cppdbg",
                request = "launch",
                MIMode = "lldb",
                miDebuggerServerAddress = "localhost:1234",
                miDebuggerPath = "/usr/bin/lldb",
                cwd = "${workspaceFolder}",
                program = function()
                    return pick_executable(true, "")
                end,
            },
        },
    }

    -- Dap UI

    ui.setup()

    vim.fn.sign_define("DapBreakpoint", { text = "🐞" })

    dap.listeners.before.attach.dapui_config = function()
        ui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
        ui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
    end
end

return {
    -- NOTE: Yes, you can install new plugins here!
    "mfussenegger/nvim-dap",
    -- NOTE: And you can specify dependencies as well
    dependencies = {
        -- Creates a beautiful debugger UI
        "rcarriga/nvim-dap-ui",

        -- Required dependency for nvim-dap-ui
        "nvim-neotest/nvim-nio",

        -- Installs the debug adapters for you
        "williamboman/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim",

        -- Add your own debuggers here
        "leoluz/nvim-dap-go",
        "theHamsta/nvim-dap-virtual-text",
    },
    -- stylua: ignore
    keys = {
        { "<leader>ds", function() dap.continue() end, desc = "[D]ap [S]tart/Continue" },
        { "<leader>di", function() dap.step_into() end, desc = "[D]ap step [I]nto" },
        { "<leader>do", function() dap.step_over() end, desc = "[D]ap step [O]ver" },
        { "<leader>dO", function() dap.step_out() end, desc = "[D]ap step [O]ut" },
        { "<leader>db", function() dap.toggle_breakpoint() end, desc = "[D]ap toggle [B]reakpoint" },
        -- { "<leader>ds", function() dap.continue() end, desc = "[D]ap [S]tart/Continue" },
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        require("mason-nvim-dap").setup({
            -- Makes a best effort to setup the various debuggers with
            -- reasonable debug configurations
            automatic_installation = true,

            -- You can provide additional configuration to the handlers,
            -- see mason-nvim-dap README for more information
            handlers = {},

            -- You'll need to check that you have the required things installed
            -- online, please don't ask me how to install them :)
            ensure_installed = {
                -- Update this to ensure that you have the debuggers for the langs you want
                "delve",
                "netcoredbg",
            },
        })

        -- dap.configurations.cpp = {
        --     {
        --         name = "Launch file",
        --         type = "codelldb",
        --         request = "launch",
        --         program = function()
        --             return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        --         end,
        --         cwd = "${workspaceFolder}",
        --         stopOnEntry = false,
        --     },
        -- }
        -- dap.configurations.rust = dap.configurations.cpp

        cpp_setup()

        -- Dap UI setup
        -- For more information, see |:help nvim-dap-ui|
        ---@diagnostic disable: missing-fields
        dapui.setup({
            -- Set icons to characters that are more likely to work in every terminal.
            --    Feel free to remove or use ones that you like more! :)
            --    Don't feel like these are good choices.
            icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
            controls = {
                icons = {
                    pause = "⏸",
                    play = "▶",
                    step_into = "⏎",
                    step_over = "⏭",
                    step_out = "⏮",
                    step_back = "b",
                    run_last = "▶▶",
                    terminate = "⏹",
                    disconnect = "⏏",
                },
            },
        })

        -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
        vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })

        dap.listeners.after.event_initialized["dapui_config"] = dapui.open
        dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        dap.listeners.before.event_exited["dapui_config"] = dapui.close

        -- Install golang specific config
        require("dap-go").setup({
            delve = {
                -- On Windows delve must be run attached or it crashes.
                -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
                detached = vim.fn.has("win32") == 0,
            },
        })
    end,
}
