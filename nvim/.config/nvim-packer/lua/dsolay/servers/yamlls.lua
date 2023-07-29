local function setup(lspconfig, _, capabilities)
    lspconfig.yamlls.setup({
        capabilities = capabilities,
    })
end

return setup
