local function setup(lspconfig, on_attach, capabilities)
    lspconfig.stylelint_lsp.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = {
            "css",
            "less",
            "scss",
            "sugarss",
            "vue",
            "wxss",
            "javascriptreact",
            "typescriptreact",
        },
        settings = {
            stylelintplus = {
                validateOnSave = true,
                validateOnType = false,
            },
        },
    })
end

return setup
