-- pytest from inside the editor, with DAP integration for debugging a single test.
--   <leader>tt  run nearest test      <leader>tf  run the whole file
--   <leader>ts  toggle the summary    <leader>td  debug nearest test
return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-neotest/nvim-nio",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-python",
        },
        cmd = "Neotest",
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-python")({
                        dap = { justMyCode = false },
                        runner = "pytest",
                    }),
                },
            })
        end,
        keys = {
            { "<leader>tt", function() require("neotest").run.run() end, desc = "Run nearest test" },
            { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run tests in file" },
            { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle test summary" },
            { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Show test output" },
            { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
        },
    },
}
