return {
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
        opts = {
            enable_autocmd = false,
            -- config = {
            --     sql = { __default = "-- %s", __multiline = "/* %s */" },
            -- },
        },
        config = function(_, opts)
            vim.g.skip_ts_context_commentstring_module = true

            require("ts_context_commentstring").setup(opts)
        end,
    },

    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        opts = {
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring.internal").calculate_commentstring()
                        or vim.bo.commentstring
                end,
            },
        },
    },

    {
        "hrsh7th/nvim-cmp",
        version = false,
        event = "InsertEnter",
        config = function()
            local cmp_status, cmp = pcall(require, "cmp")
            local lspkind_status, lspkind = pcall(require, "lspkind")

            if not cmp_status or not lspkind_status then
                return
            end

            local source_mapping = {
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[Lua]",
                path = "[Path]",
                luasnip = "[Snip]",
            }

            cmp.setup({
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol",
                        maxwidth = 50,

                        before = function(entry, vim_item)
                            vim_item.kind = lspkind.presets.default[vim_item.kind]
                            local menu = source_mapping[entry.source.name]
                            vim_item.menu = menu
                            return vim_item
                        end,
                    }),
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                mapping = {
                    ["<C-n>"] = cmp.mapping(
                        cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                        { "i", "c" }
                    ),
                    ["<C-p>"] = cmp.mapping(
                        cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                        { "i", "c" }
                    ),
                    ["<Down>"] = cmp.mapping(
                        cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                        { "i", "c" }
                    ),
                    ["<Up>"] = cmp.mapping(
                        cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                        { "i", "c" }
                    ),
                    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
                    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
                    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                    ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
                    ["<CR>"] = cmp.mapping({
                        i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                        c = cmp.mapping.confirm({ select = false }),
                    }),
                    ["<Tab>"] = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end,
                    ["<S-Tab>"] = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end,
                },
                sources = cmp.config.sources(
                    { { name = "nvim_lsp" }, { name = "luasnip" } },
                    { { name = "buffer" }, { name = "path" } }
                ),
            })

            -- Use buffer source for `/`.
            cmp.setup.cmdline("/", { sources = { { name = "buffer" } } })

            -- Use cmdline & path source for ':'.
            cmp.setup.cmdline(":", { sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }) })
        end,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lua",
            "saadparwaiz1/cmp_luasnip",
            "onsails/lspkind-nvim",
        },
    },

    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        opts = {
            history = true,
            delete_check_events = "TextChanged",
        },
        dependencies = {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
        keys = {
            {
                "<tab>",
                function()
                    return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
                end,
                expr = true,
                silent = true,
                mode = "i",
            },
            {
                "<tab>",
                function()
                    require("luasnip").jump(1)
                end,
                mode = "s",
            },
            {
                "<s-tab>",
                function()
                    require("luasnip").jump(-1)
                end,
                mode = { "i", "s" },
            },
        },
    },

    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } },

    {
        "echasnovski/mini.surround",
        opts = {},
        keys = {
            {
                "sa",
                mode = { "n", "v" },
            },
            "sd",
            "sf",
            "sF",
            "sh",
            "sr",
            "sn",
        },
    },

    {
        "echasnovski/mini.pairs",
        event = "VeryLazy",
        opts = {},
    },

    {
        "jackMort/ChatGPT.nvim",
        cmd = { "ChatGPT", "ChatGPTActAs", "ChatGPTEditWithInstructions", "ChatGPTRun" },
        config = true,
        keys = {
            { "<leader>gpt", "<cmd>ChatGPT<CR>", "ChatGPT" },
            { "<leader>gpti", "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction", mode = { "n", "v" } },
            { "<leader>gram", "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction", mode = { "n", "v" } },
            { "<leader>tran", "<cmd>ChatGPTRun translate<CR>", "Translate", mode = { "n", "v" } },
            { "<leader>gkey", "<cmd>ChatGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
            { "<leader>gdoc", "<cmd>ChatGPTRun docstring<CR>", "Docstring", mode = { "n", "v" } },
            { "<leader>test", "<cmd>ChatGPTRun add_tests<CR>", "Add Tests", mode = { "n", "v" } },
            { "<leader>opt", "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code", mode = { "n", "v" } },
            { "<leader>sum", "<cmd>ChatGPTRun summarize<CR>", "Summarize", mode = { "n", "v" } },
            { "<leader>fix", "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs", mode = { "n", "v" } },
            { "<leader>expl", "<cmd>ChatGPTRun explain_code<CR>", "Explain Code", mode = { "n", "v" } },
            {
                "<leader>grea",
                "<cmd>ChatGPTRun code_readability_analysis<CR>",
                "Code Readability Analysis",
                mode = { "n", "v" },
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
    },

    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        keys = {
            {
                "<leader>tco",
                function()
                    require("copilot.suggestion").toggle_auto_trigger()
                end,
            },
        },
        config = true,
    },

    {
        "piersolenski/wtf.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        opts = {},
        keys = {
            {
                "gw",
                mode = { "n", "x" },
                function()
                    require("wtf").ai()
                end,
                desc = "Debug diagnostic with AI",
            },
            {
                mode = { "n" },
                "gW",
                function()
                    require("wtf").search("duck_duck_go")
                end,
                desc = "Search diagnostic with Google",
            },
        },
    },
}
