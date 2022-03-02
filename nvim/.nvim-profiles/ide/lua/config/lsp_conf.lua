local utils = require('utils')
local file_exists = utils.file_exists
local includes = utils.includes
local serversPath = vim.fn.stdpath('config') .. '/lua/servers/'

local signs = {Error = '✘', Warn = '', Info = '', Hint = ''}
for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, {text = icon, texthl = hl, linehl = '', numhl = ''})
end

local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local maps = require('config.lspkeymaps')
    for _, map in ipairs(maps) do
        vim.api.nvim_buf_set_keymap(bufnr, map[1], map[2], map[3], map[4]);
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
vim.diagnostic.config({virtual_text = false})

-- config that activates keymaps and enables snippet support
local function make_config(server)
    local capabilities = require('cmp_nvim_lsp').update_capabilities(
                             vim.lsp.protocol.make_client_capabilities()
                         )

    local base_config = {
        capabilities = capabilities,
        on_attach = on_attach,
        flags = {
            -- This will be the default in neovim 0.7+
            debounce_text_changes = 150,
        },
    }

    local server_name = server.name

    if (file_exists(serversPath .. server_name .. '.lua')) then
        return vim.tbl_extend(
                   'force', base_config, require('servers.' .. server_name)
               )
    else
        return base_config
    end
end

-- lsp-install
local exclude_lsp_install_servers = {'volar'}
local function setup_servers()
    local lsp_installer = require('nvim-lsp-installer')

    lsp_installer.on_server_ready(
        function(server)
            if not includes(exclude_lsp_install_servers, server.name) then
                server:setup(make_config(server))
            end
        end
    )
end

local servers = {'volar_multiple'}
local function setup_manual_servers()
    for _, lsp in pairs(servers) do
        if (file_exists(serversPath .. lsp .. '.lua')) then
            require('servers.' .. lsp).setup()
        end
    end
end

setup_servers()
setup_manual_servers()
