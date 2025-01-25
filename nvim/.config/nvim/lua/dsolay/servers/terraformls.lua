local function setup(lspconfig, on_attach, capabilities)
    lspconfig.terraformls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "terraform", "hcl", "tf" },
    })
end

return setup
