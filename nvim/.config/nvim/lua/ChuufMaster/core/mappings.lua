-- n, v, i, t = mode names

local M = {}

M.general = {
  i = {
    -- go to  beginning and end
    vim.keymap.set('i', '<C-b>', '<ESC>^i', { desc = 'Beginning of line' })
    vim.keymap.set('i', '<C-e>', '<End>', { desc = 'End of line' })

    -- navigate within insert mode
    vim.keymap.set('i', '<C-h>', '<Left>', { desc = 'Move left' })
    vim.keymap.set('i', '<C-l>', '<Right>', { desc = 'Move right' })
    vim.keymap.set('i', '<C-j>', '<Down>', { desc = 'Move down' })
    vim.keymap.set('i', '<C-k>', '<Up>', { desc = 'Move up' })
  },

 n = functions() {
    vim.keymap.set('n', '<C-u', '<C-u>zz', { desc = 'Move cursor to middle' })
    vim.keymap.set('n', '<C-d', '<C-d>zz', { desc = 'Move cursor to middle' })
    vim.keymap.set('n', '<Esc>', '<cmd> noh <CR>', { desc = 'Clear highlights' })
    -- switch between windows
    vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
    vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Window right' })
    vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
    vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Window up' })

    -- save
    vim.keymap.set('.', '<C-s>', '<cmd> w <CR>', { desc = 'Save file' })

    -- Copy all
    vim.keymap.set('.', '<C-c>', '<cmd> %y+ <CR>', { desc = 'Copy whole file' })

    -- line numbers
    vim.keymap.set('.', '<leader>n', '<cmd> set nu! <CR>', { desc = 'Toggle line number' })
    vim.keymap.set('.', '<leader>rn', '<cmd> set rnu! <CR>', { desc = 'Toggle relative number' })

    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using <cmd> :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    ['j'] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', 'Move down', opts = { expr = true } },
    ['k'] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', 'Move up', opts = { expr = true } },
    ['<Up>'] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', 'Move up', opts = { expr = true } },
    ['<Down>'] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', 'Move down', opts = { expr = true } },

    -- new buffer
    vim.keymap.set('.', '<leader>b', '<cmd> enew <CR>', { desc = 'New buffer' })
    vim.keymap.set('.', '<leader>ch', '<cmd> NvCheatsheet <CR>', { desc = 'Mapping cheatsheet' })

    ['<leader>fm'] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      'LSP formatting',
    },
  },

  t = {
    vim.keymap.set('.', '<C-x>', '<C-\\><C-N>', { desc = 'Escape terminal mode' })
  },

 v = functions() {
    ['<Up>'] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', 'Move up', opts = { expr = true } },
    ['<Down>'] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', 'Move down', opts = { expr = true } },
    vim.keymap.set('.', '<', '<gv', { desc = 'Indent line' })
    vim.keymap.set('.', '>', '>gv', { desc = 'Indent line' })
  },

  x = {
    ['j'] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', 'Move down', opts = { expr = true } },
    ['k'] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', 'Move up', opts = { expr = true } },
    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    ['p'] = { 'p:let @+=@0<CR>:let @"=@0<CR>', 'Dont copy replaced text', opts = { silent = true } },
  },
}

M.tabufline = {
  plugin = true,

  n = {
    -- cycle through buffers
    ['<tab>'] = {
      function()
        require('nvchad.tabufline').tabuflineNext()
      end,
      'Goto next buffer',
    },

    ['<S-tab>'] = {
      function()
        require('nvchad.tabufline').tabuflinePrev()
      end,
      'Goto prev buffer',
    },

    -- close buffer + hide terminal buffer
    ['<leader>x'] = {
      function()
        require('nvchad.tabufline').close_buffer()
      end,
      'Close buffer',
    },
  },
}

M.comment = {
  plugin = true,

  -- toggle comment in both modes
  n = {
    ['<leader>/'] = {
      function()
        require('Comment.api').toggle.linewise.current()
      end,
      'Toggle comment',
    },
  },

  v = {
    ['<leader>/'] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      'Toggle comment',
    },
  },
}

M.lspconfig = {
  plugin = true,

  -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions

  n = {
    ['gD'] = {
      function()
        vim.lsp.buf.declaration()
      end,
      'LSP declaration',
    },

    ['gd'] = {
      function()
        vim.lsp.buf.definition()
      end,
      'LSP definition',
    },

    ['K'] = {
      function()
        vim.lsp.buf.hover()
      end,
      'LSP hover',
    },

    ['gi'] = {
      function()
        vim.lsp.buf.implementation()
      end,
      'LSP implementation',
    },

    ['<leader>ls'] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      'LSP signature help',
    },

    ['<leader>D'] = {
      function()
        vim.lsp.buf.type_definition()
      end,
      'LSP definition type',
    },

    ['<leader>ra'] = {
      function()
        require('nvchad.renamer').open()
      end,
      'LSP rename',
    },

    ['<leader>ca'] = {
      function()
        vim.lsp.buf.code_action()
      end,
      'LSP code action',
    },

    ['gr'] = {
      function()
        vim.lsp.buf.references()
      end,
      'LSP references',
    },

    ['<leader>lf'] = {
      function()
        vim.diagnostic.open_float { border = 'rounded' }
      end,
      'Floating diagnostic',
    },

    ['[d'] = {
      function()
        vim.diagnostic.goto_prev { float = { border = 'rounded' } }
      end,
      'Goto prev',
    },

    [']d'] = {
      function()
        vim.diagnostic.goto_next { float = { border = 'rounded' } }
      end,
      'Goto next',
    },

    ['<leader>q'] = {
      function()
        vim.diagnostic.setloclist()
      end,
      'Diagnostic setloclist',
    },

    ['<leader>wa'] = {
      function()
        vim.lsp.buf.add_workspace_folder()
      end,
      'Add workspace folder',
    },

    ['<leader>wr'] = {
      function()
        vim.lsp.buf.remove_workspace_folder()
      end,
      'Remove workspace folder',
    },

    ['<leader>wl'] = {
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      'List workspace folders',
    },
  },

  v = {
    ['<leader>ca'] = {
      function()
        vim.lsp.buf.code_action()
      end,
      'LSP code action',
    },
  },
}

