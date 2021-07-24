local map = require('utils').map

local opts = {silent = true}
map('n', '<leader>db', [[<cmd>DBUIToggle<cr>]], opts)
