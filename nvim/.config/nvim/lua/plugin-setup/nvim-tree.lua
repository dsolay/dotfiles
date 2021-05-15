local utils = require('utils')
local map = utils.map

vim.g.nvim_tree_auto_close = 0
vim.g.nvim_tree_auto_ignore_ft = { 'startify', 'dashboard' }
vim.g.nvim_tree_width_allow_resize  = 1
vim.g.nvim_tree_disable_netrw = 0
vim.g.nvim_tree_hijack_netrw = 0

map('n', '<C-b>', [[<cmd>NvimTreeToggle<cr>]])
map('n', '<laeder>tr', [[<cmd>NvimTreeRefresh<cr>]])
map('n', '<leader>tf', [[<cmd>NvimTreeFindFile<cr>]])
