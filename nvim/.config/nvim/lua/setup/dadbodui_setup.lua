local map = require('utils').map

local opts = {silent = true}
map('n', '<leader>db', [[<cmd>DBUIToggle<cr>]], opts)

vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_show_database_icon = 1