M.nvimtree = {
  plugin = true,

  n = {
    -- toggle
    vim.keymap.set('.', '<C-n>', '<cmd> NvimTreeToggle <CR>', { desc = 'Toggle nvimtree' })

    -- focus
    vim.keymap.set('.', '<leader>e', '<cmd> NvimTreeFocus <CR>', { desc = 'Focus nvimtree' })
  },
}

M.telescope = {
  plugin = true,

  n = {
    -- find
    vim.keymap.set('.', '<leader>ff', '<cmd> Telescope find_files <CR>', { desc = 'Find files' })
    vim.keymap.set('.', '<leader>fa', '<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>', { desc = 'Find all' })
    vim.keymap.set('.', '<leader>fw', '<cmd> Telescope live_grep <CR>', { desc = 'Live grep' })
    vim.keymap.set('.', '<leader>fb', '<cmd> Telescope buffers <CR>', { desc = 'Find buffers' })
    vim.keymap.set('.', '<leader>fh', '<cmd> Telescope help_tags <CR>', { desc = 'Help page' })
    vim.keymap.set('.', '<leader>fo', '<cmd> Telescope oldfiles <CR>', { desc = 'Find oldfiles' })
    vim.keymap.set('.', '<leader>fz', '<cmd> Telescope current_buffer_fuzzy_find <CR>', { desc = 'Find in current buffer' })
    vim.keymap.set('.', '<leader>fk', '<cmd> Telescope keymaps <CR>', { desc = '[T]elescope [K]eymaps' })

    -- git
    vim.keymap.set('.', '<leader>cm', '<cmd> Telescope git_commits <CR>', { desc = 'Git commits' })
    vim.keymap.set('.', '<leader>gt', '<cmd> Telescope git_status <CR>', { desc = 'Git status' })

    -- pick a hidden term
    vim.keymap.set('.', '<leader>pt', '<cmd> Telescope terms <CR>', { desc = 'Pick hidden term' })

    -- theme switcher
    vim.keymap.set('.', '<leader>th', '<cmd> Telescope themes <CR>', { desc = 'Nvchad themes' })

    vim.keymap.set('.', '<leader>ma', '<cmd> Telescope marks <CR>', { desc = 'telescope bookmarks' })
  },
}

M.whichkey = {
  plugin = true,

  n = {
    ['<leader>wK'] = {
      function()
        vim.cmd 'WhichKey'
      end,
      'Which-key all keymaps',
    },
    ['<leader>wk'] = {
      function()
        local input = vim.fn.input 'WhichKey: '
        vim.cmd('WhichKey ' .. input)
      end,
      'Which-key query lookup',
    },
  },
}

M.blankline = {
  plugin = true,

  n = {
    ['<leader>cc'] = {
      function()
        local ok, start =
          require('indent_blankline.utils').get_current_context(vim.g.indent_blankline_context_patterns, vim.g.indent_blankline_use_treesitter_scope)

        if ok then
          vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
          vim.cmd [[normal! _]]
        end
      end,

      'Jump to current context',
    },
  },
}

M.gitsigns = {
  plugin = true,

  n = {
    -- Navigation through hunks
    [']c'] = {
      function()
        if vim.wo.diff then
          return ']c'
        end
        vim.schedule(function()
          require('gitsigns').next_hunk()
        end)
        return '<Ignore>'
      end,
      'Jump to next hunk',
      opts = { expr = true },
    },

    ['[c'] = {
      function()
        if vim.wo.diff then
          return '[c'
        end
        vim.schedule(function()
          require('gitsigns').prev_hunk()
        end)
        return '<Ignore>'
      end,
      'Jump to prev hunk',
      opts = { expr = true },
    },

    -- Actions
    ['<leader>rh'] = {
      function()
        require('gitsigns').reset_hunk()
      end,
      'Reset hunk',
    },

    ['<leader>ph'] = {
      function()
        require('gitsigns').preview_hunk()
      end,
      'Preview hunk',
    },

    ['<leader>gb'] = {
      function()
        package.loaded.gitsigns.blame_line()
      end,
      'Blame line',
    },

    ['<leader>td'] = {
      function()
        require('gitsigns').toggle_deleted()
      end,
      'Toggle deleted',
    },
  },
}

M.UndoTree = {
  plugin = true,
  n = {
    ['<leader>tu'] = {
      '<cmd> UndotreeFocus <CR>',
      '[T]oggle [U]ndo tree',
    },
  },
}

return M
