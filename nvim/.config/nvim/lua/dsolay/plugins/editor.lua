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
                desc = "Toggle File Explorer",
            },
            {
                "<leader>tr",
                function()
                    require("nvim-tree.api").tree.reload()
                end,
                desc = "Refresh File Explorer",
            },
            {
                "<leader>tf",
                function()
                    require("nvim-tree.api").tree.find_file({ open = true, focus = true })
                end,
                desc = "Find File in Explorer",
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
                desc = "Next todo comment",
            },
            {
                "[t",
                function()
                    require("todo-comments").jump_prev()
                end,
                desc = "Previous todo comment",
            },
            { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
            { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
            { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
            { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
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
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
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
                end, { desc = "Next Git Change" })

                map("n", "[c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gitsigns.nav_hunk("prev")
                    end
                end, { desc = "Prev Git Change" })

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
                map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview Hunk Inline" })

                map("n", "<leader>hb", function()
                    gitsigns.blame_line({ full = true })
                end, { desc = "Blame Line" })

                map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff This File" })

                map("n", "<leader>hD", function()
                    gitsigns.diffthis("~")
                end, { desc = "Diff Against Parent" })

                map("n", "<leader>hQ", function()
                    gitsigns.setqflist("all")
                end, { desc = "Quickfix (All Hunks)" })
                map("n", "<leader>hq", gitsigns.setqflist, { desc = "Quickfix (Current Hunk)" })

                -- Toggles
                map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle Line Blame" })
                map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "Toggle Deleted Hunks" })
                map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle Word Diff" })

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk (Text Object)" })
            end,
        },
    },

    {
        "nvim-telescope/telescope.nvim",
        version = false,
        branch = "0.1.x",
        cmd = "Telescope",
        opts = function()
            local status, telescope = pcall(require, "telescope")
            local troubleStatus, trouble = pcall(require, "trouble.sources.telescope")

            if not status or not troubleStatus then
                return
            end

            telescope.load_extension("fzf")
            telescope.load_extension("yank_history")

            return {
                defaults = {
                    layout_strategy = "flex",
                    mappings = {
                        i = { ["<c-j>"] = trouble.open },
                        n = { ["<c-j>"] = trouble.open },
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            }
        end,
        keys = {
            { "<leader>fb", [[<cmd>Telescope buffers<cr>]], desc = "List Buffers" },
            { "<leader>fp", [[<cmd>Telescope git_files<cr>]], desc = "Find Git Files" },
            { "<leader>ff", [[<cmd>Telescope find_files hidden=true<cr>]], desc = "Find Files" },
            { "<leader>fg", [[<cmd>Telescope live_grep<cr>]], desc = "Live Grep" },
            { "<leader>fq", [[<cmd>Telescope quickfix<cr>]], desc = "Quickfix List" },
            { "<leader>fl", [[<cmd>Telescope localist<cr>]], desc = "Location List" },
            { "<leader>fo", [[<cmd>Telescope vim_options<cr>]], desc = "Vim Options" },
            { "<leader>fr", [[<cmd>Telescope registers<cr>]], desc = "Registers" },
            { "<leader>fc", [[<cmd>Telescope commands<cr>]], desc = "Commands" },
            { "<leader>fm", [[<cmd>Telescope man_pages<cr>]], desc = "Man Pages" },
            { "<leader>fs", [[<cmd>Telescope spell_suggest<cr>]], desc = "Spell Suggestions" },
            { "<leader>fk", [[<cmd>Telescope keymaps<cr>]], desc = "Keymaps" },
            { "<leader>lr", [[<cmd>Telescope lsp_references<cr>]], desc = "LSP References" },
            { "<leader>lds", [[<cmd>Telescope lsp_document_symbols<cr>]], desc = "LSP Document Symbols" },
            { "<leader>lws", [[<cmd>Telescope lsp_workspace_symbols<cr>]], desc = "LSP Workspace Symbols" },
            {
                "<leader>ldws",
                [[<cmd>Telescope lsp_dynamic_workspace_symbols<cr>]],
                desc = "LSP Dynamic Workspace Symbols",
            },
            { "<leader>lca", [[<cmd>Telescope lsp_code_actions<cr>]], desc = "LSP Code Actions" },
            { "<leader>lrca", [[<cmd>Telescope lsp_range_code_actions<cr>]], desc = "LSP Range Code Actions" },
            { "<leader>li", [[<cmd>Telescope lsp_implementations<cr>]], desc = "LSP Implementations" },
            { "<leader>ld", [[<cmd>Telescope lsp_definitions<cr>]], desc = "LSP Definitions" },
        },
        dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
    },

    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        ft = { "markdown" },
        keys = {
            { "<leader>md", [[<cmd>MarkdownPreviewToggle<cr>]], desc = "Toggle Markdown Preview" },
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
            { "<leader>dfo", [[<cmd>DiffviewOpen<cr>]], desc = "Open Diff View" },
            { "<leader>dfc", [[<cmd>DiffviewClose<cr>]], desc = "Close Diff View" },
            { "<leader>dfl", [[<cmd>DiffviewLog<cr>]], desc = "Diff View Log" },
            { "<leader>dfr", [[<cmd>DiffviewRefresh<cr>]], desc = "Refresh Diff View" },
            { "<leader>dfh", [[<cmd>DiffviewFileHistory<cr>]], mode = { "n", "v" }, desc = "File History Diff" },
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

    {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {},
    },

    {
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        -- event = {
        --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
        --   -- refer to `:h file-pattern` for more examples
        --   "BufReadPre path/to/my-vault/*.md",
        --   "BufNewFile path/to/my-vault/*.md",
        -- },
        dependencies = {
            -- Required.
            "nvim-lua/plenary.nvim",

            -- see below for full list of optional dependencies 👇
        },
        opts = {
            workspaces = {
                {
                    name = "Nebula",
                    path = "~/vaults/nebula",
                },
            },

            -- see below for full list of options 👇

            -- Optional, if you keep notes in a specific subdirectory of your vault.
            notes_subdir = "notes",

            -- Optional, set the log level for obsidian.nvim. This is an integer corresponding to one of the log
            -- levels defined by "vim.log.levels.*".
            log_level = vim.log.levels.INFO,

            daily_notes = {
                -- Optional, if you keep daily notes in a separate directory.
                folder = "notes/dailies",
                -- Optional, if you want to change the date format for the ID of daily notes.
                date_format = "%Y-%m-%d",
                -- Optional, if you want to change the date format of the default alias of daily notes.
                alias_format = "%B %-d, %Y",
                -- Optional, default tags to add to each new daily note created.
                default_tags = { "daily-notes" },
                -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
                template = nil,
            },
        },
    },

    {
        "hedyhli/outline.nvim",
        lazy = true,
        cmd = { "Outline", "OutlineOpen" },
        keys = { -- Example mapping to toggle outline
            { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
        },
        opts = {
            -- Your setup opts here
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
            lazygit = { enabled = true },
            terminal = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = true },
            zen = { enabled = true },
        },
    },
}
