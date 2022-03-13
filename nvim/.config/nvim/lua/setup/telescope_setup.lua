local map = require('utils').map

local opts = {silent = true}
map('n', '<leader>fb', [[<cmd>Telescope buffers<cr>]], opts)
map('n', '<leader>fp', [[<cmd>Telescope git_files<cr>]], opts)
map('n', '<leader>ff', [[<cmd>Telescope find_files hidden=true<cr>]], opts)
map('n', '<leader>fg', [[<cmd>Telescope live_grep<cr>]], opts)
map('n', '<leader>fq', [[<cmd>Telescope quickfix<cr>]], opts)
map('n', '<leader>fl', [[<cmd>Telescope localist<cr>]], opts)
map('n', '<leader>fo', [[<cmd>Telescope vim_options<cr>]], opts)
map('n', '<leader>fr', [[<cmd>Telescope registers<cr>]], opts)
map('n', '<leader>fc', [[<cmd>Telescope commands<cr>]], opts)
map('n', '<leader>fm', [[<cmd>Telescope man_pages<cr>]], opts)
map('n', '<leader>fs', [[<cmd>Telescope spell_suggest<cr>]], opts)
map('n', '<leader>fk', [[<cmd>Telescope keymaps<cr>]], opts)

-- lsp pickers
map('n', '<leader>lr', [[<cmd>Telescope lsp_references<cr>]], opts)
map('n', '<leader>lds', [[<cmd>Telescope lsp_document_symbols<cr>]], opts)
map('n', '<leader>lws', [[<cmd>Telescope lsp_workspace_symbols<cr>]], opts)
map('n', '<leader>ldws', [[<cmd>Telescope lsp_dynamic_workspace_symbols<cr>]], opts)
map('n', '<leader>lca', [[<cmd>Telescope lsp_code_actions<cr>]], opts)
map('n', '<leader>lrca', [[<cmd>Telescope lsp_range_code_actions<cr>]], opts)
map('n', '<leader>li', [[<cmd>Telescope lsp_implementations<cr>]], opts)
map('n', '<leader>ld', [[<cmd>Telescope lsp_definitions<cr>]], opts)
