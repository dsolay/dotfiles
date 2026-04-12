vim.treesitter.start()

-- Excute python files
vim.keymap.set("n", "<Leader>epy", ":!python %<CR>", { desc = "Execute Python File" })
