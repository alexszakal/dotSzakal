-- Quality-of-life plugins for long-form writing.
return {
    -- Distraction free drafting: <leader>z
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        opts = {
            window = { width = 90, options = { number = false, relativenumber = false } },
        },
        keys = {
            { "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen mode" },
        },
    },

    -- Table of contents / symbol outline for sections, also works for code
    {
        "stevearc/aerial.nvim",
        cmd = { "AerialToggle" },
        opts = { layout = { min_width = 30 } },
        keys = {
            { "<leader>o", "<cmd>AerialToggle!<cr>", desc = "Toggle outline" },
        },
    },
}
