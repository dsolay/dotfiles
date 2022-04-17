local utils = require('utils')
local file_exists = utils.file_exists
local includes = utils.includes
local get_env_values = utils.get_env_values
local serversPath = vim.fn.stdpath('config') .. '/lua/servers/'

local signs = {Error = '✘', Warn = '', Info = '', Hint = ''}
for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, {text = icon, texthl = hl, linehl = '', numhl = ''})
end

local function map(mode, l, r, opts)
    opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
    vim.keymap.set(mode, l, r, opts)
end

local severity = vim.diagnostic.severity
map('n', '<space>e', vim.diagnostic.open_float)
map('n', '<space>q', vim.diagnostic.setloclist)
map('n', '[d', vim.diagnostic.goto_prev)
map('n', ']d', vim.diagnostic.goto_next)
map(
    'n', '[e', function()
        vim.diagnostic.goto_prev({severity = severity.ERROR, float = false})
    end
)
map(
    'n', ']e', function()
        vim.diagnostic.goto_next({severity = severity.ERROR, float = false})
    end
)
map(
    'n', '[w', function()
        vim.diagnostic.goto_prev({severity = severity.WARN, float = false})
    end
)
map(
    'n', ']w', function()
        vim.diagnostic.goto_next({severity = severity.WARN, float = false})
    end
)
map(
    'n', '[i', function()
        vim.diagnostic.goto_prev({severity = severity.INFO, float = false})
    end
)
map(
    'n', ']i', function()
        vim.diagnostic.goto_next({severity = severity.INFO, float = false})
    end
)
map(
    'n', '[h', function()
        vim.diagnostic.goto_prev({severity = severity.HINT, float = false})
    end
)
map(
    'n', ']h', function()
        vim.diagnostic.goto_next({severity = severity.HINT, float = false})
    end
)

local on_attach = function(_, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    map('n', 'gD', vim.lsp.buf.declaration, {buffer = bufnr})
    map('n', 'gd', vim.lsp.buf.definition, {buffer = bufnr})
    map('n', 'K', vim.lsp.buf.hover, {buffer = bufnr})
    map('n', 'gi', vim.lsp.buf.implementation, {buffer = bufnr})
    map('n', '<leader>K', vim.lsp.buf.signature_help, {buffer = bufnr})
    map('n', '<leader>D', vim.lsp.buf.type_definition, {buffer = bufnr})
    map('n', '<leader>rn', vim.lsp.buf.rename, {buffer = bufnr})
    map('n', 'gr', vim.lsp.buf.references, {buffer = bufnr})
    map('n', '<space>f', vim.lsp.buf.formatting, {buffer = bufnr})

    vim.api.nvim_create_autocmd(
        'BufWritePre', {
            pattern = '<buffer>',
            callback = function()
                vim.lsp.buf.formatting_seq_sync(nil, 100, {'efm'})
            end,
        }
    )
end

-- Config diagnostics
vim.diagnostic.config({virtual_text = false})

-- config that activates keymaps and enables snippet support
local function make_config(server)
    local capabilities = require('cmp_nvim_lsp').update_capabilities(
                             vim.lsp.protocol.make_client_capabilities()
                         )

    local base_config = {capabilities = capabilities, on_attach = on_attach}

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
local exclude_lsp_servers = get_env_values('EXCLUDE_LSP_SERVERS')
local function setup_servers()
    local lsp_installer = require('nvim-lsp-installer')

    lsp_installer.on_server_ready(
        function(server)
            if not includes(exclude_lsp_servers, server.name) then
                server:setup(make_config(server))
            end
        end
    )
end

local servers = get_env_values('CUSTOM_SERVERS')
local function setup_manual_servers()
    for _, lsp in pairs(servers) do
        if (file_exists(serversPath .. lsp .. '.lua')) then
            require('servers.' .. lsp).setup()
        end
    end
end

setup_servers()
setup_manual_servers()
