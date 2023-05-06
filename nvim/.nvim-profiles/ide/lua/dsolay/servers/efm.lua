local utils_status, utils = pcall(require, "dsolay.utils")

if not utils_status then
    return
end

local modules = { node = "/node_modules/.bin/", php = "/vendor/bin/" }

local function get_bin(default_bin, type)
    local local_bin = table.concat({
        vim.loop.cwd(),
        modules[type or "node"],
        default_bin,
    })

    if utils.file_exists(local_bin) then
        return local_bin
    end

    return default_bin
end

local languages = {
    env = {
        {
            lintCommand = "dotenv-linter",
            lintSource = "dotenv-linter",
            lintFormats = { "%f:%l %m" },
        },
    },
    php = {
        {
            lintCommand = table.concat({
                "./vendor/bin/phpstan",
                "analyze",
                "--error-format raw",
                "--no-progress",
            }, " "),
            lintSource = "phpstan",
        },
    },
}

local function setup(lspconfig, on_attach, capabilities)
    lspconfig.efm.setup({
        init_options = {
            documentFormatting = true,
            hover = false,
            documentSymbol = false,
            codeAction = false,
            completion = false,
        },
        on_attach = function(client, bufnr)
            on_attach(client, bufnr)

            vim.keymap.set("n", "<C-S-I>", function()
                vim.lsp.buf.format({
                    filter = function(lsp_client)
                        return lsp_client.name == "efm"
                    end,
                    bufnr = bufnr,
                })
            end, { noremap = true, buffer = bufnr })
        end,
        capabilities,
        capabilities,
        filetypes = { "env" },
        settings = { rootMarkers = { ".git/" }, languages = languages },
    })
end

return setup
