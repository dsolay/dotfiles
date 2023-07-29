local keymap = vim.keymap

keymap.set("n", "<C-d>", function()
    require("dapui").toggle({})
end)
