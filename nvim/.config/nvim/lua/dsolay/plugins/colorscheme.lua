return {
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            local utils = require("dsolay.utils")
            require("gruvbox").setup({
                transparent_mode = true,
            })

            local theme_file = "$HOME/.config/alacritty/themes/theme.toml"
            local absolute_path = utils.get_absolute_path(theme_file)
            local current_theme = utils.get_basename(absolute_path)
            local mode = "dark"

            if current_theme == "gruvbox_light.toml" then
                mode = "light"
            end

            vim.o.background = mode
            vim.cmd("colorscheme gruvbox")
        end,
    },
}
