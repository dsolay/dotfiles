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

            if not cmp_status then
                return
            end

            cmp.setup({
                window = {
                    completion = {
                        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                        col_offset = -3,
                        side_padding = 0,
                    },
                },
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        local kind =
                            require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
                        local strings = vim.split(kind.kind, "%s", { trimempty = true })
                        kind.kind = " " .. (strings[1] or "") .. " "
                        kind.menu = "    (" .. (strings[2] or "") .. ")"

                        return kind
                    end,
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
        "yetone/avante.nvim",
        event = "VeryLazy",
        lazy = false,
        version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
        opts = {
            provider = "deepseek",
            vendors = {
                deepseek = {
                    __inherited_from = "openai",
                    api_key_name = "DEEPSEEK_API_KEY",
                    endpoint = "https://api.deepseek.com",
                    model = "deepseek-chat",
                    temperature = 0,
                    max_tokens = 8192,
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
                    bullet = { left_pad = 2, right_pad = 1 },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },
}
