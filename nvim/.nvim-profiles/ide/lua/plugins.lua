local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

-- check if packer is already installed
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system(
        {
            'git',
            'clone',
            'https://github.com/wbthomason/packer.nvim',
            install_path,
        }
    )
    execute 'packadd packer.nvim'
end

-- Auto compile when there are changes in plugins.lua
-- cmd [[autocmd BufWritePost plugins.lua PackerCompile]]

-- packer startup function
local function init(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Dashboard
    use {
        'goolord/alpha-nvim',
        requires = {'kyazdani42/nvim-web-devicons'},
        config = function() require('config.alpha_conf') end,
    }

    -- File explorer
    use {
        'kyazdani42/nvim-tree.lua',
        config = function() require('config.nvimtree_conf') end,
        setup = function() require('setup.nvimtree_setup') end,
    }

    -- terminal
    use {
        'numtostr/FTerm.nvim',
        setup = function() require('setup.fterm_setup') end,
    }

    -- LSP
    use {
        {
            'neovim/nvim-lspconfig',
            config = function() require('config.lsp_conf') end,
        },
        'williamboman/nvim-lsp-installer',
    }

    use {'jose-elias-alvarez/nvim-lsp-ts-utils'}

    -- sql
    use {'tpope/vim-dadbod'}
    use {
        'kristijanhusak/vim-dadbod-ui',
        cmd = {'DBUI', 'DBUIToggle'},
        config = function() require('config.dadbodui_conf') end,
        setup = function() require('setup.dadbodui_setup') end,
    }

    -- Pretty symbols
    use 'kyazdani42/nvim-web-devicons'

    use {
        'onsails/lspkind-nvim',
        config = function() require('config.lspkind_conf') end,
    }

    -- Completion and snnippets
    use {
        {'kristijanhusak/vim-dadbod-completion', ft = {'sql', 'mysql', 'plsql'}},
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/cmp-buffer'},
        {'hrsh7th/cmp-path'},
        {'hrsh7th/cmp-cmdline'},
        {'hrsh7th/cmp-nvim-lua'},
        {
            'hrsh7th/nvim-cmp',
            config = function() require('config.compe_conf') end,
        },
        {
            'L3MON4D3/LuaSnip',
            config = function() require('config.luasnip_conf') end,
        },
        {'saadparwaiz1/cmp_luasnip'},
        {'rafamadriz/friendly-snippets'},
    }

    -- Debug
    use {
        {
            'mfussenegger/nvim-dap',
            config = function() require('config.dap_conf') end,
            setup = function() require('setup.dap_setup') end,
        },
        {
            'rcarriga/nvim-dap-ui',
            requires = {'mfussenegger/nvim-dap'},
            config = function() require('config.dapui_conf') end,
            setup = function() require('setup.dapui_setup') end,
        },
        {
            'Pocco81/DAPInstall.nvim',
            cmd = {'DIInstall', 'DIUninstall', 'DIList'},
        },
    }

    -- Indentation tracking
    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function() require('config.indentline_conf') end,
    }

    -- Highlights
    use {
        {
            'nvim-treesitter/nvim-treesitter',
            config = function() require('config.treesitter_conf') end,
            run = ':TSUpdate',
        },
        {'p00f/nvim-ts-rainbow'},
    }

    -- Comment
    use {
        'b3nj5m1n/kommentary',
        config = function() require('config.kommentary_conf') end,
    }

    use {'JoosepAlviste/nvim-ts-context-commentstring'}

    -- Docs
    use {
        'kkoomen/vim-doge',
        config = function() require('config.doge_conf') end,
        setup = function() require('setup.doge_setup') end,
        run = ':call doge#install()',
    }

    -- Multiline cursor
    use {
        'mg979/vim-visual-multi',
        branch = 'master',
        keys = {'<C-N>', '<C-Up>', '<C-Down>'},
    }

    -- Search
    use {
        {
            'nvim-telescope/telescope.nvim',
            requires = {{'nvim-lua/plenary.nvim'}},
            config = function() require('config.telescope_conf') end,
            setup = function() require('setup.telescope_setup') end,
            cmd = {'Telescope'},
        },
        {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'},
        {'nvim-telescope/telescope-project.nvim'},
    }

    -- Git
    use {
        'kdheepak/lazygit.nvim',
        setup = function() require('setup.lazygit_setup') end,
        cmd = 'LazyGit',
    }

    use {
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = function() require('config.gitsigns_conf') end,
    }

    use {
        'pwntester/octo.nvim',
        config = function() require('config.octo_conf') end,
        cmd = 'Octo',
    }

    -- REPLs
    use {
        'hkupty/iron.nvim',
        config = function() require('config.iron_conf') end,
        setup = function() require('setup.iron_setup') end,
        cmd = {'IronRepl', 'IronSend', 'IronReplHere'},
    }

    -- Markdown
    use {'npxbr/glow.nvim', branch = 'main', cmd = 'Glow'}

    -- productivity
    use {
        'echasnovski/mini.nvim',
        branch = 'stable',
        config = function() require('config.mini_conf') end,
    }

    use {
        'folke/todo-comments.nvim',
        config = function() require('config.todocomments_conf') end,
    }

    use {
        'folke/trouble.nvim',
        config = function() require('config.trouble_conf') end,
        setup = function() require('setup.trouble_setup') end,
        cmd = {'TroubleToggle', 'Trouble'},
    }

    use {
        'folke/twilight.nvim',
        cmd = {'Twilight', 'TwilightEnable'},
        config = function() require('config.twilight_conf') end,
    }

    use {
        'kdav5758/TrueZen.nvim',
        after = 'twilight.nvim',
        config = function() require('config.truezen_conf') end,
        setup = function() require('setup.truezen_setup') end,
        cmd = {
            'TZMinimalist',
            'TZFocus',
            'TZAtaraxis',
            'TZBottom',
            'TZTop',
            'TZLeft',
        },
    }

    use {'tpope/vim-unimpaired'}

    use {'tpope/vim-dotenv'}

    -- Highlight colors
    use {
        'norcalli/nvim-colorizer.lua',
        ft = {'css', 'scss', 'javascript', 'vue', 'vim', 'html', 'pug', 'lua'},
        config = function() require('config.colorizer_conf') end,
    }

    -- Color scheme
    use {
        'luisiacc/gruvbox-baby',
        branch = 'main',
        config = function() require('config.gruvboxbaby_conf') end,
    }
end

-- init packer
return require('packer').startup(init)
