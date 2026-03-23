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
        "NvimTree", -- nvim-tree file explorer
        "help", -- Vim help buffers
        "fugitive", -- Git buffers (vim-fugitive)
        "qf", -- Quickfix windows
        "dap-repl", -- Debugger REPL
    },
    buftypes = {
        "nofile", -- Temporary/virtual buffers
        "terminal", -- Terminal buffers
        "prompt", -- Prompt/input buffers
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
        "folke/ts-comments.nvim",
        opts = {},
        event = "VeryLazy",
        enabled = vim.fn.has("nvim-0.10.0") == 1,
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
                per_filetype = {
                    sql = { "snippets", "dadbod", "buffer" },
                    lua = { inherit_defaults = true, "lazydev" },
                },
                providers = {
                    dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
                    },
                },
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

    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "snacks.nvim", words = { "Snacks" } },
                { path = "lazy.nvim", words = { "LazyVim" } },
            },
        },
    },

    -- better yank/paste
    {
        "gbprod/yanky.nvim",
        opts = {},
        config = function(_, opts)
            require("yanky").setup(opts)
        end,
        keys = {
            {
                "<leader>p",
                function()
                    require("telescope").extensions.yank_history.yank_history({})
                end,
                mode = { "n", "x" },
                desc = "Open Yank History",
            },
            { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank Text" },
            { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put Text After Cursor" },
            { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Cursor" },
            { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put Text After Selection" },
            { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Selection" },
            { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
            { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
            { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
            { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
            { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
            { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
            { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and Indent Right" },
            { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and Indent Left" },
            { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put Before and Indent Right" },
            { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put Before and Indent Left" },
            { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put After Applying a Filter" },
            { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put Before Applying a Filter" },
        },
    },
}
