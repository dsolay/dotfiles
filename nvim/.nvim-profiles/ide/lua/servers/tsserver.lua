return {
    init_options = require('nvim-lsp-ts-utils').init_options,
    on_attach = function(client, bufnr)
        local ts_utils = require('nvim-lsp-ts-utils')

        ts_utils.setup({
            filter_out_diagnostics_by_code = {80001},
            auto_inlay_hints = false,
        })

        -- required to fix code action ranges and filter diagnostics
        ts_utils.setup_client(client)

        -- no default maps, so you may want to define some here
        local opts = {silent = true}
        vim.api.nvim_buf_set_keymap(
            bufnr, 'n', '<leader>oi', ':TSLspOrganize<CR>', opts
        )
        vim.api.nvim_buf_set_keymap(
            bufnr, 'n', '<leader>trn', ':TSLspRenameFile<CR>', opts
        )
        vim.api.nvim_buf_set_keymap(
            bufnr, 'n', '<leader>ia', ':TSLspImportAll<CR>', opts
        )
    end,
}
