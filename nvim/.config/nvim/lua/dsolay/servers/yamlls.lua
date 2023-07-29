local function setup(lspconfig, _, capabilities)
    lspconfig.yamlls.setup({
        capabilities = capabilities,
        settings = {
            yaml = {
                schemas = {
                    ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                    ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "/docker-compose.*.yml",
                },
            },
        },
    })
end

return setup
