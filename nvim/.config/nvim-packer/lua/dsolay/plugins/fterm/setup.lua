local keymap = vim.keymap
keymap.set("n", "<A-d>", function()
    require("FTerm").toggle()
end)
keymap.set("t", "<A-d>", '<C-\\><C-n><Cmd>lua require("FTerm").toggle()<CR>')
