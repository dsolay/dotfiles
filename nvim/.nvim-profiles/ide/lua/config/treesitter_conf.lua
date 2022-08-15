local ts_configs = require('nvim-treesitter.configs')
ts_configs.setup {
    ensure_installed = {
        'bash',
        'c',
        'css',
        'go',
        'graphql',
        'haskell',
        'html',
        'java',
        'javascript',
        'json',
        'jsonc',
        'kotlin',
        'latex',
        'lua',
        'python',
        'regex',
        'rust',
        'scss',
        'toml',
        'typescript',
        'tsx',
        'yaml',
        'php',
        'vue',
        'dockerfile',
        'c_sharp'
    },
    highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = true,
    },
    indent = {enable = false},
    rainbow = {enable = true, extended_mode = true, max_file_lines = 1000},
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
        config = {
            javascript = {
                __default = '// %s',
                jsx_element = '{/* %s */}',
                jsx_fragment = '{/* %s */}',
                jsx_attribute = '// %s',
                comment = '// %s',
                __parent = {
                    -- if a node has this as the parent, use the `//` commentstring
                    jsx_expression = '// %s',
                },
            },
        },
    },
    matchup = {enable = true},
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = 'gnn',
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grm',
        },
    },
}

