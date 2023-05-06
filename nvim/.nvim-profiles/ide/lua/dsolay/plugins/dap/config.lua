local status, dap = pcall(require, "dap")

if not status then
    return
end

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "RedSign", linehl = "", numhl = "" })

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

local fn = vim.fn
local plugin_path = fn.stdpath("data") .. "/site/pack/cheovim/ide"

require("dap-vscode-js").setup({
    -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
    -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
    -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
    adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
    -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
    -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
    -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
})

dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
        command = "node",
        -- 💀 Make sure to update this path to point to your installation
        args = { plugin_path .. "/opt/vscode-js-debug/out/src/dapDebugServer.js", "${port}" },
    },
}

dap.configurations.javascript = {
    {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
    },
}

dap.configurations.typescript = {
    {
        type = "pwa-node",
        request = "launch",
        name = "Strapi Debug",
        program = "${workspaceRoot}/node_modules/@strapi/strapi/bin/strapi.js",
        cwd = "${workspaceFolder}",
        skipFiles = { "<node_internals>/**" },
        protocol = "inspector",
        console = "integratedTerminal",
        runtimeExecutable = "node",
        runtimeVersion = "16.19.1",
        runtimeArgs = { "--lazy" },
        args = {
            "develop",
        },
        env = {
            NODE_ENV = "development",
        },
        autoAttachChildProcesses = true,
    },
}
