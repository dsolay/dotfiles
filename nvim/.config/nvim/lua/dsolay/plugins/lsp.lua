local lsp_config = require("dsolay.config.lsp")

return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            vim.diagnostic.config({
                virtual_text = false,
                signs = {
                    text = lsp_config.DIAGNOSTIC_ICONS,
                    linehl = {},
                    numhl = {},
                },
            })
        end,
        keys = {
            { "<space>e", vim.diagnostic.open_float, desc = "Open Diagnostic" },
            { "<space>q", vim.diagnostic.setloclist, desc = "Set Loclist" },
            {
                "]d",
                function()
                    vim.diagnostic.jump({ count = 1, severity = nil, float = false })
                end,
                desc = "Next Diagnostic",
            },
            {
                "[d",
                function()
                    vim.diagnostic.jump({ count = -1, severity = nil, float = false })
                end,
                desc = "Prev Diagnostic",
            },
            {
                "]e",
                function()
                    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = false })
                end,
                desc = "Next Error",
            },
            {
                "[e",
                function()
                    vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = false })
                end,
                desc = "Prev Error",
            },
            {
                "]w",
                function()
                    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN, float = false })
                end,
                desc = "Next Warning",
            },
            {
                "[w",
                function()
                    vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN, float = false })
                end,
                desc = "Prev Warning",
            },
        },
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            opts = {},
            cmd = "Mason",
            keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
            build = ":MasonUpdate",
        },
        opts = {},
    },

    {
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "nvimtools/none-ls.nvim",
        },
        config = function()
            local nulll_ls_status, null_ls = pcall(require, "null-ls")
            local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")

            if not nulll_ls_status or not mason_null_ls_status then
                return
            end

            mason_null_ls.setup({
                ensure_installed = {
                    "stylua",
                    "hadolint",
                    "markdownlint",
                    "phpstan",
                    "phpcsfixer",
                    "shellcheck",
                    "fixjson",
                    "prettier",
                },
                automatic_installation = true,
                handlers = {
                    prettier = function()
                        null_ls.register(null_ls.builtins.formatting.prettier.with({
                            prefer_local = "node_modules/.bin",
                        }))
                    end,
                    phpcsfixer = function()
                        null_ls.register(null_ls.builtins.formatting.phpcsfixer.with({
                            prefer_local = "vendor/bin",
                        }))
                    end,
                    phpstan = function()
                        null_ls.register(null_ls.builtins.diagnostics.phpstan.with({
                            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
                            prefer_local = "vendor/bin",
                            extra_args = { "--memory-limit=2G" },
                            timeout = 15000,
                        }))
                    end,
                    dotenv_linter = function()
                        null_ls.register(null_ls.builtins.diagnostics.dotenv_linter.with({
                            filetypes = { "env" },
                            extra_args = { "check" },
                            prepend_extra_args = true,
                        }))
                    end,
                },
            })

            null_ls.setup({ debug = true })
        end,
    },

    {
        "schrieveslaach/sonarlint.nvim",
        enabled = true,
        url = "https://gitlab.com/schrieveslaach/sonarlint.nvim",
        event = "BufReadPost",
        config = function()
            require("sonarlint").setup({
                server = {
                    cmd = {
                        "sonarlint-language-server",
                        -- Ensure that sonarlint-language-server uses stdio channel
                        "-stdio",
                        "-analyzers",
                        vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarhtml.jar"),
                        vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar"),
                        vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarphp.jar"),
                        vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
                        vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
                        vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
                    },
                    settings = {
                        sonarlint = {
                            rules = {
                                ["typescript:S6578"] = { level = "off" },
                                ["typescript:S6606"] = { level = "off" },
                            },
                        },
                    },
                },
                filetypes = {
                    "php",
                    "html",
                    "typescriptreact",
                    "javascriptreact",
                    "typescript",
                    "javascript",
                    "python",
                },
            })
        end,
    },
}
