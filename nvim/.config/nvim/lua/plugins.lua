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
    use {'glepnir/dashboard-nvim', config = [[require('config.dashboard')]]}

    -- File explorer
    use {
        'kyazdani42/nvim-tree.lua',
        cmd = {'NvimTreeToggle', 'NvimTreeOpen', 'NvimTreeFindFile'},
        setup = [[require('plugin-setup.nvim-tree')]],
    }

    -- Completion and linting
    use {
        'glepnir/lspsaga.nvim',
        'kabouzeid/nvim-lspinstall',
        'neovim/nvim-lspconfig',
    }

    use {
        {
            'hrsh7th/nvim-compe',
            config = [[require('config.compe')]],
            event = [[InsertEnter *]],
        },
        {'hrsh7th/vim-vsnip', event = [[InsertEnter *]]},
        {'rafamadriz/friendly-snippets', event = [[InsertEnter *]]},
    }

    -- Indentation tracking
    use {
        'lukas-reineke/indent-blankline.nvim',
        branch = 'lua',
        setup = [[require('plugin-setup.indentline')]],
        event = [[VimEnter *]],
    }

    -- Highlights
    use {
        'nvim-treesitter/nvim-treesitter',
        config = [[require('config.treesitter')]],
        run = ':TSUpdate',
    }

    -- Comment
    use {
        'b3nj5m1n/kommentary',
        config = [[require('config.kommentary')]],
        keys = {'gc', {'v', 'gc'}},
    }

    -- Wrapping/delimiters
    use {
        {'machakann/vim-sandwich', event = [[BufEnter *]]},
        {
            'andymass/vim-matchup',
            setup = [[require('config.matchup')]],
            event = [[BufEnter *]],
        },
    }

    -- Multiline cursor
    use {
        'mg979/vim-visual-multi',
        branch = 'master',
        keys = {'<C-N>', '<C-Up>', '<C-Down>'},
    }

    -- Search
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
        config = [[require('config.telescope')]],
        setup = [[require('plugin-setup.telescope')]],
        cmd = {'Telescope'},
    }

    -- Git
    use {
        'kdheepak/lazygit.nvim',
        setup = [[require('config.lazygit_setup')]],
        cmd = 'LazyGit',
    }

    use {
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = [[require('config.gitsigns')]],
        event = [[VimEnter *]],
    }

    use {
        'pwntester/octo.nvim',
        config = [[require('config.octo')]],
        cmd = 'Octo',
    }

    -- Pretty symbols
    use 'kyazdani42/nvim-web-devicons'

    -- REPLs
    use {
        'hkupty/iron.nvim',
        setup = [[vim.g.iron_map_defaults = 0]],
        config = [[require('config.iron')]],
        cmd = {'IronRepl', 'IronSend', 'IronReplHere'},
    }

    -- Markdown
    use {'npxbr/glow.nvim', branch = 'main', cmd = 'Glow'}

    -- productivity
    use {
        'folke/todo-comments.nvim',
        config = [[require('config.todo-comments')]],
    }

    use {
        'folke/trouble.nvim',
        -- requires = 'kyazdani42/nvim-web-devicons',
        config = [[require('config.trouble')]],
        cmd = {'TroubleToggle', 'Trouble'},
        setup = [[require('plugin-setup.trouble')]],
    }

    use {
        'kdav5758/TrueZen.nvim',
        config = [[require('config.true_zen')]],
        setup = [[require('plugin-setup.truezen')]],
        cmd = {
            'TZMinimalist',
            'TZFocus',
            'TZAtaraxis',
            'TZBottom',
            'TZTop',
            'TZLeft',
        },
    }

    -- Highlight colors
    use {
        'norcalli/nvim-colorizer.lua',
        ft = {'css', 'scss', 'javascript', 'vue', 'vim', 'html', 'pug', 'lua'},
        config = [[require('config.colorizer')]],
    }

    -- Color scheme
    use {'sainnhe/gruvbox-material'}
    use {'folke/lsp-colors.nvim'}
end

-- init packer
return require('packer').startup(init)
