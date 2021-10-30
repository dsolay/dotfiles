local cmp = require 'cmp'
local lspkind = require('lspkind')

local source_mapping = {
    buffer = '[Buffer]',
    nvim_lsp = '[LSP]',
    nvim_lua = '[Lua]',
    path = '[Path]',
    vsnip = '[VSnip]',
}

cmp.setup(
    {
        formatting = {
            format = function(entry, vim_item)
                vim_item.kind = lspkind.presets.default[vim_item.kind]
                local menu = source_mapping[entry.source.name]
                vim_item.menu = menu
                return vim_item
            end,
        },
        snippet = {
            expand = function(args)
                vim.fn['vsnip#anonymous'](args.body)
            end,
        },
        mapping = {
            ['<C-n>'] = cmp.mapping(
                cmp.mapping.select_next_item(
                    {behavior = cmp.SelectBehavior.Insert}
                ), {'i', 'c'}
            ),
            ['<C-p>'] = cmp.mapping(
                cmp.mapping.select_prev_item(
                    {behavior = cmp.SelectBehavior.Insert}
                ), {'i', 'c'}
            ),
            ['<Down>'] = cmp.mapping(
                cmp.mapping.select_next_item(
                    {behavior = cmp.SelectBehavior.Select}
                ), {'i', 'c'}
            ),
            ['<Up>'] = cmp.mapping(
                cmp.mapping.select_prev_item(
                    {behavior = cmp.SelectBehavior.Select}
                ), {'i', 'c'}
            ),
            ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
            ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
            ['<C-e>'] = cmp.mapping(
                {i = cmp.mapping.abort(), c = cmp.mapping.close()}
            ),
            ['<CR>'] = cmp.mapping(
                {
                    i = cmp.mapping.confirm(
                        {behavior = cmp.ConfirmBehavior.Replace, select = true}
                    ),
                    c = cmp.mapping.confirm({select = false}),
                }
            ),
            ['<Tab>'] = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end,
        },
        sources = {
            {name = 'nvim_lsp'},
            {name = 'vsnip'},
            {name = 'path'},
            {name = 'buffer'},
        },
    }
)

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {sources = {{name = 'buffer'}}})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(
    ':', {sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})}
)
