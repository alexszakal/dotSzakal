-- Fuzzy finder.
--
-- The keymaps live in `keys` rather than in `config` on purpose: other plugins
-- (neogit, venv-selector) list telescope as a dependency, which makes lazy.nvim
-- mark it `lazy = true`. A `config` function would then only run once one of
-- those plugins loaded it, so the mappings would silently go missing in every
-- profile that pulls telescope in indirectly. Entries in `keys` are registered
-- up front and load telescope on first use.
return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = "Telescope",
    keys = {
        { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find files" },
        { "<leader>g", "<cmd>Telescope git_files<cr>",  desc = "Find git-tracked files" },
        { "<C-t>",     "<cmd>Telescope live_grep<cr>",  desc = "Live grep in the project" },
    },
    config = function()
        local actions = require("telescope.actions")

        -- Workaround for a telescope bug: treesitter can not attach to the buffer
        -- because it opens too fast.
        -- https://github.com/nvim-treesitter/nvim-treesitter/issues/7952
        local open_after_tree = function(prompt_bufnr)
            vim.defer_fn(function()
                actions.select_default(prompt_bufnr)
            end, 100) -- delay allows filetype and plugins to settle before opening
        end

        require("telescope").setup({
            defaults = {
                mappings = {
                    i = { ["<CR>"] = open_after_tree },
                    n = { ["<CR>"] = open_after_tree },
                },
            },
        })
    end,
}
