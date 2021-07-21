local merge = vim.tbl_extend
local sign_define = vim.fn.sign_define

sign_define(
    'LspDiagnosticsSignError',
    {text = '✘', texthl = 'RedSign', linehl = '', numhl = ''}
)
sign_define(
    'LspDiagnosticsSignWarning',
    {text = '', texthl = 'YellowSign', linehl = '', numhl = ''}
)
sign_define(
    'LspDiagnosticsSignInformation',
    {text = '', texthl = 'BlueSign', linehl = '', numhl = ''}
)
sign_define(
    'LspDiagnosticsSignHint',
    {text = '', texthl = 'WhiteSign', linehl = '', numhl = ''}
)

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc');

    -- Mappings.
    local maps = require('config.lsp_keymaps')
    for _, map in ipairs(maps) do
        buf_set_keymap(map[1], map[2], map[3], map[4]);
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight == true then
        vim.cmd(
            [[
                hi LspReferenceText cterm=underline gui=underline
                hi LspReferenceRead cterm=underline gui=underline
                hi LspReferenceWrite cterm=underline gui=underline
            ]]
        )

        vim.cmd(
            [[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
            ]]
        )
    end
end

-- Config diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            underline = true,
            virtual_text = false,
            signs = true,
            update_in_insert = false
        }
    )

-- config that activates keymaps and enables snippet support
local function make_config(server)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport =
        {properties = {'documentation', 'detail', 'additionalTextEdits'}}

    local base_config = {capabilities = capabilities, on_attach = on_attach}

    if (server == 'lua') then
        return merge('force', base_config, require('servers.lua'))
    elseif server == 'vue' then
        return merge('force', base_config, require('servers.vue'))
    elseif server == 'intelephense' then
        return merge('force', base_config, require('servers.intelephense'))
    elseif server == 'diagnosticls' then
        return require('servers.diagnosticls')
    else
        return base_config
    end
end

-- lsp-install
local function setup_servers()
    require'lspinstall'.setup()

    -- get all installed servers
    local servers = require'lspinstall'.installed_servers()

    table.insert(servers, 'intelephense')

    for _, server in pairs(servers) do
        local config = make_config(server)

        require'lspconfig'[server].setup(config)
    end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function()
    setup_servers() -- reload installed servers
    vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end
