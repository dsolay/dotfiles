local keymap = vim.keymap
keymap.set("n", "<leader>zn", ":TZNarrow<CR>")
keymap.set("v", "<leader>zn", ":'<,'>TZNarrow<CR>")
keymap.set("n", "<Leader>zf", "<Cmd>TZFocus<CR>")
keymap.set("n", "<Leader>zm", "<Cmd>TZMinimalist<CR>")
keymap.set("n", "<Leader>za", "<Cmd>TZAtaraxis<CR>")
