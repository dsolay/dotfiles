require('indent_blankline').setup {
    use_treesitter = true,
    show_first_indent_level = false,
    show_trailing_blankline_indent = false,
    filetype_exclude = {
        'lspinfo',
        'text',
        'markdown',
        'txt',
        'startify',
        'alpha',
        'packer',
        'checkhealth',
        'help',
        'dbout',
    },
    show_current_context = true,
    show_current_context_start = true,
}
