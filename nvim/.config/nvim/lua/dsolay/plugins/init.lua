local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

-- check if packer is already installed
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    vim.api.nvim_command("packadd packer.nvim")
end

-- Auto compile when there are changes in plugins.lua
vim.api.nvim_create_augroup("packer_user_config", {})
vim.api.nvim_create_autocmd("BufWritePost", {
    group = "packer_user_config",
    pattern = "**/lua/dsolay/plugins/init.lua",
    command = [[source <afile> | PackerCompile profile=true]],
})

-- Protected call to make sure that packer is installed
local status_ok, packer = pcall(require, "packer")

if not status_ok then
    return
end

-- packer startup function
local function init(use)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")

    -- theme
    use({
        "luisiacc/gruvbox-baby",
        branch = "main",
        config = function()
            require("dsolay.plugins.gruvboxbaby.config")
        end,
    })

    use("nvim-tree/nvim-web-devicons")

    -- Dashboard
    use({
        "goolord/alpha-nvim",
        config = function()
            require("dsolay.plugins.alpha.config")
        end,
    })

    -- File explorer
    use({
        "nvim-tree/nvim-tree.lua",
        config = function()
            require("dsolay.plugins.nvim-tree.config")
        end,
        setup = function()
            require("dsolay.plugins.nvim-tree.setup")
        end,
    })

    -- LSP
    use({
        "williamboman/mason.nvim",
        "jose-elias-alvarez/null-ls.nvim",
        {
            "williamboman/mason-lspconfig.nvim",
        },
        {
            "jayp0521/mason-null-ls.nvim",
            requires = { "nvim-lua/plenary.nvim" },
        },
        {
            "neovim/nvim-lspconfig",
            config = function()
                require("dsolay.plugins.lsp.config")
            end,
        },
    })

    -- sql
    use({ "tpope/vim-dadbod" })
    use({
        "kristijanhusak/vim-dadbod-ui",
        cmd = { "DBUI", "DBUIToggle" },
        config = function()
            require("dsolay.plugins.dadbodui.config")
        end,
        setup = function()
            require("dsolay.plugins.dadbodui.setup")
        end,
    })

    use({
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        setup = function()
            require("dsolay.plugins.markdown-preview.setup")
        end,
        ft = { "markdown" },
    })

    -- terminal
    use({
        "numtostr/FTerm.nvim",
        setup = function()
            require("dsolay.plugins.fterm.setup")
        end,
    })

    -- Pretty symbols
    use({
        "onsails/lspkind-nvim",
        config = function()
            require("dsolay.plugins.lspkind.config")
        end,
    })

    -- Completion and snnippets
    use({
        { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-cmdline" },
        { "hrsh7th/cmp-nvim-lua" },
        {
            "hrsh7th/nvim-cmp",
            config = function()
                require("dsolay.plugins.cmp.config")
            end,
        },
        {
            "L3MON4D3/LuaSnip",
            config = function()
                require("dsolay.plugins.luasnip.config")
            end,
        },
        { "saadparwaiz1/cmp_luasnip" },
        { "rafamadriz/friendly-snippets" },
    })

    -- Indentation tracking
    use({
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("dsolay.plugins.indentline.config")
        end,
    })

    -- Highlights
    use({
        { "p00f/nvim-ts-rainbow" },
        {
            "nvim-treesitter/nvim-treesitter",
            config = function()
                require("dsolay.plugins.treesitter.config")
            end,
            run = function()
                require("nvim-treesitter.install").update({ with_sync = true })
            end,
        },
    })

    use({
        "norcalli/nvim-colorizer.lua",
        ft = { "css", "scss", "javascript", "vue", "vim", "html", "pug", "lua" },
        config = function()
            require("dsolay.plugins.colorizer.confing")
        end,
    })

    -- Comment
    use({
        { "JoosepAlviste/nvim-ts-context-commentstring" },
        {
            "echasnovski/mini.comment",
            config = function()
                require("dsolay.plugins.mini.comment.config")
            end,
        },
    })

    -- Search
    use({
        {
            "nvim-telescope/telescope.nvim",
            requires = { { "nvim-lua/plenary.nvim" } },
            config = function()
                require("dsolay.plugins.telescope.config")
            end,
            setup = function()
                require("dsolay.plugins.telescope.setup")
            end,
            cmd = { "Telescope" },
        },
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
        { "nvim-telescope/telescope-project.nvim" },
    })

    -- Git
    use({
        "kdheepak/lazygit.nvim",
        setup = function()
            require("dsolay.plugins.lazygit.setup")
        end,
        cmd = "LazyGit",
    })

    use({
        "lewis6991/gitsigns.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("dsolay.plugins.gitsigns.config")
        end,
    })

    -- Docstrings
    use({
        "kkoomen/vim-doge",
        config = function()
            require("dsolay.plugins.doge.config")
        end,
        setup = function()
            require("dsolay.plugins.doge.setup")
        end,
        run = ":call doge#install()",
    })

    -- Debug
    use({
        {
            "mfussenegger/nvim-dap",
            config = function()
                require("dsolay.plugins.dap.config")
            end,
            setup = function()
                require("dsolay.plugins.dap.setup")
            end,
        },
        {
            "rcarriga/nvim-dap-ui",
            requires = { "mfussenegger/nvim-dap" },
            config = function()
                require("dsolay.plugins.dap-ui.config")
            end,
            setup = function()
                require("dsolay.plugins.dap-ui.setup")
            end,
        },
        {
            "Pocco81/DAPInstall.nvim",
            cmd = { "DIInstall", "DIUninstall", "DIList" },
        },
    })

    use({ "mxsdev/nvim-dap-vscode-js" })
    use({
        "microsoft/vscode-js-debug",
        opt = true,
        run = "npm install --legacy-peer-deps && npx gulp dapDebugServer && mv dist out",
    })

    -- productivity
    use({
        "echasnovski/mini.surround",
        config = function()
            require("dsolay.plugins.mini.surround.config")
        end,
    })

    use({
        "echasnovski/mini.pairs",
        config = function()
            require("dsolay.plugins.mini.pairs.config")
        end,
    })

    use({
        "folke/todo-comments.nvim",
        config = function()
            require("dsolay.plugins.todo-comments.config")
        end,
    })

    use({
        "folke/trouble.nvim",
        config = function()
            require("dsolay.plugins.trouble.config")
        end,
        setup = function()
            require("dsolay.plugins.trouble.setup")
        end,
        cmd = { "TroubleToggle", "Trouble" },
    })

    use({
        "mg979/vim-visual-multi",
        branch = "master",
    })

    use({
        "hkupty/iron.nvim",
        config = function()
            require("dsolay.plugins.iron.config")
        end,
        setup = function()
            require("dsolay.plugins.iron.setup")
        end,
        cmd = { "IronRepl", "IronSend", "IronReplHere" },
    })

    -- Utilities
    use({ "tpope/vim-unimpaired" })

    use({ "tpope/vim-dotenv" })

    use({
        "folke/twilight.nvim",
        cmd = { "Twilight", "TwilightEnable" },
        config = function()
            require("dsolay.plugins.twilight.config")
        end,
    })

    use({
        "kdav5758/TrueZen.nvim",
        after = "twilight.nvim",
        config = function()
            require("dsolay.plugins.truzen.config")
        end,
        setup = function()
            require("dsolay.plugins.truzen.setup")
        end,
        cmd = {
            "TZMinimalist",
            "TZFocus",
            "TZAtaraxis",
            "TZBottom",
            "TZTop",
            "TZLeft",
        },
    })

    -- Automatically set up the configuration after cloning packer.nvim
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end

-- init packer
return packer.startup(init)
