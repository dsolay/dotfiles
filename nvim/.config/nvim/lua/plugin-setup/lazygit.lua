local map = require('utils').map

local silent = {silent = true}

map('n', '<leader>lg', '<cmd>LazyGit<cr>', silent)

vim.g.lazygit_floating_window_use_plenary = 1
