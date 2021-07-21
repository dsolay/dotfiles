local utils = require('utils')
local file_exists = utils.file_exists

local function get_eslint_bin()
    local eslint_bin = 'eslint';
    local modules_bin = vim.loop.cwd() .. '/node_modules/.bin'

    if (file_exists(modules_bin .. '/eslint_d')) then
        eslint_bin = modules_bin .. '/eslint_d'
    elseif file_exists(modules_bin .. '/eslint') then
        eslint_bin = modules_bin .. '/eslint'
    elseif vim.fn.executable('eslint_d') == 1 then
        eslint_bin = 'eslint_d'
    end

    return eslint_bin
end

local function get_prettier_bin()
    local prettier_bin = 'prettier';
    local modules_bin = vim.loop.cwd() .. '/node_modules/.bin'

    if (file_exists(modules_bin .. '/prettier_d')) then
        prettier_bin = modules_bin .. '/prettier_d'
    elseif file_exists(modules_bin .. '/prettier') then
        prettier_bin = modules_bin .. '/prettier'
    elseif vim.fn.executable('prettier_d') == 1 then
        prettier_bin = 'prettier_d'
    end

    return prettier_bin
end

local function get_stylelint_bin()
    local stylelint_bin = 'stylelint';
    local modules_bin = vim.loop.cwd() .. '/node_modules/.bin'

    if (file_exists(modules_bin .. '/stylelint')) then
        stylelint_bin = modules_bin .. '/stylelint'
    end

    return stylelint_bin
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
            [[<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>]],
            opts
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
                command = get_eslint_bin(),
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
                command = 'spectral',
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
                command = get_stylelint_bin(),
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
                command = 'markdownlint',
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
                command = 'dotenv-linter',
                isStderr = true,
                debounce = 100,
                args = {'lint', '%filepath'},
                offsetLine = 0,
                offsetColumn = 0,
                sourceName = 'dotenv-linter',
                formatLines = 1,
                formatPattern = {
                    [[^.*?:(\d+)\s?(\d+)\s?(.*)$]],
                    {line = 1, message = {'[dotenv-linter] ', 3, ' [', 2, ']'}},
                },
            },
            phpstan = {
                command = './vendor/bin/phpstan',
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
                command = get_prettier_bin(),
                args = {'--stdin-filepath', '%filename'},
            },
            fixjson = {command = 'fixjson', args = {'--stdin-filename'}},
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
                command = './vendor/bin/php-cs-fixer',
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
