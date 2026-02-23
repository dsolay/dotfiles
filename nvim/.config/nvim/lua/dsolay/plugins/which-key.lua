return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            preset = "modern",
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)

            -- SECCIÓN 1: Grupo <leader> (14 subgrupos + manual toggle)
            wk.add({
                { "<leader><C-e>", "ggVG", desc = "Select All" },
                { "<leader><Esc>", [[:let @/=""<CR>]], desc = "Clear Match" },
                { "<leader>pwd", "<cmd>echo expand('%')<CR>", desc = "Show Path" },
                { "<leader>rw", [[:%s/<C-R>=expand('<cword>')<CR>/]], desc = "Rewrite Word" },
                {
                    "<leader>ss",
                    [[<cmd>execute "grep " . "\"". expand("<cword>") . "\" " . finddir('.git/..', expand('%:p:h').';') <Bar> TroubleToggle quickfix<cr>]],
                    desc = "Search Grep",
                },
                {
                    "<leader>tw",
                    function()
                        vim.opt.wrap = not vim.opt.wrap:get()
                    end,
                    desc = "Toggle Wrap",
                },
            })

            -- SECCIÓN 2: Grupo <C-w> (navegación/resize ventanas)
            wk.add({
                { "<C-w><Left>", "<cmd>vertical resize +5<CR>", desc = "Resize Vertical +5" },
                { "<C-w><Right>", "<cmd>vertical resize -5<CR>", desc = "Resize Vertical -5" },
                { "<C-w><Up>", "<cmd>resize -5<CR>", desc = "Resize Horizontal -5" },
                { "<C-w><Down>", "<cmd>resize +5<CR>", desc = "Resize Horizontal +5" },
                { "<C-Right>", "<cmd>bnext<CR>", desc = "Next Buffer" },
                { "<C-Left>", "<cmd>bprev<CR>", desc = "Prev Buffer" },
                { "<C-S-Right>", "<cmd>tabnext<CR>", desc = "Next Tab" },
                { "<C-S-Left>", "<cmd>tabprev<CR>", desc = "Prev Tab" },
            })

            -- SECCIÓN 3: Grupo <F-keys>
            wk.add({
                { "<F2>", "<cmd>update<CR>", desc = "Save File" },
                { "<F7>", ":setlocal spell! spelllang=es<CR>", desc = "Toggle Spanish Spelling" },
            })

            -- SECCIÓN 4: Grupo <C-*> Otros
            wk.add({
                { "<C-d>", "<C-d>zz", desc = "Scroll Down Centered" },
                { "<C-u>", "<C-u>zz", desc = "Scroll Up Centered" },
                { "<C-s>", "<cmd>update<CR>", desc = "Save (Insert)" },
                { "<A-q>", "<cmd>bd<CR>", desc = "Close Buffer" },
            })

            -- SECCIÓN 5: Otros bindings globales
            wk.add({
                { "<BS>", "g`'", desc = "Back to Last Position" },
            })
        end,
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
}
