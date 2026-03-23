return {
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("dsolay.config.alpha")
        end,
    },

    { "nvim-tree/nvim-web-devicons" },

    {
        "mg979/vim-visual-multi",
        branch = "master",
    },

    { "tpope/vim-dotenv" },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = { char = "|" },
            exclude = {
                filetypes = {
                    "lspinfo",
                    "text",
                    "markdown",
                    "txt",
                    "startify",
                    "alpha",
                    "packer",
                    "checkhealth",
                    "help",
                    "dbout",
                    "packer",
                    "man",
                    "gitcommit",
                    "TelescopePrompt",
                    "TelescopeResults",
                },
            },
        },
    },

    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            { "tpope/vim-dadbod", lazy = true },
            { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
        },
        cmd = {
            "DBUI",
            "DBUIToggle",
            "DBUIAddConnection",
            "DBUIFindBuffer",
        },
        init = function()
            -- Your DBUI configuration
            vim.g.db_ui_use_nerd_fonts = 1
        end,
        config = function()
            local helpers = require("dsolay.config.dadbod-ui")
            vim.g.db_ui_table_helpers = helpers

            vim.g.db_ui_auto_execute_table_helpers = 1
            vim.g.db_ui_force_echo_notifications = 1
            vim.g.db_ui_win_position = "right"

            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_show_database_icon = 1
        end,
        keys = { { "<leader>db", "<cmd>DBUIToggle<cr>", desc = "Toggle Database UI" } },
    },

    {
        "nvim-tree/nvim-tree.lua",
        opts = {
            disable_netrw = true,
            hijack_netrw = true,
            diagnostics = { enable = true },
            auto_reload_on_write = false,
            trash = {
                cmd = "trash-put",
                require_confirm = true,
            },
            git = { enable = true, ignore = false, timeout = 500 },
        },
        keys = {
            {
                "<C-b>",
                function()
                    require("nvim-tree.api").tree.toggle()
                end,
                desc = "Toggle File Tree",
            },
            {
                "<leader>tr",
                function()
                    require("nvim-tree.api").tree.reload()
                end,
                desc = "Reload File Tree",
            },
            {
                "<leader>tf",
                function()
                    require("nvim-tree.api").tree.find_file({ open = true, focus = true })
                end,
                desc = "Find File in Tree",
            },
        },
    },

    {
        "norcalli/nvim-colorizer.lua",
        ft = { "css", "scss", "javascript", "vue", "vim", "html", "pug", "lua" },
        opts = {
            "css",
            "scss",
            "javascript",
            "vue",
            "vim",
            "html",
            "pug",
            "lua",
        },
    },

    {
        "folke/todo-comments.nvim",
        lazy = false,
        config = true,
        keys = {
            {
                "]t",
                function()
                    require("todo-comments").jump_next()
                end,
                desc = "Next Todo Comment",
            },
            {
                "[t",
                function()
                    require("todo-comments").jump_prev()
                end,
                desc = "Previous Todo Comment",
            },
            { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo Trouble" },
            { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme Trouble" },
        },
    },

    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        opts = {
            use_diagnostic_signs = true,
        },
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics",
            },
            {
                "<leader>xs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols",
            },
            {
                "<leader>xl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Items",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List",
            },
        },
    },

    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            on_attach = function(bufnr)
                local gitsigns = require("gitsigns")

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gitsigns.nav_hunk("next")
                    end
                end, { desc = "Next Change" })

                map("n", "[c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gitsigns.nav_hunk("prev")
                    end
                end, { desc = "Prev Change" })

                -- Actions
                map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage Hunk" })
                map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset Hunk" })

                map("v", "<leader>hs", function()
                    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "Stage Hunk" })

                map("v", "<leader>hr", function()
                    gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "Reset Hunk" })

                map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage Buffer" })
                map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset Buffer" })
                map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview Hunk" })
                map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview Inline" })

                map("n", "<leader>hb", function()
                    gitsigns.blame_line({ full = true })
                end, { desc = "Blame Line" })

                map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff This" })

                map("n", "<leader>hD", function()
                    gitsigns.diffthis("~")
                end, { desc = "Diff This ~" })

                map("n", "<leader>hQ", function()
                    gitsigns.setqflist("all")
                end, { desc = "Set QF All" })
                map("n", "<leader>hq", gitsigns.setqflist, { desc = "Set QF" })

                -- Toggles
                map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle Blame" })
                map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "Toggle Deleted" })
                map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle Word Diff" })

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk" })
            end,
        },
    },

    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install",
        ft = { "markdown" },
        keys = {
            { "<leader>md", [[<cmd>MarkdownPreviewToggle<cr>]], desc = "Markdown Preview" },
        },
        config = function()
            vim.g.mkdp_filetypes = { "markdown" }
            vim.g.mkdp_browser = "/usr/bin/google-chrome-stable"
            vim.g.mkdp_echo_preview_url = 1
        end,
    },

    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
        keys = {
            { "<leader>dfo", [[<cmd>DiffviewOpen<cr>]], desc = "Diffview Open" },
            { "<leader>dfc", [[<cmd>DiffviewClose<cr>]], desc = "Diffview Close" },
            { "<leader>dfl", [[<cmd>DiffviewLog<cr>]], desc = "Diffview Log" },
            { "<leader>dfr", [[<cmd>DiffviewRefresh<cr>]], desc = "Diffview Refresh" },
            { "<leader>dfh", [[<cmd>DiffviewFileHistory<cr>]], desc = "File History", mode = { "n", "v" } },
        },
        config = true,
    },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                disabled_filetypes = {
                    statusline = {
                        "NvimTree",
                        "lazy",
                        "mason",
                        "help",
                        "checkhealth",
                        "lspinfo",
                        "noice",
                        "Trouble",
                        "fish",
                        "zsh",
                        "text",
                        "alpha",
                    },
                    winbar = {},
                },
            },
        },
    },

    {
        "m4xshen/smartcolumn.nvim",
        opts = {
            disabled_filetypes = {
                "NvimTree",
                "lazy",
                "mason",
                "help",
                "checkhealth",
                "lspinfo",
                "noice",
                "Trouble",
                "fish",
                "zsh",
                "text",
                "alpha",
            },
        },
    },

    {
        "echasnovski/mini.move",
        version = "*",
        opts = {
            options = {
                reindent_linewise = true,
            },
        },
    },

    -- lazy.nvim
    {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {},
    },

    {
        "hedyhli/outline.nvim",
        lazy = true,
        cmd = { "Outline", "OutlineOpen" },
        keys = { -- Example mapping to toggle outline
            { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle Outline" },
        },
        opts = {
            -- Your setup opts here
        },
    },

    {
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            workspaces = {
                {
                    name = "Work",
                    path = "~/vaults/work",
                },
                {
                    name = "Nebula",
                    path = "~/vaults/nebula",
                },
            },

            notes_subdir = "notes",
        },
    },

    {
        "hat0uma/csvview.nvim",
        opts = {
            parser = { comments = { "#", "//" } },
            keymaps = {
                -- Text objects for selecting fields
                textobject_field_inner = { "if", mode = { "o", "x" } },
                textobject_field_outer = { "af", mode = { "o", "x" } },
                -- Excel-like navigation:
                -- Use <Tab> and <S-Tab> to move horizontally between fields.
                -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
                -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
                jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
                jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
                jump_next_row = { "<Enter>", mode = { "n", "v" } },
                jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
            },
        },
        cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    },

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

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            bigfile = { enabled = true },
            dim = { enabled = true },
            lazygit = {},
            terminal = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = true },
            zen = {},
            picker = {},
            explorer = { replace_netrw = true, trash = true },
            gitbrowse = {},
        },
    },
}
