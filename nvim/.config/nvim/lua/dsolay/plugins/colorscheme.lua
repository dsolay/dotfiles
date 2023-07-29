return {
    "luisiacc/gruvbox-baby",
    branch = "main",
    lazy = false,
    priority = 1000,
    config = function()
        vim.g.gruvbox_baby_transparent_mode = 1

        -- Load the colorscheme
        vim.cmd([[colorscheme gruvbox-baby]])

        vim.cmd([[highlight ColorColumn ctermbg=0 guibg=#32302F]])
    end,
}
