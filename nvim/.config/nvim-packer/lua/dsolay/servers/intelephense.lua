local function setup(lspconfig, on_attach, capabilities)
    lspconfig.intelephense.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            intelephense = {
                diagnostics = {
                    typeErrors = false,
                    undefinedMethods = false,
                    undefinedTypes = false,
                },
                format = { enable = false },
                files = {
                    exclude = {
                        "**/.git/**",
                        "**/.svn/**",
                        "**/.hg/**",
                        "**/CVS/**",
                        "**/.DS_Store/**",
                        "**/node_modules/**",
                        "**/bower_components/**",
                        "**/vendor/**/{Test,test,Tests,tests}/**/*Test.php",
                    },
                },
            },
        },
    })
end

return setup
