local opts = {noremap = true, silent = true}

function Diagnostic_next(severity)
    local next = vim.lsp.diagnostic.goto_next;
    if (severity == nil or severity == '') then
        next({enable_popup = false})
    else
        next({severity = severity, enable_popup = false})
    end
end

function Diagnostic_prev(severity)
    local prev = vim.lsp.diagnostic.goto_prev;
    if (severity == nil or severity == '') then
        prev({enable_popup = false})
    else
        prev({severity = severity, enable_popup = false})
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
    {
        'n',
        '<space>e',
        [[<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>]],
        opts,
    },
    {'n', ']e', [[<cmd>lua Diagnostic_next('Error')<cr>]], opts},
    {'n', '[e', [[<cmd>lua Diagnostic_prev('Error')<cr>]], opts},
    {'n', ']w', [[<cmd>lua Diagnostic_next('Warning')<cr>]], opts},
    {'n', '[w', [[<cmd>lua Diagnostic_prev('Warning')<cr>]], opts},
    {'n', ']i', [[<cmd>lua Diagnostic_next('Information')<cr>]], opts},
    {'n', '[i', [[<cmd>lua Diagnostic_prev('Information')<cr>]], opts},
    {'n', ']h', [[<cmd>lua Diagnostic_next('Hint')<cr>]], opts},
    {'n', '[h', [[<cmd>lua Diagnostic_prev('Hint')<cr>]], opts},
    {'n', ']d', [[<cmd>lua Diagnostic_next()<cr>]], opts},
    {'n', '[d', [[<cmd>lua Diagnostic_prev()<cr>]], opts},
    {'n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>', opts},
};
