local utils = require('utils')
local map = utils.map

local opts = {silent = true, noremap = true}
map('n', '<leader>to', '<cmd>TroubleToggle<cr>', opts)
map('n', '<leader>tow', '<cmd>TroubleToggle workspace_diagnostics<cr>', opts)
map('n', '<leader>tod', '<cmd>TroubleToggle document_diagnostics<cr>', opts)
map('n', '<leader>tol', '<cmd>TroubleToggle loclist<cr>', opts)
map('n', '<leader>toq', '<cmd>TroubleToggle quickfix<cr>', opts)
map('n', '<leader>tgr', '<cmd>TroubleToggle lsp_references<cr>', opts)
map('n', '<leader>tgd', '<cmd>TroubleToggle lsp_definitions<cr>', opts)
