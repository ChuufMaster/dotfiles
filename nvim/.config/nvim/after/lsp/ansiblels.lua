return {
    cmd = { "ansible-language-server", "--stdio" },
    settings = {
        ansible = {
            python = {
                interpreterPath = "python",
            },
            ansible = {
                path = "ansible",
            },
            executionEnvironment = {
                enabled = false,
            },
            validation = {
                enabled = true,
                lint = {
                    enabled = true,
                    path = "ansible-lint",
                },
            },
        },
    },
    filetypes = { "yaml.ansible" },
    root_markders = { "ansible.cfg", ".ansible-lint" },
    single_file_support = true,
}
