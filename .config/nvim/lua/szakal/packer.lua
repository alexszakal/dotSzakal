-- Ensure packer is installed
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    print(fn.stdpath('data'))
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
 end

local packer_bootstrap = ensure_packer()

-- List of packages to be installed
return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Telescope fuzzy finder
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- Rose-pine colorscheme
    use({ 'rose-pine/neovim', as = 'rose-pine' })

    -- Trouble
--    use({
--        "folke/trouble.nvim",
--        config = function()
--            require("trouble").setup {
--                icons = false,
--                -- your configuration comes here
--                -- or leave it empty to use the default settings
--                -- refer to the configuration section below
--            }
--        end
--    })

    --Treesitter 
    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use("nvim-treesitter/nvim-treesitter-context"); -- context.vim alternative
    use('HiPhish/nvim-ts-rainbow2') --Rainbow parentheses
    --Harpoon
    use('theprimeagen/harpoon')

    --Undotree
    use('mbbill/undotree')

    --Git Fugitive
    use('tpope/vim-fugitive')

    -- Packages for completion
    use('hrsh7th/nvim-cmp')        -- The completion plugin
         -- Completion Sources for nvim-cmp
    use('hrsh7th/cmp-nvim-lsp')    -- LSP completions for cmp
    use('hrsh7th/cmp-buffer')      -- Buffer completion source
    use('hrsh7th/cmp-path')        -- Path completion source
    use('hrsh7th/cmp-cmdline')     -- Commandline completion source
    use('hrsh7th/cmp-nvim-lua')    -- Nvim specific lua completion source
        --Snippets source for nvim-cmp
    use('L3MON4D3/LuaSnip')             -- Snippet engine
    use('rafamadriz/friendly-snippets') -- A bunch of snippets to use

    use "neovim/nvim-lspconfig" -- enable LSP
    use "williamboman/mason.nvim" -- simple to use language server installer
    use "williamboman/mason-lspconfig.nvim" -- simple to use language server installer

    use('ThePrimeagen/vim-be-good')

    if packer_bootstrap then
        require('packer').sync()
    end

end)

