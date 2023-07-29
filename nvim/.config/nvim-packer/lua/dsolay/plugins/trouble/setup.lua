local keymap = vim.keymap
keymap.set("n", "<Leader>to", "<Cmd>TroubleToggle<CR>")
keymap.set("n", "<Leader>tow", "<Cmd>TroubleToggle workspace_diagnostics<CR>")
keymap.set("n", "<Leader>tod", "<Cmd>TroubleToggle document_diagnostics<CR>")
keymap.set("n", "<Leader>tol", "<Cmd>TroubleToggle loclist<CR>")
keymap.set("n", "<Leader>toq", "<Cmd>TroubleToggle quickfix<CR>")
keymap.set("n", "<Leader>tgr", "<Cmd>TroubleToggle lsp_references<CR>")
keymap.set("n", "<Leader>tgd", "<Cmd>TroubleToggle lsp_definitions<CR>")
