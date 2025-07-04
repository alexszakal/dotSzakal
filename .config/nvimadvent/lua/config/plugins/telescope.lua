return {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    -- or                              , tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config= function()
        opts = {noremap=true, silent=true}
        vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)
        -- keymap("n", "<leader>f", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
        vim.keymap.set("n", "<leader>g", "<cmd>Telescope git_files<cr>", opts)
        vim.keymap.set("n", "<C-t>",     "<cmd>Telescope live_grep<cr>", opts)
    end
}
