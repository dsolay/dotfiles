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
vim.lsp.handlers['textDocument/publishDiagnostics'] =
    vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            underline = true,
            virtual_text = false,
            signs = true,
            update_in_insert = false,
        }
    )

-- config that activates keymaps and enables snippet support
local function make_config(server)
    local capabilities = require('cmp_nvim_lsp').update_capabilities(
                             vim.lsp.protocol.make_client_capabilities()
                         )
    local base_config = {capabilities = capabilities, on_attach = on_attach}

    local server_name = server.name
    if (server_name == 'lua') then
        return merge('force', base_config, require('servers.lua'))
    elseif (server_name == 'eslint') then
        return merge('force', base_config, require('servers.eslint'))
    elseif (server_name == 'jsonls') then
        return merge('force', base_config, require('servers.jsonls'))
    elseif server_name == 'intelephense' then
        return merge('force', base_config, require('servers.intelephense'))
    elseif server_name == 'diagnosticls' then
        return require('servers.diagnosticls')
    else
        return base_config
    end
end

-- lsp-install
local function setup_servers()
    local lsp_installer = require('nvim-lsp-installer')

    lsp_installer.on_server_ready(
        function(server)
            server:setup(make_config(server))
            vim.cmd [[ do User LspAttachBuffers ]]
        end
    )
end

setup_servers()
