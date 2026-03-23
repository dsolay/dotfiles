local helpers = require("null-ls.helpers")
local M = {}

M.setup = function(null_ls)
    null_ls.register({
        name = "rumdl-check",
        method = null_ls.methods.DIAGNOSTICS,
        filetypes = { "markdown" },
        generator = helpers.generator_factory({
            command = "rumdl",
            args = { "check", "--output-format", "json", "--stdin" },
            format = "json",
            to_stdin = true,
            ignore_stderr = true,
            on_output = helpers.diagnostics.from_json({
                attributes = {
                    row = "line",
                    col = "column",
                    severity = "severity",
                    message = "message",
                    code = "rule",
                },
                severities = {
                    helpers.diagnostics.severities["warning"],
                },
            }),
        }),
    })

    null_ls.register({
        name = "rumdl-fmt",
        method = null_ls.methods.FORMATTING,
        filetypes = { "markdown" },
        generator = helpers.formatter_factory({
            command = "rumdl",
            args = { "fmt", "--stdin" },
            to_stdin = true,
        }),
    })
end

return M
