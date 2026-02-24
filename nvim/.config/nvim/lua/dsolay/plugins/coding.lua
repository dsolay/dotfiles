-- ============================================================================
-- Completion Plugin Configuration
-- ============================================================================
-- Table defining buffers/filetypes where completion should not be loaded
-- This is used by the blink.cmp `cond` function to control lazy loading
-- and by the `enabled` function to disable at runtime
--
-- Filetypes:
--   - NvimTree: File explorer (main target)
--   - help: Vim help buffers (:h command)
--   - fugitive: Git plugin buffers (git status, commits, etc)
--   - qf: Quickfix/Location list windows
--   - dap-repl: Debugger REPL
-- Buftypes:
--   - nofile: Temporary/virtual buffers (scratch, etc)
--   - terminal: Terminal buffers
--   - prompt: Input prompt buffers
--
local completion_excluded = {
    filetypes = {
        "NvimTree",  -- nvim-tree file explorer
        "help",      -- Vim help buffers
        "fugitive",  -- Git buffers (vim-fugitive)
        "qf",        -- Quickfix windows
        "dap-repl",  -- Debugger REPL
    },
    buftypes = {
        "nofile",    -- Temporary/virtual buffers
        "terminal",  -- Terminal buffers
        "prompt",    -- Prompt/input buffers
    },
}

-- Helper function to check if completion should be enabled
-- Returns false if current buffer matches exclusion criteria
-- This is used by:
--   1. blink.cmp's `cond` to decide whether to load the plugin (lazy loading)
--   2. blink.cmp's `enabled` to disable at runtime (dynamic disabling)
local function should_enable_completion()
    if vim.tbl_contains(completion_excluded.buftypes, vim.bo.buftype) then
        return false
    end
    return not vim.tbl_contains(completion_excluded.filetypes, vim.bo.filetype)
