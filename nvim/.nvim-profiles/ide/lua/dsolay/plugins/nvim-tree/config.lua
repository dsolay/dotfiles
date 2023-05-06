local status, tree = pcall(require, "nvim-tree")

if (not status) then
    return
end

tree.setup({
    disable_netrw = true,
    hijack_netrw = true,
    diagnostics = { enable = true },
    auto_reload_on_write = false,
    trash = {
        cmd = "trash-put",
        require_confirm = true,
    },
    git = { enable = true, ignore = false, timeout = 500 },
})
