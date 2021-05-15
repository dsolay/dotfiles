require('gitsigns').setup {
    signs = {
        add = {hl = 'GreenSign', text = '│', numhl = 'GitSignsAddNr'},
        change = {hl = 'BlueSign', text = '│', numhl = 'GitSignsChangeNr'},
        delete = {hl = 'RedSign', text = '|', numhl = 'GitSignsDeleteNr'},
        topdelete = {hl = 'RedSign', text = '|', numhl = 'GitSignsDeleteNr'},
        changedelete = {
            hl = 'PurpleSign',
            text = '|',
            numhl = 'GitSignsChangeNr',
        },
    },
    keymaps = {
        noremap = true,
        buffer = true,

        ['n ]c'] = {
            expr = true,
            '&diff ? \']c\' : \'<cmd>lua require"gitsigns".next_hunk()<CR>\'',
        },
        ['n [c'] = {
            expr = true,
            '&diff ? \'[c\' : \'<cmd>lua require"gitsigns".prev_hunk()<CR>\'',
        },

        ['n <leader>gs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
        ['n <leader>gu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
        ['n <leader>gr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
        ['n <leader>gR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
        ['n <leader>gp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
        ['n <leader>gb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',

        -- Text objects
        ['o ih'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
        ['x ih'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
    },
}
