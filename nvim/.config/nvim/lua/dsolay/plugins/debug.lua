return {
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            {
                "mfussenegger/nvim-dap",
                config = function()
                    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "RedSign", linehl = "", numhl = "" })

                    require("dsolay.adapters.php")()
                    require("dsolay.adapters.js")()
                end,
                keys = {
                    {
                        "<F5>",
                        function()
                            require("dap").continue()
                        end,
                        desc = "Debug: Continue",
                    },
                    {
                        "<F9>",
                        function()
                            require("dap").step_over()
                        end,
                        desc = "Debug: Step Over",
                    },
                    {
                        "<F10>",
                        function()
                            require("dap").step_into()
                        end,
                        desc = "Debug: Step Into",
                    },
                    {
                        "<F11>",
                        function()
                            require("dap").step_out()
                        end,
                        desc = "Debug: Step Out",
                    },
                    {
                        "<Leader>b",
                        function()
                            require("dap").toggle_breakpoint()
                        end,
                        desc = "Toggle Breakpoint",
                    },
                    {
                        "<Leader>B",
                        function()
                            require("dap").set_breakpoint()
                        end,
                        desc = "Set Breakpoint",
                    },
                    {
                        "<Leader>lp",
                        function()
                            require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
                        end,
                        desc = "Set Log Point",
                    },
                    {
                        "<Leader>dr",
                        function()
                            require("dap").repl.open()
                        end,
                        desc = "Open Debug REPL",
                    },
                    {
                        "<Leader>dl",
                        function()
                            require("dap").run_last()
                        end,
                        desc = "Run Last Debug Session",
                    },
                },
            },
            "nvim-neotest/nvim-nio",
        },
        config = true,
        keys = {
            {
                "<C-z>",
                function()
                    require("dapui").toggle({})
                end,
                desc = "Toggle DAP UI",
            },
        },
    },
    {
        "Pocco81/DAPInstall.nvim",
        cmd = { "DIInstall", "DIUninstall", "DIList" },
    },

    { "mxsdev/nvim-dap-vscode-js" },
}
