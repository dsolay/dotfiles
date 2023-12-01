local function setup()
    local status, dap = pcall(require, "dap")

    if not status then
        return
    end

    local php_debug_path = table.concat({
        vim.fn.stdpath("data"),
        "mason",
        "packages",
        "php-debug-adapter",
        "extension",
        "out",
        "phpDebug.js",
    }, "/")

    dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { php_debug_path },
    }

    dap.configurations.php = {
        {
            type = "php",
            request = "launch",
            name = "Listen for Xdebug",
            port = 9003,
        },
    }
end

return setup
