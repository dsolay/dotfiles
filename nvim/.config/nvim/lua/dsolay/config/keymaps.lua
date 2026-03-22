local utils = require("dsolay.utils")

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
vim.keymap.set("n", "<leader>rw", [[:%s/<C-R>=expand('<cword>')<CR>/]], { desc = "Rewrite Word" })
-- vim.keymap.set(
--     "n",
--     "<leader>ss",
--     [[<cmd>execute "grep " . "\"". expand("<cword>") . "\" " . finddir('.git/..', expand('%:p:h').';') <Bar> TroubleToggle quickfix<cr>]],
--     { desc = "Search Grep" }
-- )

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
vim.keymap.set(
    { "n", "x" },
    "<Down>",
    "v:count == 0 ? 'gj' : 'j'",
    { desc = "Down (Arrow)", expr = true, silent = true }
)
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

-- vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down Centered" })
-- vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up Centered" })
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
    vim.keymap.set("n", "<leader>lg", function()
        Snacks.lazygit()
    end, { desc = "Lazygit (cwd)" })
end

-- windows
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
Snacks.toggle.zen():map("<leader>uz")

-- floating terminal
vim.keymap.set("n", "<leader>fT", function()
    Snacks.terminal()
end, { desc = "Terminal (cwd)" })
vim.keymap.set("n", "<leader>ft", function()
    Snacks.terminal(nil, { cwd = utils.root() })
end, { desc = "Terminal (Root Dir)" })
vim.keymap.set({ "n", "t" }, "<c-/>", function()
    Snacks.terminal.focus(nil, { cwd = utils.root() })
end, { desc = "Terminal (Root Dir)" })
vim.keymap.set({ "n", "t" }, "<c-_>", function()
    Snacks.terminal.focus(nil, { cwd = utils.root() })
end, { desc = "which_key_ignore" })

-- toggle options
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle
    .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" })
    :map("<leader>uc")
Snacks.toggle
    .option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" })
    :map("<leader>uA")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
Snacks.toggle.dim():map("<leader>uD")
Snacks.toggle.animate():map("<leader>ua")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.scroll():map("<leader>uS")
Snacks.toggle.profiler():map("<leader>dpp")
Snacks.toggle.profiler_highlights():map("<leader>dph")

if vim.lsp.inlay_hint then
    Snacks.toggle.inlay_hints():map("<leader>uh")
end

vim.keymap.set({ "n" }, "<leader><space>", function()
    Snacks.picker.smart()
end, { desc = "Smart Find Files" })
vim.keymap.set({ "n" }, "<leader>,", function()
    Snacks.picker.buffers()
end, { desc = "Buffers" })
vim.keymap.set({ "n" }, "<leader>/", function()
    Snacks.picker.grep()
end, { desc = "Grep" })
vim.keymap.set({ "n" }, "<leader>:", function()
    Snacks.picker.command_history()
end, { desc = "Command History" })
vim.keymap.set({ "n" }, "<leader>n", function()
    Snacks.picker.notifications()
end, { desc = "Notification History" })
vim.keymap.set({ "n" }, "<leader>e", function()
    Snacks.explorer()
end, { desc = "File Explorer" })

