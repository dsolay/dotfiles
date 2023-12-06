local utils_status, utils = pcall(require, "dsolay.utils")

if not utils_status then
    return
end

local function setup(lspconfig, on_attach, capabilities)
    local defaultCapabilities = {
        textDocument = {
            completion = { completionItem = { snippetSupport = true } },
        },
    }

    lspconfig.cssls.setup({
        on_attach = on_attach,
        capabilities = utils.merge_tables(capabilities, defaultCapabilities),
    })
end

return setup
