local function setup(lspconfig, on_attach, capabilities)
    lspconfig.volar.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = {
            "typescript",
            "javascript",
            "javascriptreact",
            "typescriptreact",
            "vue",
            "json",
        },
        init_options = {
            typescript = { tsdk = "node_modules/typescript/lib" },
        },
        settings = {
            css = { validate = false },
            less = { validate = false },
            scss = { validate = false },
        },
    })
end

return setup
