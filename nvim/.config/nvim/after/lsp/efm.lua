local languages = {
    env = {
        {
            lintCommand = "dotenv-linter",
            lintSource = "dotenv-linter",
            lintFormats = { "%f:%l %m" },
        },
    },
}

return {
    init_options = {
        documentFormatting = true,
        hover = false,
        documentSymbol = false,
        codeAction = false,
        completion = false,
    },
    filetypes = { "env" },
    settings = { rootMarkers = { ".git/" }, languages = languages },
}
