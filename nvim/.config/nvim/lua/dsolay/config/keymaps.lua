-- ============================================================================
-- Keymaps Configuration
-- ============================================================================
-- Global keymaps using vim.keymap.set() native API
-- Organized by functionality for better maintainability
-- Descriptions are automatically picked up by which-key.nvim

-- ============================================================================
-- Leader Key Bindings
-- ============================================================================
-- Keymaps starting with <leader> for various operations

vim.keymap.set("n", "<leader><C-e>", "ggVG", { desc = "Select All" })
vim.keymap.set("n", "<leader><Esc>", [[:let @/=""<CR>]], { desc = "Clear Match" })
vim.keymap.set("n", "<leader>pwd", "<cmd>echo expand('%')<CR>", { desc = "Show Path" })
vim.keymap.set("n", "<leader>rw", [[:%s/<C-R>=expand('<cword>')<CR>/]], { desc = "Rewrite Word" })
vim.keymap.set("n", "<leader>ss",
    [[<cmd>execute "grep " . "\"". expand("<cword>") . "\" " . finddir('.git/..', expand('%:p:h').';') <Bar> TroubleToggle quickfix<cr>]],
    { desc = "Search Grep" }
)

-- ============================================================================
-- Function Keys
-- ============================================================================
-- F-keys for quick access to common features

vim.keymap.set("n", "<F7>", ":setlocal spell! spelllang=es<CR>", { desc = "Toggle Spanish Spelling" })

-- ============================================================================
-- Navigation: Better j/k
-- ============================================================================
-- Treat wrapped lines as normal lines when using j/k
-- Normal/Visual mode: move by visual line if no count, else by line

vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down (Arrow)", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up (Arrow)", expr = true, silent = true })

-- ============================================================================
-- Window Navigation
-- ============================================================================
-- Navigate between windows using Ctrl+hjkl (like tmux)

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- ============================================================================
-- Window Resizing
-- ============================================================================
-- Resize windows using Ctrl+Arrow keys

vim.keymap.set("n", "<C-S-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-S-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- ============================================================================
-- Control Keys - Scrolling & Operations
-- ============================================================================
-- Common operations with Ctrl combinations

vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
vim.keymap.set("n", "<A-q>", "<cmd>bd<CR>", { desc = "Close Buffer" })

-- ============================================================================
-- Buffer Navigation
-- ============================================================================
-- Quick navigation between open buffers

vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer (Alt)" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer (Alt)" })

-- ============================================================================
-- Miscellaneous
-- ============================================================================
-- Single keymaps that don't fit other categories

vim.keymap.set("n", "<BS>", "g`'", { desc = "Back to Last Position" })

-- ============================================================================
-- Tab Management
-- ============================================================================
-- Tab navigation and manipulation commands

vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- lazygit
if vim.fn.executable("lazygit") == 1 then
  vim.keymap.set("n", "<leader>lg", function() Snacks.lazygit() end, { desc = "Lazygit (cwd)" })
end

-- windows
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
Snacks.toggle.zen():map("<leader>uz")

-- floating terminal
vim.keymap.set("n", "<leader>fT", function() Snacks.terminal() end, { desc = "Terminal (cwd)" })
vim.keymap.set({"n","t"}, "<c-/>",function() Snacks.terminal() end, { desc = "Terminal (Root Dir)" })
vim.keymap.set({"n","t"}, "<c-_>",function() Snacks.terminal() end, { desc = "which_key_ignore" })

-- toggle options
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
Snacks.toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }):map("<leader>uA")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.option("background", { off = "light", on = "dark" , name = "Dark Background" }):map("<leader>ub")
Snacks.toggle.dim():map("<leader>uD")
Snacks.toggle.animate():map("<leader>ua")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.scroll():map("<leader>uS")
Snacks.toggle.profiler():map("<leader>dpp")
Snacks.toggle.profiler_highlights():map("<leader>dph")

if vim.lsp.inlay_hint then
  Snacks.toggle.inlay_hints():map("<leader>uh")
end
