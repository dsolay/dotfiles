return {
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            {
                "mfussenegger/nvim-dap",
                config = function()
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
                end,
                keys = {
                    {
                        "<F5>",
                        function()
                            require("dap").continue()
                        end,
                    },
                    {
                        "<F10>",
                        function()
                            require("dap").step_over()
                        end,
                    },
                    {
                        "<F11>",
                        function()
                            require("dap").step_into()
                        end,
                    },
                    {
                        "<F12>",
                        function()
                            require("dap").step_out()
                        end,
                    },
                    {
                        "<Leader>b",
                        function()
                            require("dap").toggle_breakpoint()
                        end,
                    },
                    {
                        "<Leader>B",
                        function()
                            require("dap").set_breakpoint()
                        end,
                    },
                    {
                        "<Leader>lp",
                        function()
                            require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
                        end,
                    },
                    {
                        "<Leader>dr",
                        function()
                            require("dap").repl.open()
                        end,
                    },
                    {
                        "<Leader>dl",
                        function()
                            require("dap").run_last()
                        end,
                    },
                },
            },
        },
        config = true,
        keys = {
            {
                "<C-d>",
                function()
                    require("dapui").toggle({})
                end,
            },
        },
    },
    {
        "Pocco81/DAPInstall.nvim",
        cmd = { "DIInstall", "DIUninstall", "DIList" },
    },

    { "mxsdev/nvim-dap-vscode-js" },

    {
        "microsoft/vscode-js-debug",
        lazy = true,
        build = "npm install --legacy-peer-deps && npx gulp dapDebugServer && mv dist out",
    },
}
