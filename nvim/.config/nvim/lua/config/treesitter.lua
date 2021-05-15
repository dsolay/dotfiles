local ts_configs = require('nvim-treesitter.configs')
ts_configs.setup {
    ensure_installed = {
        'bash', 'c', 'css', 'go', 'haskell', 'html', 'javascript', 'json',
        'jsonc', 'kotlin', 'latex', 'lua', 'python', 'regex', 'rust', 'scss',
        'toml', 'typescript', 'yaml', 'php'
    },
    highlight = {enable = true, use_languagetree = true},
    indent = {enable = false},
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = 'gnn',
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grm'
        }
    }
}
