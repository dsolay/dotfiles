local map = require('utils').map

local silent = {silent = true}

map('n', '<leader>lg', '<cmd>LazyGit<cr>', silent)
