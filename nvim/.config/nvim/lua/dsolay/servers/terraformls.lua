local function setup(lspconfig, on_attach, capabilities)
    lspconfig.terraformls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "terraform", "terraform-vars", "hcl", "tf", "tfvars" },
    })
end

return setup
