local utils = require('utils')
local map = utils.map

map('n', '<C-b>', [[<cmd>NvimTreeToggle<cr>]])
map('n', '<laeder>tr', [[<cmd>NvimTreeRefresh<cr>]])
map('n', '<leader>tf', [[<cmd>NvimTreeFindFile<cr>]])
