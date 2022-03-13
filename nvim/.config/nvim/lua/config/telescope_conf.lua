local telescope = require('telescope')

telescope.load_extension('project')
telescope.load_extension('fzf')

telescope.setup {
    defaults = {layout_strategy = 'flex'},
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
        },
        project = {hidden_files = true},
    },

}