end

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
        "saghen/blink.cmp",
        -- optional: provides snippets for the snippet source
        dependencies = { "rafamadriz/friendly-snippets" },

        -- use a release tag to download pre-built binaries
        version = "1.*",

        -- Only load this plugin if completion should be enabled in the current buffer
        -- This prevents loading blink.cmp entirely in excluded buffers (lazy loading optimization)
        cond = should_enable_completion,

        opts = {
            -- Runtime safety: Disable completion dynamically if the plugin loads
            -- This allows enabling/disabling completion when switching between buffers
            enabled = should_enable_completion,

            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = { preset = "enter" },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            -- (Default) Only show the documentation popup when manually triggered
            completion = { documentation = { auto_show = false } },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "prefer_rust_with_warning" },
        },
        opts_extend = { "sources.default" },
    },

    -- {
    --     "hrsh7th/nvim-cmp",
    --     version = false,
    --     event = "InsertEnter",
    --     config = function()
    --         local cmp_status, cmp = pcall(require, "cmp")
    --
    --         if not cmp_status then
    --             return
    --         end
    --
    --         cmp.event:on("menu_closed", function()
    --             local bufnr = vim.api.nvim_get_current_buf()
    --             vim.b[bufnr]._vue_ts_cached_is_in_start_tag = nil
    --         end)
    --
    --         cmp.setup({
    --             window = {
    --                 completion = {
    --                     winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
    --                     col_offset = -3,
    --                     side_padding = 0,
    --                 },
    --             },
    --             formatting = {
    --                 fields = { "kind", "abbr", "menu" },
    --                 format = function(entry, vim_item)
    --                     local kind =
    --                         require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
    --                     local strings = vim.split(kind.kind, "%s", { trimempty = true })
    --                     kind.kind = " " .. (strings[1] or "") .. " "
    --                     kind.menu = "    (" .. (strings[2] or "") .. ")"
    --
    --                     return kind
    --                 end,
    --             },
    --             snippet = {
    --                 expand = function(args)
    --                     require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
    --                 end,
    --             },
    --             mapping = cmp.mapping.preset.insert({
    --                 ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    --                 ["<C-f>"] = cmp.mapping.scroll_docs(4),
    --                 ["<C-Space>"] = cmp.mapping.complete(),
    --                 ["<C-e>"] = cmp.mapping.abort(),
    --                 ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    --             }),
    --             sources = cmp.config.sources({
    --                 {
    --                     name = "nvim_lsp",
    --                     entry_filter = function(entry, ctx)
    --                         -- Use a buffer-local variable to cache the result of the Treesitter check
    --                         local bufnr = ctx.bufnr
    --                         local cached_is_in_start_tag = vim.b[bufnr]._vue_ts_cached_is_in_start_tag
    --                         if cached_is_in_start_tag == nil then
    --                             vim.b[bufnr]._vue_ts_cached_is_in_start_tag = is_in_start_tag()
    --                         end
    --
    --                         -- If not in start tag, return true
    --                         if vim.b[bufnr]._vue_ts_cached_is_in_start_tag == false then
    --                             return true
    --                         end
    --
    --                         -- rest of the code
    --                         if ctx.filetype ~= "vue" then
    --                             return true
    --                         end
    --
    --                         local cursor_before_line = ctx.cursor_before_line
    --                         -- For events
    --                         if cursor_before_line:sub(-1) == "@" then
    --                             return entry.completion_item.label:match("^@")
    --                         -- For props also exclude events with `:on-` prefix
    --                         elseif cursor_before_line:sub(-1) == ":" then
    --                             return entry.completion_item.label:match("^:")
    --                                 and not entry.completion_item.label:match("^:on%-")
    --                         else
    --                             return true
    --                         end
    --                     end,
    --                 },
    --                 { name = "luasnip" },
    --             }, { { name = "buffer" }, { name = "path" } }),
    --         })
    --
    --         -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    --         cmp.setup.cmdline({ "/", "?" }, {
    --             mapping = cmp.mapping.preset.cmdline(),
    --             sources = {
    --                 { name = "buffer" },
    --             },
    --         })
    --
    --         -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    --         cmp.setup.cmdline(":", {
    --             mapping = cmp.mapping.preset.cmdline(),
    --             sources = cmp.config.sources({
    --                 { name = "path" },
    --             }, {
    --                 { name = "cmdline" },
    --             }),
    --             matching = { disallow_symbol_nonprefix_matching = false },
    --         })
    --     end,
    --     dependencies = {
    --         "hrsh7th/cmp-nvim-lsp",
    --         "hrsh7th/cmp-buffer",
    --         "hrsh7th/cmp-path",
    --         "hrsh7th/cmp-cmdline",
    --         "hrsh7th/cmp-nvim-lua",
    --         "saadparwaiz1/cmp_luasnip",
    --         "onsails/lspkind-nvim",
    --     },
    -- },

    -- {
    --     "L3MON4D3/LuaSnip",
    --     build = "make install_jsregexp",
    --     opts = {
    --         history = true,
    --         delete_check_events = "TextChanged",
    --     },
    --     dependencies = {
    --         "rafamadriz/friendly-snippets",
    --         config = function()
    --             local luasnip = require("luasnip")
    --
    --             luasnip.filetype_extend("javascriptreact", { "html" })
    --             luasnip.filetype_extend("typescriptreact", { "html" })
    --
    --             require("luasnip.loaders.from_vscode").lazy_load()
    --         end,
    --     },
    -- },

    -- { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } },

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
            providers = {
                deepseek = {
                    __inherited_from = "openai",
                    endpoint = "https://api.deepseek.com",
                    model = "deepseek-chat",
                    timeout = 30000,
                    extra_request_body = {
                        temperature = 0,
                        max_tokens = 8192,
                    },
                },
            },
            behaviour = {
                auto_suggestions = false,
                auto_set_highlight_group = true,
                auto_set_keymaps = true,
                auto_apply_diff_after_generation = false,
                support_paste_from_clipboard = false,
                minimize_diff = true,
                auto_approve_tool_permissions = { "bash", "replace_in_file" },
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
                    bullet = {
                        left_pad = 0,
                        right_pad = 1,
                    },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },

    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
}
