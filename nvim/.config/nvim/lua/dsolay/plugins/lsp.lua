local utils_status, utils = pcall(require, "dsolay.utils")

if not utils_status then
    return
end

return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
            { "folke/neodev.nvim", opts = {} },
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local signs = { Error = "✘ ", Warn = " ", Info = " ", Hint = "󰌵 " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, linehl = "", numhl = "" })
            end

            vim.diagnostic.config({ virtual_text = false })
        end,
        keys = {
            { "<space>e", vim.diagnostic.open_float },
            { "<space>q", vim.diagnostic.setloclist },
            {
                "]e",
                function()
                    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR, float = false })
                end,
            },
            {
                "[e",
                function()
                    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR, float = false })
                end,
            },
            {
                "]w",
                function()
                    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN, float = false })
                end,
            },
            {
                "[w",
                function()
                    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN, float = false })
                end,
            },
            {
                "]i",
                function()
                    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.INFO, float = false })
                end,
            },
            {
                "[i",
                function()
                    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.INFO, float = false })
                end,
            },
            {
                "]h",
                function()
                    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.HINT, float = false })
                end,
            },
            {
                "[h",
                function()
                    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.HINT, float = false })
                end,
            },
        },
    },

    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        keys = { { "<leader>cm", "<cmd>Mason<cr>" } },
        build = ":MasonUpdate",
        config = true,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        opts = function()
            local lspconfig_status, lspconfig = pcall(require, "lspconfig")

            if not lspconfig_status then
                return
            end

            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local serversPath = vim.fn.stdpath("config") .. "/lua/dsolay/servers/"

            local on_attach = function(_, bufnr)
                -- Enable completion triggered by <c-x><c-o>
                -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
                vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

                -- Mappings.
                local opts = { buffer = bufnr }
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                vim.keymap.set("n", "<leader>K", vim.lsp.buf.signature_help, opts)
                vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "<space>f", function()
                    vim.lsp.buf.format({
                        filter = function(client)
                            return client.name == "null-ls"
                        end,
                        bufnr = bufnr,
                    })
                end, opts)
                vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
            end

            return {
                ensure_installed = {
                    "lua_ls",
                    "intelephense",
                    "omnisharp",
                    "tsserver",
                    "volar",
                    "jsonls",
                    "eslint",
                    "stylelint_lsp",
                    "dockerls",
                },
                automatic_setup = true,
                handlers = {
                    function(server_name)
                        local path = serversPath .. server_name .. ".lua"
                        if utils.file_exists(path) then
                            require("dsolay.servers." .. server_name)(lspconfig, on_attach, capabilities)
                        else
                            lspconfig[server_name].setup({ capabilities = capabilities, on_attach = on_attach })
                        end
                    end,
                },
            }
        end,
    },

    {
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            { "jose-elias-alvarez/null-ls.nvim" },
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
                    "csharpier",
                    "markdownlint",
                    "phpstan",
                    "phpcsfixer",
                    "shellcheck",
                    "fixjson",
                    "prettier",
                },
                automatic_setup = true,
                handlers = {
                    function(source_name, methods)
                        require("mason-null-ls.automatic_setup")(source_name, methods)
                    end,
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
                },
            })

            null_ls.setup()
        end,
    },
}
