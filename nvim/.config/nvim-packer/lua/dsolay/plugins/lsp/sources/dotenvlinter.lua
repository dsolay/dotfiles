local helpers_status, helpers = pcall(require, "null-ls.helpers")

if not helpers_status then
    return
end

local function setup(null_ls)
    local dotenvlinter = {
        name = "dotenvlinter",
        method = null_ls.methods.DIAGNOSTICS,
        filetypes = { "env" },
        generator = null_ls.generator({
            command = "dotenv-linter",
            to_stdin = true,
            from_stderr = true,
            format = "line",
            check_exit_code = function(code)
                return code <= 1
            end,
            on_output = helpers.diagnostics.from_pattern(
                [[.*:(%d+) (%a): (.*)]],
                { "row", "code", "message" },
                {}
            ),
        }),
    }

    return dotenvlinter
end

return setup
