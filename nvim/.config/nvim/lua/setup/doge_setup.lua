local map = require('utils').map

local opts = {silent = true}
map('n', '<leader>doc', [[<cmd>DogeGenerate<cr>]], opts)
