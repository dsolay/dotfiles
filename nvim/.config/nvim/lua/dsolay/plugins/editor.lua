return {
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("dsolay.plugins.extras.alpha")
        end,
    },

    { "nvim-tree/nvim-web-devicons" },

    {
        "mg979/vim-visual-multi",
        branch = "master",
    },

    { "tpope/vim-unimpaired" },

    { "tpope/vim-dotenv" },
    -- { "ellisonleao/dotenv.nvim", config = true },

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
        cmd = { "DBUI", "DBUIToggle" },
        config = function()
            local helpers = require("dsolay.plugins.extras.dadbod-ui")
            vim.g.db_ui_table_helpers = helpers

            vim.g.db_ui_auto_execute_table_helpers = 1
            vim.g.db_ui_force_echo_notifications = 1
            vim.g.db_ui_win_position = "right"

            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_show_database_icon = 1
        end,
        keys = { { "<leader>db", "<cmd>DBUIToggle<cr>" } },
        dependencies = { { "tpope/vim-dadbod", cmd = "DB" } },
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
                "<leader>tt",
                function()
                    require("nvim-tree.api").tree.toggle()
                end,
            },
            {
                "<leader>tr",
                function()
                    require("nvim-tree.api").tree.reload()
                end,
            },
            {
                "<leader>tf",
                function()
                    require("nvim-tree.api").tree.find_file({ open = true, focus = true })
                end,
            },
        },
    },

    {
        "numtostr/FTerm.nvim",
        keys = {
            {
                "<A-d>",
                function()
                    require("FTerm").toggle()
                end,
                mode = { "n", "t" },
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
        "kdav5758/TrueZen.nvim",
        opts = {
            integrations = {
                tmux = true,
                twilight = true,
            },
        },
        keys = {
            { "<leader>zn", "<cmd>TZNarrow<cr>", mode = { "n", "v" } },
            { "<leader>zf", "<cmd>TZFocus<cr>" },
            { "<leader>zm", "<cmd>TZMinimalist<cr>" },
            { "<leader>za", "<cmd>TZAtaraxis<cr>" },
        },
        cmd = {
            "TZMinimalist",
            "TZFocus",
            "TZAtaraxis",
            "TZBottom",
            "TZTop",
            "TZLeft",
        },
    },

    {
        "kdheepak/lazygit.nvim",
        config = function()
            vim.g.lazygit_floating_window_winblend = 1
            vim.g.lazygit_floating_window_use_plenary = 1
        end,
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>" },
        },
        cmd = "LazyGit",
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
                end)

                map("n", "[c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gitsigns.nav_hunk("prev")
                    end
                end)

                -- Actions
                map("n", "<leader>hs", gitsigns.stage_hunk)
                map("n", "<leader>hr", gitsigns.reset_hunk)

                map("v", "<leader>hs", function()
                    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end)

                map("v", "<leader>hr", function()
                    gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end)

                map("n", "<leader>hS", gitsigns.stage_buffer)
                map("n", "<leader>hR", gitsigns.reset_buffer)
                map("n", "<leader>hp", gitsigns.preview_hunk)
                map("n", "<leader>hi", gitsigns.preview_hunk_inline)

                map("n", "<leader>hb", function()
                    gitsigns.blame_line({ full = true })
                end)

                map("n", "<leader>hd", gitsigns.diffthis)

                map("n", "<leader>hD", function()
                    gitsigns.diffthis("~")
                end)

                map("n", "<leader>hQ", function()
                    gitsigns.setqflist("all")
                end)
                map("n", "<leader>hq", gitsigns.setqflist)

                -- Toggles
                map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
                map("n", "<leader>td", gitsigns.toggle_deleted)
                map("n", "<leader>tw", gitsigns.toggle_word_diff)

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
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
            { "<leader>fb", [[<cmd>Telescope buffers<cr>]] },
            { "<leader>fp", [[<cmd>Telescope git_files<cr>]] },
            { "<leader>ff", [[<cmd>Telescope find_files hidden=true<cr>]] },
            { "<leader>fg", [[<cmd>Telescope live_grep<cr>]] },
            { "<leader>fq", [[<cmd>Telescope quickfix<cr>]] },
            { "<leader>fl", [[<cmd>Telescope localist<cr>]] },
            { "<leader>fo", [[<cmd>Telescope vim_options<cr>]] },
            { "<leader>fr", [[<cmd>Telescope registers<cr>]] },
            { "<leader>fc", [[<cmd>Telescope commands<cr>]] },
            { "<leader>fm", [[<cmd>Telescope man_pages<cr>]] },
            { "<leader>fs", [[<cmd>Telescope spell_suggest<cr>]] },
            { "<leader>fk", [[<cmd>Telescope keymaps<cr>]] },
            { "<leader>lr", [[<cmd>Telescope lsp_references<cr>]] },
            { "<leader>lds", [[<cmd>Telescope lsp_document_symbols<cr>]] },
            { "<leader>lws", [[<cmd>Telescope lsp_workspace_symbols<cr>]] },
            { "<leader>ldws", [[<cmd>Telescope lsp_dynamic_workspace_symbols<cr>]] },
            { "<leader>lca", [[<cmd>Telescope lsp_code_actions<cr>]] },
            { "<leader>lrca", [[<cmd>Telescope lsp_range_code_actions<cr>]] },
            { "<leader>li", [[<cmd>Telescope lsp_implementations<cr>]] },
            { "<leader>ld", [[<cmd>Telescope lsp_definitions<cr>]] },
        },
        dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
    },

    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        ft = { "markdown" },
        keys = {
            { "<leader>md", [[<cmd>MarkdownPreviewToggle<cr>]] },
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
            { "<leader>dfo", [[<cmd>DiffviewOpen<cr>]] },
            { "<leader>dfc", [[<cmd>DiffviewClose<cr>]] },
            { "<leader>dfl", [[<cmd>DiffviewLog<cr>]] },
            { "<leader>dfl", [[<cmd>DiffviewRefresh<cr>]] },
            { "<leader>dfh", [[<cmd>DiffviewFileHistory<cr>]], mode = { "n", "v" } },
        },
        config = true,
    },

    {
        "harrisoncramer/gitlab.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "stevearc/dressing.nvim", -- Recommended but not required. Better UI for pickers.
            enabled = true,
        },
        event = "BufWinEnter",
        keys = {
            {
                "<leader>glr",
                function()
                    require("gitlab").review()
                end,
            },
            {
                "<leader>gls",
                function()
                    require("gitlab").summary()
                end,
            },
            {
                "<leader>glA",
                function()
                    require("gitlab").approve()
                end,
            },
            {
                "<leader>glR",
                function()
                    require("gitlab").revoke()
                end,
            },
            {
                "<leader>glc",
                function()
                    require("gitlab").create_comment()
                end,
            },
            {
                "<leader>gln",
                function()
                    require("gitlab").create_note()
                end,
            },
            {
                "<leader>gld",
                function()
                    require("gitlab").toggle_discussions()
                end,
            },
            {
                "<leader>glaa",
                function()
                    require("gitlab").add_assignee()
                end,
            },
            {
                "<leader>glad",
                function()
                    require("gitlab").delete_assignee()
                end,
            },
            {
                "<leader>glra",
                function()
                    require("gitlab").add_reviewer()
                end,
            },
            {
                "<leader>glrd",
                function()
                    require("gitlab").delete_reviewer()
                end,
            },
            {
                "<leader>glp",
                function()
                    require("gitlab").pipeline()
                end,
            },
            {
                "<leader>glo",
                function()
                    require("gitlab").open_in_browser()
                end,
            },
        },
        build = function()
            require("gitlab.server").build(true)
        end, -- Builds the Go binary
        opts = {
            reviewer = "diffview",
        },
    },

    {
        "ray-x/web-tools.nvim",
        cmd = { "BrowserSync", "BrowserOpen", "BrowserPreview", "HurlRun" },
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
        "pwntester/octo.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        config = true,
    },

    {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {},
    },

    {
        "echasnovski/mini.animate",
        version = "*",
        opts = {
            open = {
                enable = false,
            },
            close = {
                enable = false,
            },
        },
        config = true,
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
                    name = "personal",
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
}
