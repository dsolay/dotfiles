local map = require('utils').map
local opts = {silent = true}

require('todo-comments').setup {}

map('n', '<leader>ft', [[<cmd>TodoTelescope<cr>]], opts)
map('n', '<leader>xt', [[<cmd>TodoTrouble<cr>]], opts)
map('n', '<leader>tq', [[<cmd>TodoQuickFix<cr>]], opts)
