local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

local function button(sc, txt, keybind, keybind_opts)
    local b = dashboard.button(sc, txt, keybind, keybind_opts)
    b.opts.hl = 'Function'
    b.opts.hl_shortcut = 'Type'
    return b
end

-- Set header
dashboard.section.header.val = {
    '                                                     ',
    '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
    '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
    '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
    '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
    '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
    '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
    '                                                     ',
}

-- Set menu
dashboard.section.buttons.val = {
    button('n', '  New file', '<cmd>enew<cr>'),
    button('r', '  Recently opened files', '<cmd>Telescope oldfiles<cr>'),
    button('f', '  Find file', '<cmd>Telescope find_files hidden=true<cr>'),
    button('l', '  Find word', '<cmd>Telescope live_grep<CR>'),
    button('p', '  Find project', '<cmd>Telescope project<cr>'),
    button('s', '  Open session'),
    button('t', '  TODO', '<cmd>TodoTelescope<cr>'),
    button(
        'c', '  Settings', '<cmd>e ~/.nvim-profiles/ide/lua/settings.lua<cr>'
    ),
    button('q', '  Quit', '<cmd>qa<cr>'),
}

dashboard.section.footer.val = {'Do one thing, do it well - Unix philosophy'}

-- Send config to alpha
alpha.setup(dashboard.opts)

-- hide tabline and statusline on startup screen
vim.api.nvim_create_augroup('alpha_tabline', {})

vim.api.nvim_create_autocmd('FileType', {
    group = 'alpha_tabline',
    pattern = 'alpha',
    command = [[set showtabline=0 laststatus=0 noruler]],
})

vim.api.nvim_create_autocmd('BufUnload', {
    group = 'alpha_tabline',
    pattern = '<buffer>',
    command = [[set showtabline=2 laststatus=3 ruler]],
})