-- find
vim.keymap.set({ "n" }, "<leader>fb", function()
    Snacks.picker.buffers()
end, { desc = "Buffers" })
vim.keymap.set({ "n" }, "<leader>fc", function()
    Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find Config File" })
vim.keymap.set({ "n" }, "<leader>ff", function()
    Snacks.picker.files()
end, { desc = "Find Files" })
vim.keymap.set({ "n" }, "<leader>fg", function()
    Snacks.picker.git_files()
end, { desc = "Find Git Files" })
vim.keymap.set({ "n" }, "<leader>fp", function()
    Snacks.picker.projects({ dev = { "~/workspace", "~/workspace/aplin/projects", "~/workspace/chivo" , "~/workspace/chivo/hub"} })
end, { desc = "Projects" })
vim.keymap.set({ "n" }, "<leader>fr", function()
    Snacks.picker.recent()
end, { desc = "Recent" })

-- git
vim.keymap.set({ "n" }, "<leader>gb", function()
    Snacks.picker.git_branches()
end, { desc = "Git Branches" })
vim.keymap.set({ "n" }, "<leader>gl", function()
    Snacks.picker.git_log()
end, { desc = "Git Log" })
vim.keymap.set({ "n" }, "<leader>gL", function()
    Snacks.picker.git_log_line()
end, { desc = "Git Log Line" })
vim.keymap.set({ "n" }, "<leader>gs", function()
    Snacks.picker.git_status()
end, { desc = "Git Status" })
vim.keymap.set({ "n" }, "<leader>gS", function()
    Snacks.picker.git_stash()
end, { desc = "Git Stash" })
vim.keymap.set({ "n" }, "<leader>gd", function()
    Snacks.picker.git_diff()
end, { desc = "Git Diff (Hunks)" })
vim.keymap.set({ "n" }, "<leader>gf", function()
    Snacks.picker.git_log_file()
end, { desc = "Git Log File" })
vim.keymap.set({ "n", "x" }, "<leader>gB", function()
    Snacks.gitbrowse()
end, { desc = "Git Browse (open)" })
vim.keymap.set({ "n", "x" }, "<leader>gY", function()
    Snacks.gitbrowse({
        open = function(url)
            vim.fn.setreg("+", url)
        end,
        notify = false,
    })
end, { desc = "Git Browse (copy)" })

-- Grep
vim.keymap.set({ "n" }, "<leader>sb", function()
    Snacks.picker.lines()
end, { desc = "Buffer Lines" })
vim.keymap.set({ "n" }, "<leader>sB", function()
    Snacks.picker.grep_buffers()
end, { desc = "Grep Open Buffers" })
vim.keymap.set({ "n" }, "<leader>sg", function()
    Snacks.picker.grep()
end, { desc = "Grep" })
vim.keymap.set({ "n", "x" }, "<leader>sw", function()
    Snacks.picker.grep_word()
end, { desc = "Visual selection or word" })

-- search
vim.keymap.set({ "n" }, '<leader>s"', function()
    Snacks.picker.registers()
end, { desc = "Registers" })
vim.keymap.set({ "n" }, "<leader>s/", function()
    Snacks.picker.search_history()
end, { desc = "Search History" })
vim.keymap.set({ "n" }, "<leader>sa", function()
    Snacks.picker.autocmds()
end, { desc = "Autocmds" })
vim.keymap.set({ "n" }, "<leader>sb", function()
    Snacks.picker.lines()
end, { desc = "Buffer Lines" })
vim.keymap.set({ "n" }, "<leader>sc", function()
    Snacks.picker.command_history()
end, { desc = "Command History" })
vim.keymap.set({ "n" }, "<leader>sC", function()
    Snacks.picker.commands()
end, { desc = "Commands" })
vim.keymap.set({ "n" }, "<leader>sd", function()
    Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
vim.keymap.set({ "n" }, "<leader>sD", function()
    Snacks.picker.diagnostics_buffer()
end, { desc = "Buffer Diagnostics" })
vim.keymap.set({ "n" }, "<leader>sh", function()
    Snacks.picker.help()
end, { desc = "Help Pages" })
vim.keymap.set({ "n" }, "<leader>sH", function()
    Snacks.picker.highlights()
end, { desc = "Highlights" })
vim.keymap.set({ "n" }, "<leader>si", function()
    Snacks.picker.icons()
end, { desc = "Icons" })
vim.keymap.set({ "n" }, "<leader>sj", function()
    Snacks.picker.jumps()
end, { desc = "Jumps" })
vim.keymap.set({ "n" }, "<leader>sk", function()
    Snacks.picker.keymaps()
end, { desc = "Keymaps" })
vim.keymap.set({ "n" }, "<leader>sl", function()
    Snacks.picker.loclist()
end, { desc = "Location List" })
vim.keymap.set({ "n" }, "<leader>sm", function()
    Snacks.picker.marks()
end, { desc = "Marks" })
vim.keymap.set({ "n" }, "<leader>sM", function()
    Snacks.picker.man()
end, { desc = "Man Pages" })
vim.keymap.set({ "n" }, "<leader>sp", function()
    Snacks.picker.lazy()
end, { desc = "Search for Plugin Spec" })
vim.keymap.set({ "n" }, "<leader>sq", function()
    Snacks.picker.qflist()
end, { desc = "Quickfix List" })
vim.keymap.set({ "n" }, "<leader>sR", function()
    Snacks.picker.resume()
end, { desc = "Resume" })
vim.keymap.set({ "n" }, "<leader>su", function()
    Snacks.picker.undo()
end, { desc = "Undo History" })
vim.keymap.set({ "n" }, "<leader>uC", function()
    Snacks.picker.colorschemes()
end, { desc = "Colorschemes" })
