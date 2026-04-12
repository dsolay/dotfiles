local vue_language_server_path = vim.fn.stdpath("data")
    .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

local vue_plugin = {
    name = "@vue/typescript-plugin",
    location = vue_language_server_path,
    languages = { "vue" },
    configNamespace = "typescript",
}

local tsserver_filetypes =
    { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" }

return {
    init_options = {
        plugins = {
            vue_plugin,
        },
    },
    filetypes = tsserver_filetypes,
    on_attach = function(client)
        if vim.bo.filetype == "vue" then
            client.server_capabilities.semanticTokensProvider.full = false
        else
            client.server_capabilities.semanticTokensProvider.full = true
        end
    end,
}
