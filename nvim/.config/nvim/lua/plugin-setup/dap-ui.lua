local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map('n', '<C-d>', '<cmd>lua require("dapui").toggle()<cr>', opts)
