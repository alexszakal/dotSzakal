-- Pick the virtualenv for LSP + DAP without restarting nvim:  <leader>vs
-- Finds .venv/venv in the cwd, poetry/pipenv envs, hatch, conda and pyenv.
return {
    {
        "linux-cultist/venv-selector.nvim",
        branch = "regexp",
        dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
        cmd = { "VenvSelect", "VenvSelectCached" },
        opts = {
            settings = {
                options = {
                    notify_user_on_venv_activation = true,
                },
            },
        },
        keys = {
            { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select virtualenv" },
            { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Use last virtualenv for this cwd" },
        },
    },
}
