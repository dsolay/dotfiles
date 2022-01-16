return {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
    end,
    settings = {
        css = {validate = false},
        less = {validate = false},
        scss = {validate = false},
        volar = {tsPlugin = true, icon = {preview = true, finder = true}},
    },
}
