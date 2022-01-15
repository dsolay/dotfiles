local opts = {noremap = true, silent = true}

function Diagnostic_next(severity)
    local next = vim.diagnostic.goto_next;
    if (severity == nil or severity == '') then
        next({float = false})
    else
        next({severity = vim.diagnostic.severity[severity], float = false})
    end
end

function Diagnostic_prev(severity)
    local prev = vim.diagnostic.goto_prev;
    if (severity == nil or severity == '') then
        prev({float = false})
    else
        prev({severity = vim.diagnostic.severity[severity], float = false})
    end
end

return {
    {'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts},
    {'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts},
    {'n', 'K', [[<cmd>lua vim.lsp.buf.hover()<cr>]], opts},
    {'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts},
    {'n', '<leader>K', [[<cmd>lua vim.lsp.buf.signature_help()<cr>]], opts},
    {'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts},
    {'n', '<leader>rn', [[<cmd>lua vim.lsp.buf.rename()<cr>]], opts},
    {'n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts},
    {'n', '<space>e', [[<cmd>lua vim.diagnostic.open_float()<cr>]], opts},
    {'n', ']e', [[<cmd>lua Diagnostic_next(ERROR)<cr>]], opts},
    {'n', '[e', [[<cmd>lua Diagnostic_prev(ERROR)<cr>]], opts},
    {'n', ']w', [[<cmd>lua Diagnostic_next(WARN)<cr>]], opts},
    {'n', '[w', [[<cmd>lua Diagnostic_prev(WARN)<cr>]], opts},
    {'n', ']i', [[<cmd>lua Diagnostic_next(INFO)<cr>]], opts},
    {'n', '[i', [[<cmd>lua Diagnostic_prev(INFO)<cr>]], opts},
    {'n', ']h', [[<cmd>lua Diagnostic_next(HINT)<cr>]], opts},
    {'n', '[h', [[<cmd>lua Diagnostic_prev(HINT)<cr>]], opts},
    {'n', ']d', [[<cmd>lua Diagnostic_next()<cr>]], opts},
    {'n', '[d', [[<cmd>lua Diagnostic_prev()<cr>]], opts},
    {'n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<cr>', opts},
};
