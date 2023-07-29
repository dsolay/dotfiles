local signs = { Error = "✘ ", Warn = " ", Info = " ", Hint = "󰌵 " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, linehl = "", numhl = "" })
end

local function map(mode, l, r, opts)
    opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
    vim.keymap.set(mode, l, r, opts)
end

local severity = vim.diagnostic.severity
map("n", "<space>e", vim.diagnostic.open_float)
map("n", "<space>q", vim.diagnostic.setloclist)

local naviagation_diagnostics = {
    [severity.ERROR] = { "]e", "[e" },
    [severity.WARN] = { "]w", "[w" },
    [severity.INFO] = { "]i", "[i" },
    [severity.HINT] = { "]h", "[h" },
}

for index, value in ipairs(naviagation_diagnostics) do
    for _, key in ipairs(value) do
        map("n", key, function()
            vim.diagnostic.goto_prev({ severity = index, float = false })
        end)
    end
end

-- Config diagnostics
vim.diagnostic.config({ virtual_text = false })

local mason_status, mason = pcall(require, "mason")
local mason_lsp_status, mason_lsp = pcall(require, "mason-lspconfig")
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
local nulll_ls_status, null_ls = pcall(require, "null-ls")
local utils_status, utils = pcall(require, "dsolay.utils")

if
    not lspconfig_status
    or not mason_status
    or not mason_lsp_status
    or not mason_null_ls_status
    or not nulll_ls_status
    or not utils_status
then
    return
end

local lsp_formatting = function(bufnr)
    vim.lsp.buf.format({
        filter = function(client)
            return client.name == "null-ls"
        end,
        bufnr = bufnr,
    })
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local on_attach = function(_, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    map("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
    map("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
    map("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
    map("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
    map("n", "<leader>K", vim.lsp.buf.signature_help, { buffer = bufnr })
    map("n", "<leader>D", vim.lsp.buf.type_definition, { buffer = bufnr })
    map("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
    map("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
    map("n", "<space>f", function()
        lsp_formatting(bufnr)
    end, { buffer = bufnr })
    map("n", "<space>ca", vim.lsp.buf.code_action, { buffer = bufnr })
end

mason.setup()
mason_lsp.setup({
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
})
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
    handlers= {
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
    }
})

local serversPath = vim.fn.stdpath("config") .. "/lua/dsolay/servers/"
mason_lsp.setup_handlers({
    function(server_name)
        local path = serversPath .. server_name .. ".lua"
        if utils.file_exists(path) then
            require("dsolay.servers." .. server_name)(lspconfig, on_attach, capabilities)
        else
            lspconfig[server_name].setup({ capabilities = capabilities, on_attach = on_attach })
        end
    end,
})

null_ls.setup()
