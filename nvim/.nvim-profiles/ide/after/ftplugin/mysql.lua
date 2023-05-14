local status, cmp = pcall(require, "cmp")

if not status then
    return
end

cmp.setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
vim.opt.filetype = "sql"
