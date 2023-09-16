return {
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("dsolay.plugins.extras.alpha")
        end,
    },

    {
        "aPeoplesCalendar/apc.nvim",
        dependencies = {
            { "rcarriga/nvim-notify", opts = {
                background_colour = "#000000",
            } },
        },
        cmd = "APeoplesCalendar",
        opts = {
            auto_teaser_filetypes = {},
        },
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
        opts = {
            use_treesitter = true,
            show_first_indent_level = false,
            show_trailing_blankline_indent = false,
            filetype_exclude = {
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
            },
            show_current_context = true,
            show_current_context_start = true,
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
                "<C-b>",
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
        cmd = { "TodoTrouble", "TodoTelescope" },
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
            { "<leader>tod", "<cmd>TroubleToggle document_diagnostics<cr>" },
            { "<leader>tow", "<cmd>TroubleToggle workspace_diagnostics<cr>" },
            { "<leader>tol", "<cmd>TroubleToggle loclist<cr>" },
            { "<leader>toq", "<cmd>TroubleToggle quickfix<cr>" },
            { "<leader>tgr", "<cmd>TroubleToggle lsp_references<cr>" },
            { "<leader>tgd", "<cmd>TroubleToggle lsp_definitions<cr>" },
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
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]c", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true })

                map("n", "[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true })

                -- Actions
                map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>")
                map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>")
                map("n", "<leader>gS", gs.stage_buffer)
                map("n", "<leader>gu", gs.undo_stage_hunk)
                map("n", "<leader>gR", gs.reset_buffer)
                map("n", "<leader>gp", gs.preview_hunk)
                map("n", "<leader>gb", function()
                    gs.blame_line({ full = true })
                end)
                map("n", "<leader>gtb", gs.toggle_current_line_blame)
                map("n", "<leader>gd", gs.diffthis)
                map("n", "<leader>gD", function()
                    gs.diffthis("~")
                end)
                map("n", "<leader>gtd", gs.toggle_deleted)

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
            end,
        },
    },

    {
        "kkoomen/vim-doge",
        config = function()
            vim.g.doge_enable_mappings = 0
        end,
        cmd = { "DogeGenerate" },
        keys = {
            { "<leader>doc", "<cmd>DogeGenerate<cr>" },
        },
        build = ":call doge#install()",
    },

    {
        "nvim-telescope/telescope.nvim",
        version = false,
        cmd = "Telescope",
        opts = function()
            local status, telescope = pcall(require, "telescope")
            local troubleStatus, trouble = pcall(require, "trouble.providers.telescope")

            if not status or not troubleStatus then
                return
            end

            telescope.load_extension("fzf")

            return {
                defaults = {
                    layout_strategy = "flex",
                    mappings = {
                        i = { ["<c-j>"] = trouble.open_with_trouble },
                        n = { ["<c-j>"] = trouble.open_with_trouble },
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
}
