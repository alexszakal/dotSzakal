-- Jupyter notebooks as plain buffers: .ipynb is converted on open and on write.
-- Requires jupytext (pip install jupytext); the plugin is a no-op without it.
return {
    {
        "GCBallesteros/jupytext.nvim",
        lazy = false,
        enabled = function()
            return vim.fn.executable("jupytext") == 1
        end,
        opts = {
            style = "percent",
            output_extension = "py",
            force_ft = "python",
        },
    },
}
