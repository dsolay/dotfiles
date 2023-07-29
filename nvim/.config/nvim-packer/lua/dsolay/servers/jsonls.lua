local function setup(lspconfig, on_attach, capabilities)
    lspconfig.jsonls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = { json = { format = { enable = false } } },
    })
end

return setup
