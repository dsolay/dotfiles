local utils = require('utils')
local file_exists = utils.file_exists

local function get_bin(default_bin, path)
    local local_bin = table.concat {
        vim.loop.cwd(),
        (path or '/node_modules/.bin/'),
        default_bin,
    }

    if (file_exists(local_bin)) then return local_bin end

    return default_bin
end

return {
    on_attach = function(bufnr)
        local function buf_set_keymap(...)
            vim.api.nvim_buf_set_keymap(bufnr, ...)
        end

        local opts = {noremap = true, silent = true}
        buf_set_keymap(
            'n', '<space>f', [[:lua vim.lsp.buf.formatting()<cr>]], opts
        )

        buf_set_keymap(
            'n', '<space>e',
            [[<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>]], opts
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
        'sh',
        'json',
        'dockerfile',
        'markdown',
        'vue',
        'env',
        'php',
    },
    init_options = {
        linters = {
            eslint = {
                command = get_bin('eslint'),
                rootPatterns = {'.git'},
                debounce = 100,
                args = {
                    '--stdin',
                    '--stdin-filename',
                    '%filepath',
                    '--format',
                    'json',
                },
                sourceName = 'eslint',
                parseJson = {
                    errorsRoot = '[0].messages',
                    line = 'line',
                    column = 'column',
                    endLine = 'endLine',
                    endColumn = 'endColumn',
                    message = '[eslint] ${message} [${ruleId}]',
                    security = 'severity',
                },
                securities = {['2'] = 'error', ['1'] = 'warning'},
                requiredFiles = {
                    '.eslintrc.js',
                    '.eslintrc.cjs',
                    '.eslintrc.yaml',
                    '.eslintrc.yml',
                    '.eslintrc.json',
                },
            },
            shellcheck = {
                command = 'shellcheck',
                debounce = 100,
                args = {
                    '--format=json',
                    '--source-path=SCRIPTDIR',
                    '--external-sources',
                    '-',
                },
                sourceName = 'shellcheck',
                parseJson = {
                    line = 'line',
                    column = 'column',
                    endLine = 'endLine',
                    endColumn = 'endColumn',
                    message = '[shellcheck] ${message} [${code}]',
                    security = 'level',
                },
                securities = {
                    error = 'error',
                    warning = 'warning',
                    note = 'info',
                    style = 'style',
                },
            },
            spectral = {
                command = get_bin('spectral'),
                debounce = 100,
                args = {
                    'lint',
                    '--ignore-unknown-format',
                    '--format',
                    'json',
                    '%filepath',
                },
                offsetLine = 1,
                offsetColumn = 1,
                sourceName = 'spectral',
                parseJson = {
                    line = 'range.start.line',
                    column = 'range.start.character',
                    endLine = 'range.end.line',
                    endColumn = 'range.end.character',
                    message = '[spectral] ${message} [${code}]',
                    security = 'severity',
                },
                securities = {
                    ['0'] = 'error',
                    ['1'] = 'warning',
                    ['2'] = 'info',
                    ['3'] = 'hint',
                },
            },
            hadolint = {
                command = 'hadolint',
                sourceName = 'hadolint',
                args = {'-f', 'json', '-'},
                rootPatterns = {'.hadolint.yaml'},
                parseJson = {
                    line = 'line',
                    column = 'column',
                    security = 'level',
                    message = '[hadolint] ${message} [${code}]',
                },
                securities = {
                    error = 'error',
                    warning = 'warning',
                    info = 'info',
                    style = 'hint',
                },
            },
            stylelint = {
                command = get_bin('stylelint'),
                rootPatterns = {'.git'},
                debounce = 100,
                args = {'--formatter', 'json', '--stdin-filename', '%filepath'},
                sourceName = 'stylelint',
                parseJson = {
                    errorsRoot = '[0].warnings',
                    line = 'line',
                    column = 'column',
                    message = '[stylelint] ${text}',
                    security = 'severity',
                },
                securities = {error = 'error', warning = 'warning'},
            },
            markdownlint = {
                command = get_bin('markdownlint'),
                isStderr = true,
                debounce = 100,
                args = {'--stdin'},
                offsetLine = 0,
                offsetColumn = 0,
                sourceName = 'markdownlint',
                formatLines = 1,
                formatPattern = {
                    [[^.*?:\s?(\d+)(:(\d+)?)?\s(MD\d{3}\/[A-Za-z0-9-/]+)\s(.*)$]],
                    {line = 1, column = 3, message = 4},
                },
            },
            dotenvlint = {
                command = get_bin('dotenv-linter'),
                debounce = 100,
                args = {'%filepath'},
                offsetLine = 0,
                offsetColumn = 0,
                sourceName = 'dotenv-linter',
                formatLines = 1,
                formatPattern = {
                    [[^.*:(\d+)\s?(.*):\s?(.*)$]],
                    {line = 1, message = {3, ' [', 2, ']'}},
                },
            },
            phpstan = {
                command = get_bin('phpstan', '/vendor/bin/'),
                debounce = 100,
                rootPatterns = {
                    'composer.json',
                    'composer.lock',
                    'vendor',
                    '.git',
                },
                args = {
                    'analyze',
                    '--error-format',
                    'raw',
                    '--no-progress',
                    '--memory-limit=2G',
                    '%filepath',
                },
                offsetLine = 0,
                offsetColumn = 0,
                sourceName = 'phpstan',
                formatLines = 1,
                formatPattern = {
                    '^[^:]+:(\\d+):(.*)(\\r|\\n)*$',
                    {line = 1, message = {'[phpstan] ', 2}},
                },
            },
        },
        filetypes = {
            javascript = 'eslint',
            javascriptreact = 'eslint',
            typescript = 'eslint',
            typescriptreact = 'eslint',
            vue = 'eslint',
            sh = 'shellcheck',
            json = 'spectral',
            dockerfile = 'hadolint',
            css = 'stylelint',
            scss = 'stylelint',
            markdown = 'markdownlint',
            env = 'dotenvlint',
            php = 'phpstan',
        },
        formatters = {
            prettier = {
                command = get_bin('prettier'),
                args = {'--stdin-filepath', '%filename'},
            },
            fixjson = {
                command = get_bin('fixjson'),
                args = {'--stdin-filename'},
            },
            ['lua-format'] = {
                command = 'lua-format',
                args = {
                    '-i',
                    '--chop-down-parameter',
                    '--chop-down-table',
                    '--break-after-functioncall-lp',
                    '--break-before-functioncall-rp',
                    '--break-before-functiondef-rp',
                    '--extra-sep-at-table-end',
                    '--double-quote-to-single-quote',
                },
            },
            ['php-cs-fixer'] = {
                command = get_bin('php-cs-fixer', '/vendor/bin/'),
                args = {'fix', '--using-cache=no', '--no-interaction', '%file'},
                isStdout = false,
                doesWriteToFile = true,
            },
        },
        formatFiletypes = {
            css = 'prettier',
            javascript = 'prettier',
            javascriptreact = 'prettier',
            scss = 'prettier',
            typescript = 'prettier',
            typescriptreact = 'prettier',
            vue = 'prettier',
            lua = 'lua-format',
            json = 'fixjson',
            php = 'prettier',
            markdown = 'prettier',
        },
    },
}
