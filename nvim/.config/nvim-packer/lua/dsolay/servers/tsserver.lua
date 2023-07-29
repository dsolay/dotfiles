local function setup(lspconfig, on_attach, capabilities)
    lspconfig.tsserver.setup({
        on_attach = on_attach,
        capabilities = capabilities,
    })
end

return setup
