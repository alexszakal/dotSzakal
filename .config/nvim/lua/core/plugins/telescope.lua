local actions = require("telescope.actions")

local open_after_tree = function(prompt_bufnr)
  vim.defer_fn(function()
    actions.select_default(prompt_bufnr)
  end, 100)-- Delay allows filetype and plugins to settle before opening
end

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

        -- Workaround for a telescope bug: Treesitter can not attach to the buffer because it opens too fast
        -- https://github.com/nvim-treesitter/nvim-treesitter/issues/7952
        require("telescope").setup({
            defaults = {
                mappings = {
                    i = { ["<CR>"] = open_after_tree },
                    n = { ["<CR>"] = open_after_tree },
                },
            },
        })
    end
}
