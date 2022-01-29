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

