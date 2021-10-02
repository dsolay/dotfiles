local utils = require('utils')
local map = utils.map

local opts = {silent = true, noremap = true}
map('n', 'fm', '<cmd>TZFocus<cr>', opts)
map('n', 'mm', '<cmd>TZMinimalist<cr>', opts)
map('n', 'am', '<cmd>TZAtaraxis<cr>', opts)

