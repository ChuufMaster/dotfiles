function indent_level(lnum)
    return vim.fn.indent(lnum) / vim.o.shiftwidth
end

function next_non_blank_line(lnum)
    local numlines = vim.fn.line("$")
    local current = lnum + 1

    while current <= numlines do
        if vim.fn.getline(current):match("%S") then
            return current
        end
        current = current + 1
    end

    return -2
end

function get_potion_fold(lnum)
    if vim.fn.getline(lnum):match("^%s*$") then
        return "-1"
    end

    local this_indent = indent_level(lnum)
    local next_indent = indent_level(next_non_blank_line(lnum))

    if next_indent == this_indent then
        return tostring(this_indent)
    elseif next_indent < this_indent then
        return tostring(this_indent)
    elseif next_indent > this_indent then
        return ">" .. tostring(next_indent)
    end
end

function custom_fold_text()
    local fs = vim.v.foldstart

    while vim.fn.getline(fs):match("^%s*$") do
        fs = vim.fn.nextnonblank(fs + 1)
    end

    local line
    if fs > vim.v.foldend then
        line = vim.fn.getline(vim.v.foldstart)
    else
        line = vim.fn.substitute(vim.fn.getline(fs), "\t", string.rep(" ", vim.o.tabstop), "g")
    end

    local w = vim.fn.winwidth(0) - vim.o.foldcolumn - (vim.o.number and 8 or 0)
    local fold_size = 1 + vim.v.foldend - vim.v.foldstart
    local fold_size_str = " " .. fold_size .. " lines "
    local fold_level_str = string.rep("+--", vim.v.foldlevel)
    local expansion_string = string.rep(" ", w - vim.fn.strwidth(fold_size_str .. line .. fold_level_str))

    return line .. expansion_string .. fold_size_str .. fold_level_str
end

vim.opt.foldtext = "v:lua.custom_fold_text()"
vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.o.foldlevelstart = 1
vim.opt.fillchars = { fold = "\\" }
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.get_potion_fold(v:lnum)"
-- vim.o.foldexpr = "v:lua.vim.treesiter.foldexpr()"
