return {
    "kevinhwang91/nvim-ufo",
    -- enabled = false,
    dependencies = { "kevinhwang91/promise-async" },
    lazy = false,
    event = "BufRead",
    config = function()
        vim.o.foldcolumn = "1"
        vim.o.foldlevel = 2
        vim.o.foldlevelstart = 99
        -- vim.o.foldenable = true
        -- vim.opt.foldnestmax = 4
        -- vim.opt.foldminlines = 3
        -- To show number of folded lines
        local handler = function(virtText, lnum, endLnum, width, truncate)
            local newVirtText = {}
            local suffix = (" %d lines"):format(endLnum - lnum)
            local sufWidth = vim.fn.strdisplaywidth(suffix)
            local targetWidth = width - sufWidth
            local curWidth = 0
            for _, chunk in ipairs(virtText) do
                local chunkText = chunk[1]
                local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                if targetWidth > curWidth + chunkWidth then
                    table.insert(newVirtText, chunk)
                else
                    chunkText = truncate(chunkText, targetWidth - curWidth)
                    local hlGroup = chunk[2]
                    table.insert(newVirtText, { chunkText, hlGroup })
                    chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    -- str width returned from truncate() may less than 2nd argument, need padding
                    if curWidth + chunkWidth < targetWidth then
                        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                    end
                    break
                end
                curWidth = curWidth + chunkWidth
            end
            table.insert(newVirtText, { suffix, "MoreMsg" })
            return newVirtText
        end
        local opts = {}
        opts.fold_virt_text_handler = handler
        local ftMap = {
            markdown = { "treesitter" },
        }

        ---@param bufnr number
        ---@return Promise
        local function customizeSelector(bufnr)
            local function handleFallbackException(err, providerName)
                if type(err) == "string" and err:match("UfoFallbackException") then
                    return require("ufo").getFolds(bufnr, providerName)
                else
                    return require("promise").reject(err)
                end
            end

            return require("ufo")
                .getFolds(bufnr, "lsp")
                :catch(function(err)
                    return handleFallbackException(err, "treesitter")
                end)
                :catch(function(err)
                    return handleFallbackException(err, "indent")
                end)
        end
        opts.preview = {
            win_config = {
                border = "rounded",
                winhighlight = "Normal:Folded",
                winblend = 0,
            },
            mappings = {
                scrollU = "<C-u>",
                scrollD = "<C-d>",
                jumpTop = "[",
                jumpBot = "]",
            },
        }
        opts.provider_selector = function(bufnr, filetype, buftype)
            return ftMap[filetype] or customizeSelector
        end
        require("ufo").setup(opts)
    end,
    keys = {
        {
            "zR",
            function()
                require("ufo").openAllFolds()
            end,
        },
        {
            "zM",
            function()
                require("ufo").closeAllFolds()
            end,
        },
        -- {
        --     "zm",
        --     function()
        --         require("ufo").closeFoldsWith()
        --     end,
        -- },
        -- {
        --     "zr",
        --     function()
        --         require("ufo").openFoldsExceptKinds()
        --     end,
        -- },
        {
            "<leader>k",
            function()
                local winid = require("ufo").peekFoldedLinesUnderCursor()
                if not winid then
                    vim.lsp.buf.hover()
                end
            end,
        },
    },
}
