vim.g.dashboard_custom_header = {
    ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
    ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
    ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
    ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
    ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
    ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
}

vim.g.indentLine_fileTypeExclude = {'dashboard'}
vim.g.dashboard_default_executive = 'telescope'

vim.g.dashboard_custom_section = {
    a = {
        description = {'  Workspace          '},
        command = 'Telescope file_browser',
    },
    b = {
        description = {'  Find File          '},
        command = 'Telescope find_files',
    },
    c = {
        description = {'  Search Text        '},
        command = 'Telescope live_grep',
    },
    d = {
        description = {'  Recently Used Files'},
        command = 'Telescope oldfiles',
    },
    e = {description = {'  Load Last Session  '}, command = 'SessionLoad'},
    f = {
        description = {'  Settings           '},
        command = ':e ~/.config/nvim/lua/settings.lua',
    },
    g = {
        description = {'  TODO               '},
        command = 'TodoTelescope',
    },
}

vim.g.dashboard_custom_footer = {'Do one thing, do it well - Unix philosophy'}

local utils = require('utils')
local map = utils.map

local opts = {noremap = false}
map('n', '<leader>ss', [[:<C-u>SessionSave<cr>]], opts)
map('n', '<leader>sl', [[:<C-u>SessionLoad<cr>]], opts)
