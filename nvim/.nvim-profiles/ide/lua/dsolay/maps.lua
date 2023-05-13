local keymap = vim.keymap

-- Show help under the cursor
keymap.set("n", "<Leader>h", ":help <C-R><C-W><CR>")

-- Save buffer
keymap.set("n", "<F2>", "<CMD>update<CR>")
keymap.set("i", "<C-S>", "<CMD>update<CR>")

-- Select all
keymap.set("n", "<Leader><C-E>", "ggVG")

-- Rewrite all
keymap.set("n", "<Leader>rw", ":%s/<C-R>=expand('<cword>')<CR>/")

keymap.set(
    "n",
    "<C-f>",
    [[<cmd>execute "grep " . "\"". expand("<cword>") . "\" " . finddir('.git/..', expand('%:p:h').';') <Bar> TroubleToggle quickfix<cr>]]
)

-- Clear match
keymap.set("", "<Leader><Esc>", [[<Cmd>let @/=""<CR>]])

-- Move between windows
keymap.set("n", "<C-h>", "<C-W>h")
keymap.set("n", "<C-j>", "<C-W>j")
keymap.set("n", "<C-k>", "<C-W>k")
keymap.set("n", "<C-l>", "<C-W>l")

-- Move between tabs
keymap.set({ "n", "i" }, "<C-S-Right>", "<Cmd>tabnext<CR>")
keymap.set({ "n", "i" }, "<C-S-Left>", "<Cmd>tabprev<CR>")

-- Move between buffers
keymap.set({ "n", "i" }, "<C-Right>", "<Cmd>bnext<CR>")
keymap.set({ "n", "i" }, "<C-Left>", "<Cmd>bprev<CR>")

-- Move lines
keymap.set({ "n", "i" }, "<S-Up>", "<Cmd>m-2<CR>")
keymap.set({ "n", "i" }, "<S-Down>", "<Cmd>m+<CR>")

-- Close current buffer
keymap.set({ "n", "i" }, "<A-q>", "<Cmd>bd<CR>")

-- Toggle spanish spelling
keymap.set("n", "<F7>", ":setlocal spell! spelllang=es<CR>")
keymap.set("i", "<F7>", "<C-o>:setlocal spell! spelllang=es<cr>")

-- Resize window
keymap.set("n", "<C-w><Left>", "<Cmd>vertical resize +5<CR>")
keymap.set("n", "<C-w><Right>", "<Cmd>vertical resize -5<CR>")
keymap.set("n", "<C-w><Up>", "<Cmd>resize -5<CR>")
keymap.set("n", "<C-w><Down>", "<Cmd>resize +5<CR>")

-- Current path
keymap.set("n", "<Leader>pwd", "<Cmd>echo expand(\'%\')<CR>")

-- Back to last position
keymap.set("n", "<BS>", "g`'")

-- toggle wrap
keymap.set("n", "<Leader>tw", function()
    vim.opt.wrap = not vim.opt.wrap:get()
end)
