-- Keybinding
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map('n', '<A-d>', '<cmd>lua require("FTerm").toggle()<cr>', opts)
map('t', '<A-d>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<cr>', opts)
