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
                    message = '${message} [${code}]',
                    security = 'level',
                },
                securities = {
                    error = 'error',
                    warning = 'warning',
                    note = 'info',
                    style = 'style',
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
                    message = '${message} [${code}]',
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
                    message = '${text}',
                    security = 'severity',
                },
                securities = {error = 'error', warning = 'warning'},
            },
            markdownlint = {
                command = get_bin('markdownlint'),
                isStderr = true,
                debounce = 100,
                args = {'--json', '--stdin'},
                sourceName = 'markdownlint',
                parseJson = {
                    line = 'lineNumber',
                    message = '${ruleDescription} [${ruleNames[0]}/${ruleNames[1]}]',
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
                    {line = 1, message = 2},
                },
            },
        },
        filetypes = {
            sh = 'shellcheck',
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
            sh = 'prettier'
        },
    },
}
