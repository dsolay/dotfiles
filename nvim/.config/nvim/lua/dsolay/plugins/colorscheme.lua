return {
    "luisiacc/gruvbox-baby",
    enabled = false,
    branch = "main",
    lazy = false,
    priority = 1000,
    config = function()
        vim.g.gruvbox_baby_transparent_mode = 1

        -- Load the colorscheme
        vim.cmd([[colorscheme gruvbox-baby]])
    end,

    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                transparent_mode = true,
            })

            vim.o.background = "dark"
            vim.cmd("colorscheme gruvbox")
        end,
    },
}
