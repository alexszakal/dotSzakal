return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim",         -- required
        "sindrets/diffview.nvim",        -- optional - Diff integration

        -- Only one of these is needed.
        "nvim-telescope/telescope.nvim", -- optional
        --[[ "ibhagwan/fzf-lua",              -- optional ]]
        --[[ "echasnovski/mini.pick",         -- optional ]]
        --[[ "folke/snacks.nvim",             -- optional ]]
    },
    config = function()
        local status_ok, neogit = pcall(require, "neogit")
        if not status_ok then
            return
        end

        neogit.setup{
            integrations = {diffview = true}
        }

        -- KEYMAPS --
        vim.keymap.set('n', '<leader>ng', ":lua require('neogit').open()<CR>")
    end
}
