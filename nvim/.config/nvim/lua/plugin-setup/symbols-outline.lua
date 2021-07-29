local map = require('utils').map

local opts = {silent = true}
map('n', '<leader>so', [[<cmd>SymbolsOutline<cr>]], opts)

vim.g.symbols_outline = {
    auto_preview = false,
}
