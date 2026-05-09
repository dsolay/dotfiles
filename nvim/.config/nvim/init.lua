local utils = require("dsolay.utils")
utils.enable_lsp_servers()

require("dsolay.config.autocmds")
require("dsolay.config.options")
require("dsolay.config.lazy")
require("dsolay.config.keymaps")

vim.o.background = utils.read_theme_mode()
vim.cmd("colorscheme gruvbox")
