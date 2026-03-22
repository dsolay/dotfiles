local formatters_config = require("dsolay.config.formatters")

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

-- Fix conceallevel for json files
vim.api.nvim_create_augroup("json_conceal", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = "json_conceal",
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
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

        -- Pre-calculate best formatter for this buffer's filetype
        -- This avoids recalculating on every format keystroke
        local best_formatter = formatters_config.get_best_formatter(vim.bo.filetype)
        vim.b.best_formatter = best_formatter  -- Cache in buffer-local variable

        if client:supports_method("textDocument/implementation") then
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to Implementation" }))
        end

        if client:supports_method("textDocument/declaration") then
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to Declaration" }))
        end

        if client:supports_method("textDocument/definition") then
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to Definition" }))
        end

        if client:supports_method("textDocument/typeDefinition") then
            vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to Type Definition" }))
        end

        if client:supports_method("textDocument/references") then
            vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Find References" }))
        end

        if client:supports_method("textDocument/signatureHelp") then
            vim.keymap.set("n", "<leader>K", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature Help" }))
        end

        if client:supports_method("textDocument/hover") then
            vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover Info" }))
        end

        if client:supports_method("textDocument/rename") then
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))
        end

        if client:supports_method("textDocument/codeAction") then
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))
        end

        if client:supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<space>z", function()
                vim.lsp.buf.format({
                    filter = function(_client)
                        return _client.name == "null-ls"
                    end,
                    bufnr = bufnr,
                })
            end, vim.tbl_extend("force", opts, { desc = "Format (null-ls)" }))

            vim.keymap.set("n", "<space>f", function()
                vim.lsp.buf.format({
                    filter = function(_client)
                        return vim.b.best_formatter and _client.name == vim.b.best_formatter.name or false
                    end,
                    bufnr = bufnr,
                    timeout_ms = 60000,
                })
            end, vim.tbl_extend("force", opts, { desc = "Format (Best Server)" }))
        end

        vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", opts, { desc = "Add Workspace Folder" }))
        vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", opts, { desc = "Remove Workspace Folder" }))
    end,
})
