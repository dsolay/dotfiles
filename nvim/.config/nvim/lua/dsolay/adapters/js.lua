local function setup()
    local status, dap = pcall(require, "dap")

    if not status then
        return
    end

    local debugger_path = table.concat({
        vim.fn.stdpath("data"),
        "mason",
        "packages",
        "js-debug-adapter",
    }, "/")

    require("dap-vscode-js").setup({
        -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
        -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
        -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
        -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
        -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
        debugger_path = debugger_path,
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
    })

    dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
            command = debugger_path .. "/js-debug-adapter",
            args = { "${port}" },
        },
    }

    dap.configurations.javascript = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            runtimeArgs = { "--experimental-specifier-resolution=node" },
            skipFiles = { "<node_internals>/**" },
        },
    }

    dap.configurations.typescript = {
        {
            name = "Debug javascript file",
            type = "pwa-node",
            request = "launch",
            program = "${file}",
            cwd = "${workspaceFolder}",
            runtimeArgs = { "--experimental-specifier-resolution=node" },
            skipFiles = { "<node_internals>/**" },
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "Debug local strapi",
            runtimeArgs = { "local" },
            sourceMaps = true,
            runtimeExecutable = "yarn",
            cwd = vim.fn.getcwd(),
            skipFiles = { "<node_internals>/**", "node_modules/**" },
            env = {
                NODE_OPTIONS = "--inspect",
                DATABASE_SSL = "false",
                NODE_ENV = "development",
            },
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "Debug development strapi",
            runtimeArgs = { "develop" },
            sourceMaps = true,
            runtimeExecutable = "yarn",
            cwd = vim.fn.getcwd(),
            skipFiles = { "<node_internals>/**", "node_modules/**" },
            env = {
                NODE_OPTIONS = "--inspect",
                DATABASE_SSL = "false",
                NODE_ENV = "development",
            },
        },
        {
            type = "pwa-node",
            request = "attach",
            name = "Attach to strapi",
            port = 9230,
            console = "externalTerminal",
            skipFiles = { "<node_internals>/**", "node_modules/**" },
        },
    }
end

return setup
