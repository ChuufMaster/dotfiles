-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.opt.termguicolors = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true

-- This file is automatically loaded by lazyvim.config.init.

-- vim.g.python3_host_prog = '/home/linuxbrew/.linuxbrew/bin/python3'

local function augroup(name)
  return vim.api.nvim_create_augroup('lazyvim_' .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup('checktime'),
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('highlight_yank'),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = augroup('resize_splits'),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup('last_loc'),
  callback = function(event)
    local exclude = { 'gitcommit' }
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
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('close_with_q'),
  pattern = {
    'PlenaryTestPopup',
    'help',
    'lspinfo',
    'notify',
    'qf',
    'spectre_panel',
    'startuptime',
    'tsplayground',
    'neotest-output',
    'checkhealth',
    'neotest-summary',
    'neotest-output-panel',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('man_unlisted'),
  pattern = { 'man' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('wrap_spell'),
  pattern = { 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup('json_conceal'),
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = augroup('auto_create_dir'),
  callback = function(event)
    if event.match:match('^%w%w+:[\\/][\\/]') then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

local pinned_buffers = {}

local function pin_buffer(bufnr)
  pinned_buffers[bufnr] = true
end

local function unpin_buffer(bufnr)
  pinned_buffers[bufnr] = nil
end

local function is_pinned(bufnr)
  return pinned_buffers[bufnr] ~= nil
end

vim.api.nvim_create_user_command('PinBuffer', function()
  local bufnr = vim.fn.bufnr()
  if is_pinned(bufnr) then
    unpin_buffer(bufnr)
    return
  end
  pin_buffer(bufnr)
end, {})

local function get_last_access_time(bufnr)
  local ok, last_used = pcall(vim.api.nvim_buf_get_var, bufnr, 'last_used')
  return ok and last_used or 0
end
-- Define a Lua function to handle the autocommand
local function delete_oldest_buffer()
  -- Get all buffers
  local all_buffers = vim.api.nvim_list_bufs()
  -- Initialize an empty table to store buffers associated with files
  local file_buffers = {}
  -- Iterate through each buffer
  for _, bufnr in ipairs(all_buffers) do
    -- Check if the buffer is associated with a file and does not have unsaved changes
    if vim.api.nvim_buf_is_loaded(bufnr) and not is_pinned(bufnr) and vim.bo[bufnr].buftype == '' and not vim.api.nvim_buf_get_option(bufnr, 'modified') then
      table.insert(file_buffers, bufnr)
    end
  end
  -- Sort file buffers by last accessed time
  table.sort(file_buffers, function(a, b)
    return get_last_access_time(a) > get_last_access_time(b)
  end)
  -- Delete the oldest buffer
  if #file_buffers > 6 then
    local oldest_bufnr = file_buffers[#file_buffers]
    print('Deleting the oldest buffer:', vim.api.nvim_buf_get_name(oldest_bufnr))
    vim.cmd('bd ' .. oldest_bufnr)
  else
    -- print('No file buffers to delete.')
  end
end

-- Define the autocommand

vim.api.nvim_create_augroup('DeleteOldestBufferGroup', { clear = true })

-- Autocommand to update the last accessed time
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  group = 'DeleteOldestBufferGroup',
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_var(bufnr, 'last_used', vim.loop.now())
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  group = 'DeleteOldestBufferGroup',
  callback = function()
    if vim.bo.filetype ~= '' and vim.bo.buftype == '' and not vim.bo.readonly then
      delete_oldest_buffer()
    end
  end,
})
