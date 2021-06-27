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
