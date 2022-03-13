local utils = require('utils')
local file_exists = utils.file_exists

local modules = {node = '/node_modules/.bin/', php = '/vendor/bin/'}

local function get_bin(default_bin, type)
    local local_bin = table.concat {
        vim.loop.cwd(),
        (modules[type or 'node']),
        default_bin,
    }

    if (file_exists(local_bin)) then return local_bin end

    return default_bin
end

local languages = {
    css = {{formatCommand = get_bin('prettier') .. ' --parser css'}},
    dockerfile = {
        {
            lintCommand = 'hadolint --no-color',
            lintSource = 'hadolint',
            lintFormats = {'%f:%l %m'},
        },
    },
    env = {
        {
            lintCommand = 'dotenv-linter',
            lintSource = 'dotenv-linter',
            lintFormats = {'%f:%l %m'},
        },
    },
    html = {{formatCommand = get_bin('prettier') .. ' --parser html'}},
    javascript = {{formatCommand = get_bin('prettier')}},
    javascriptreact = {{formatCommand = get_bin('prettier')}},
    json = {{formatCommand = get_bin('fixjson')}},
    lua = {
        {
            formatCommand = table.concat(
                {
                    'lua-format',
                    '-i',
                    '--chop-down-parameter',
                    '--chop-down-table',
                    '--break-after-functioncall-lp',
                    '--break-before-functioncall-rp',
                    '--break-before-functiondef-rp',
                    '--extra-sep-at-table-end',
                    '--double-quote-to-single-quote',
                }, ' '
            ),
            formatStdin = true,
        },
    },
    markdown = {
        {
            lintCommand = 'markdownlint --stdin',
            lintSource = 'markdownlint',
            lintStdin = true,
            lintFormats = {'%f:%l %m', '%f:%l:%c %m', '%f: %l: %m'},
        },
        {formatCommand = get_bin('prettier') .. ' --parser markdown'},
    },
    php = {
        {
            lintCommand = table.concat(
                {
                    get_bin('phpstan', 'php'),
                    'analyze',
                    '--error-format raw',
                    '--no-progress',
                    '--memory-limit 2G',
                }, ' '
            ),
            lintSource = 'phpstan',
        },
    },
    scss = {{formatCommand = get_bin('prettier') .. ' --parser scss'}},
    sh = {
        {
            lintCommand = table.concat(
                {
                    'shellcheck',
                    '--format gcc',
                    '--source-path=SCRIPTDIR',
                    '--external-sources',
                }, ' '
            ),
            lintSource = 'shellcheck',
            lintFormats = {
                '%f:%l:%c: %trror: %m',
                '%f:%l:%c: %tarning: %m',
                '%f:%l:%c: %tote: %m',
            },
        },
    },
    typescript = {
        {formatCommand = get_bin('prettier') .. ' --parser typescript'},
    },
    typescriptreact = {
        {formatCommand = get_bin('prettier') .. ' --parser typescript'},
    },
    vue = {{formatCommand = get_bin('prettier') .. ' --parser vue'}},
}

return {
    init_options = {
        documentFormatting = true,
        hover = false,
        documentSymbol = false,
        codeAction = false,
        completion = false,
    },
    on_attach = function(bufnr)
        local opts = {noremap = true, silent = true}
        vim.api.nvim_buf_set_keymap(
            bufnr, 'n', '<space>f', [[<cmd>lua vim.lsp.buf.formatting()<cr>]],
            opts
        )

        vim.api.nvim_buf_set_keymap(
            bufnr, 'n', '<space>e',
            [[<cmd>lua vim.diagnostic.open_float()<cr>]], opts
        )
    end,
    filetypes = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'css',
        'scss',
        'lua',
        'env',
        'sh',
        'json',
        'dockerfile',
        'markdown',
        'vue',
        'php',
    },
    settings = {rootMarkers = {'.git/'}, languages = languages},
}
