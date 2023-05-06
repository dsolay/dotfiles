-- Highlight line only in current window
vim.api.nvim_create_augroup("CursorLine", {})

vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
    group = "CursorLine",
    pattern = "*",
    callback = function()
        vim.opt_local.cursorline = true
    end,
})

vim.api.nvim_create_autocmd("WinLeave", {
    group = "CursorLine",
    pattern = "*",
    callback = function()
        vim.opt_local.cursorline = false
    end,
})

-- Return to last edit position when opening files (You want this!)
vim.api.nvim_create_augroup("preserve_last_position", {})
vim.api.nvim_create_autocmd("BufReadPost", {
    group = "preserve_last_position",
    pattern = "*",
    callback = function()
        local last_pos = vim.fn.line("'\"")
        if last_pos > 0 and last_pos <= vim.fn.line("$") then
            vim.api.nvim_win_set_cursor(0, { last_pos, 0 })
        end
    end,
})
