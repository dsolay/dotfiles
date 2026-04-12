local M = {}

--- Split an environment variable value by a delimiter.
function M.enable_lsp_servers()
    local lsp_configs = {}

    for _, f in pairs(vim.api.nvim_get_runtime_file('after/lsp/*.lua', true)) do
    local server_name = vim.fn.fnamemodify(f, ':t:r')
    table.insert(lsp_configs, server_name)
    end

    vim.lsp.enable(lsp_configs)
end

return M
