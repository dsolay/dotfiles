local allowed_lsp_servers = {
    { name = "null-ls", priority = 2, filetypes = {} },
    {
        name = "eslint",
        priority = 1,
        filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" },
    },
    { name = "prismals", priority = 1, filetypes = { "prisma" } },
    { name = "dockerls", priority = 1, filetypes = { "dockerfile" } },
    { name = "jsonls", priority = 1, filetypes = { "json", "jsonc" } },
    { name = "terraformls", priority = 1, filetypes = { "tf", "terraform", "hcl" } },
}

-- Highlight line only in current window
vim.api.nvim_create_augroup("CursorLine", {})

vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
    group = "CursorLine",
    pattern = "*",
    callback = function()
        vim.opt_local.cursorline = true
    end,
})

vim.api.nvim_create_autocmd("WinLeave", {
    group = "CursorLine",
    pattern = "*",
    callback = function()
        vim.opt_local.cursorline = false
    end,
})

-- Return to last edit position when opening files (You want this!)
vim.api.nvim_create_augroup("preserve_last_position", {})
vim.api.nvim_create_autocmd("BufReadPost", {
    group = "preserve_last_position",
    pattern = "*",
    callback = function()
        local last_pos = vim.fn.line("'\"")
        if last_pos > 0 and last_pos <= vim.fn.line("$") then
            vim.api.nvim_win_set_cursor(0, { last_pos, 0 })
        end
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        local bufnr = args.buf
        local server_name = client.name

        -- Call your existing on_attach if you have one:
        -- if servers[server_name] and servers[server_name].on_attach then
        --   servers[server_name].on_attach(client, bufnr)
        -- end

        local opts = { noremap = true, silent = true, buffer = bufnr }

        if client:supports_method("textDocument/implementation") then
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        end

        if client:supports_method("textDocument/declaration") then
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        end

        if client:supports_method("textDocument/definition") then
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        end

        if client:supports_method("textDocument/typeDefinition") then
            vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
        end

        if client:supports_method("textDocument/references") then
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        end

        if client:supports_method("textDocument/signatureHelp") then
            vim.keymap.set("n", "<leader>K", vim.lsp.buf.signature_help, opts)
        end

        if client:supports_method("textDocument/hover") then
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        end

        if client:supports_method("textDocument/rename") then
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        end

        if client:supports_method("textDocument/codeAction") then
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        end

        if client:supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<space>z", function()
                vim.lsp.buf.format({
                    filter = function(_client)
                        return _client.name == "null-ls"
                    end,
                    bufnr = bufnr,
                })
            end, opts)

            vim.keymap.set("n", "<space>f", function()
                vim.lsp.buf.format({
                    filter = function(_client)
                        local filetype = vim.bo.filetype

                        local best_server = nil
                        local highest_priority = math.huge

                        for _, server in ipairs(allowed_lsp_servers) do
                            if vim.tbl_contains(server.filetypes, filetype) or #server.filetypes == 0 then
                                if server.priority < highest_priority then
                                    highest_priority = server.priority
                                    best_server = server
                                end
                            end
                        end

                        if best_server then
                            return _client.name == best_server.name
                        end

                        return false
                    end,
                    bufnr = bufnr,
                    timeout_ms = 60000,
                })
            end, opts)
        end

        vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    end,
})
