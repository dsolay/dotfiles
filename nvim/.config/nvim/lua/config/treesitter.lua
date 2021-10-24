local concat = require('utils').concat

local function get_parsers()
    local common_parsers = {
        'bash',
        'c',
        'dockerfile',
        'json',
        'jsonc',
        'lua',
        'regex',
        'toml',
        'yaml',
        'vim',
    }

    if os.getenv('PARSERS') then
        return concat(common_parsers, vim.split(os.getenv('PARSERS'), ';'))
    end

    return common_parsers
end

require('nvim-treesitter.configs').setup {
    ensure_installed = get_parsers(),
    highlight = {enable = true, use_languagetree = true},
    indent = {enable = false},
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
