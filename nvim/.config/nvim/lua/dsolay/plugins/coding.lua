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
                Supermaven = "[Supermaven]",
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
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp", priority = 1 },
                    { name = "luasnip", priority = 3 },
                    { name = "path", priority = 5 },
                }, { { name = "buffer" } }),
            })

            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
                matching = { disallow_symbol_nonprefix_matching = false },
            })
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
        version = "v2.*",
        opts = {
            history = true,
            delete_check_events = "TextChanged",
        },
        dependencies = {
            "rafamadriz/friendly-snippets",
            config = function()
                local luasnip = require("luasnip")

                luasnip.filetype_extend("javascriptreact", { "html" })
                luasnip.filetype_extend("typescriptreact", { "html" })

                require("luasnip.loaders.from_vscode").lazy_load()
            end,
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
        event = "VimEnter",
        cmd = { "ChatGPT", "ChatGPTActAs", "ChatGPTEditWithInstructions", "ChatGPTRun" },
        enabled = false,
        keys = {
            { "<leader>cg", "<cmd>ChatGPT<CR>", "ChatGPT" },
            {
                "<leader>cei",
                "<cmd>ChatGPTEditWithInstruction<CR>",
                "Edit with instruction",
                mode = { "n", "v" },
            },
            {
                "<leader>cgc",
                "<cmd>ChatGPTRun grammar_correction<CR>",
                "Grammar Correction",
                mode = { "n", "v" },
            },
            {
                "<leader>ct",
                "<cmd>ChatGPTRun translate<CR>",
                "Translate",
                mode = { "n", "v" },
            },
            {
                "<leader>ck",
                "<cmd>ChatGPTRun keywords<CR>",
                "Keywords",
                mode = { "n", "v" },
            },
            {
                "<leader>cd",
                "<cmd>ChatGPTRun docstring<CR>",
                "Docstring",
                mode = { "n", "v" },
            },
            {
                "<leader>ctt",
                "<cmd>ChatGPTRun add_tests<CR>",
                "Add Tests",
                mode = { "n", "v" },
            },
            {
                "<leader>co",
                "<cmd>ChatGPTRun optimize_code<CR>",
                "Optimize Code",
                mode = { "n", "v" },
            },
            {
                "<leader>csm",
                "<cmd>ChatGPTRun summarize<CR>",
                "Summarize",
                mode = { "n", "v" },
            },
            {
                "<leader>cf",
                "<cmd>ChatGPTRun fix_bugs<CR>",
                "Fix Bugs",
                mode = { "n", "v" },
            },
            {
                "<leader>ce",
                "<cmd>ChatGPTRun explain_code<CR>",
                "Explain Code",
                mode = { "n", "v" },
            },
            {
                "<leader>cra",
                "<cmd>ChatGPTRun code_readability_analysis<CR>",
                "Code Readability Analysis",
                mode = { "n", "v" },
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "folke/trouble.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            local function get_api_key()
                local handle = io.popen("pass show openai.com/roman | head -n 1 | tr -d '\n'")
                local api_key = handle:read("*a")
                handle:close()
                return api_key:gsub("%s+", "") -- trim any extra whitespace
            end

            local api_key = get_api_key()

            require("chatgpt").setup({
                api_key_cmd = "echo " .. api_key,
                openai_params = {
                    model = "gpt-4o-mini",
                    frequency_penalty = 0,
                    presence_penalty = 0,
                    max_tokens = 4096,
                    temperature = 0.2,
                    top_p = 0.1,
                    n = 1,
                },
            })
        end,
    },

    {
        "github/copilot.vim",
        cmd = "Copilot",
        event = "InsertEnter",
        enabled = false,
        keys = {
            {
                "<C-x>",
                'copilot#Accept("\\<CR>")',
                mode = "i",
                expr = true,
                replace_keycodes = false,
            },
        },
        config = function()
            vim.g.copilot_no_tab_map = true
            vim.g.copilot_workspace_folders = { "~/workspace" }
        end,
    },

    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        enabled = false,
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
        enabled = false,
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

    {
        "supermaven-inc/supermaven-nvim",
        config = function()
            require("supermaven-nvim").setup({})
        end,
        -- opts = {
        --     disable_inline_completion = true, -- disables inline completion for use with cmp
        --     disable_keymaps = true, -- disables built in keymaps for more manual control
        -- },
    },

    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        lazy = false,
        version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
        opts = {
            provider = "deepseek",
            vendors = {
                deepseek = {
                    __inherited_from = "openai",
                    api_key_name = {"pass", "show", "deepseek.com/api-keys/roman-pc"},
                    endpoint = "https://api.deepseek.com",
                    model = "deepseek-chat",
                },
            },
            behaviour = {
                auto_suggestions = false,
                auto_set_highlight_group = true,
                auto_set_keymaps = true,
                auto_apply_diff_after_generation = false,
                support_paste_from_clipboard = false,
                minimize_diff = true,
            },
        },
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make",
        dependencies = {
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "echasnovski/mini.pick", -- for file_selector provider mini.pick
            "ibhagwan/fzf-lua", -- for file_selector provider fzf
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },
}
