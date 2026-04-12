vim.treesitter.start()

-- Excute typescript files
vim.keymap.set("n", "<Leader>ets", ":!ts-node %<CR>", { desc = "Execute TypeScript File" })
