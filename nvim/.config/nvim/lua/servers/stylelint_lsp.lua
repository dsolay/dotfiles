return {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
    end,
    filetypes = {
        'css',
        'less',
        'scss',
        'sugarss',
        'vue',
        'wxss',
        'javascriptreact',
        'typescriptreact',
    },
    settings = {
        stylelintplus = {
            autoFixOnFormat = false,
            autoFixOnSave = false,
            validateOnSave = true,
            validateOnType = false,
        },
    },
}

