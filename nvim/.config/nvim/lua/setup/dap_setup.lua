local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map('n', '<F5>', [[<cmd>lua require'dap'.continue()<cr>]], opts)
map('n', '<F10>', [[<cmd>lua require'dap'.step_over()<cr>]], opts)
map('n', '<F11>', [[<cmd>lua require('dap').step_into()<cr>]], opts)
map('n', '<F12>', [[<cmd>lua require('dap').step_out()<cr>]], opts)
map('n', '<leader>b', [[<cmd>lua require('dap').toggle_breakpoint()<cr>]], opts)
map('n', '<leader>dr', [[<cmd>lua require('dap').repl.open()<cr>]], opts)
map('n', '<leader>dl', [[<cmd>lua require('dap').run_last()<cr>]], opts)
