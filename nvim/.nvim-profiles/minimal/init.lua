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
    vim.api.nvim_command 'packadd packer.nvim'
end

-- Auto compile when there are changes in plugins.lua
-- cmd [[autocmd BufWritePost plugins.lua PackerCompile]]

-- packer startup function
local function init(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- File explorer
    use {
        'kyazdani42/nvim-tree.lua',
        config = function() require('nvim-tree').setup {} end,
    }

    -- LSP
    use {
        {
            'neovim/nvim-lspconfig',
            config = function()
                vim.diagnostic.config(
                    {virtual_text = {spacing = 4, source = true}}
                )

                local lsp_installer = require('nvim-lsp-installer')
                lsp_installer.on_server_ready(
                    function(server)
                        local opts = {
                            flags = {
                                -- This will be the default in neovim 0.7+
                                debounce_text_changes = 150,
                            },
                        }
                        server:setup(opts)
                    end
                )
            end,
        },
        {'williamboman/nvim-lsp-installer'},
    }

    use {
        {
            'nvim-telescope/telescope.nvim',
            requires = {{'nvim-lua/plenary.nvim'}},
            config = function()
                local telescope = require('telescope')

                telescope.setup {
                    defaults = {layout_strategy = 'flex'},
                    extensions = {
                        fzf = {
                            fuzzy = true,
                            override_generic_sorter = true,
                            override_file_sorter = true,
                            case_mode = 'smart_case',
                        },
                    },
                }

                telescope.load_extension('fzf')
            end,
        },
        {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'},
    }
end

-- init packer
return require('packer').startup(init)
