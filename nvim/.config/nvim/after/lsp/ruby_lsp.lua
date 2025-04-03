---@type vim.lsp.ClientConfig
return {
    cmd = { "ruby-lsp" },
    filetypes = { "ruby", "eruby" },
    -- root_dir = util.root_pattern("Gemfile", ".git"),
    root_markers = {
        "Gemfile",
        ".git",
    },
    init_options = {
        formatter = "auto",
        enabledFeatures = {
            hover = true,
            diagnostics = true,
            completion = true,
        },
    },
    -- single_file_support = true,
}
