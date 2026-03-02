vim.g.mapleader = [[,]]

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

local home = os.getenv('HOME')
vim.env.PYENV_VERSION = vim.fn.system('pyenv version'):match('(%S+)%s+%(.-%)')
vim.g.python3_host_prog = home .. "/.anyenv/envs/pyenv/shims/python3"

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.conceallevel = 2
vim.wo.concealcursor = "nc"
vim.wo.list = true
vim.wo.signcolumn = "yes:1"
vim.wo.colorcolumn = ""
vim.wo.linebreak = true
vim.wo.wrap = true
vim.wo.breakindent = true
vim.wo.cursorline = true

vim.opt.textwidth = 80
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.undofile = true
vim.opt.synmaxcol = 500
vim.opt.modeline = false
vim.opt.autoindent = true

-- vim.opt.syntax = 'off'
vim.opt.scrolloff = 4
vim.opt.sidescroll = 8
vim.opt.listchars = { tab = [[→\ ]], eol = "¬", nbsp = "␣", trail = "•", precedes = "«", extends = "»" }
vim.opt.wildignore:append({
    "**/node_modules/**",
    "**/dist/**",
    "**_site/**",
    "*.swp",
    "*.png",
    "*.jpg",
    "*.gif",
    "*.webp",
    "*.jpeg",
    "*.map",
    "*.o",
    "*~",
    "*.pyc",
})
vim.opt.wildmode:append({ "longest", "full" })
vim.opt.inccommand = "nosplit"
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.shada = [['20,<50,s10,h,/100]]
vim.opt.hidden = true
vim.opt.completeopt:append({ "menu", "menuone", "noselect" })
vim.opt.joinspaces = false
vim.opt.guicursor = { "n-v-c:block", "i-ci-ve:ver25", "r-cr:hor20", "o:hor50" }
vim.opt.updatetime = 300
vim.opt.display = "msgsep"
vim.opt.mouse = "nivh"
vim.opt.writebackup = false
vim.opt.fixendofline = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
vim.opt.foldtext = "v:lua.vim.lsp.foldtext()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.clipboard:append({ "unnamed", "unnamedplus" })
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.shiftround = true
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.lazyredraw = true
vim.opt.previewheight = 10

-- Use rigrep if installed
if vim.fn.executable("rg") == 1 then
    vim.opt.grepprg = "rg --vimgrep --smart-case --follow --no-heading"
    vim.opt.grepformat:append({ "%f:%l:%c:%m", "%f:%l:%m" })
end

vim.opt.exrc = true
vim.opt.secure = true
