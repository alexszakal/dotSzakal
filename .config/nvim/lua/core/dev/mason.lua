-- mason.nvim manages LSP servers, formatters, linters and debug adapters.
--
-- Each profile declares what it needs in the `tools` field of
-- require("core").setup{}; mason-tool-installer installs anything missing on
-- startup and never touches tools you installed by hand with :Mason.
--
-- Useful commands:  :Mason            browse / install / update interactively
--                   :MasonToolsUpdate update everything this profile declared
--                   :MasonToolsInstall re-run the install pass now
return {
    {
        "mason-org/mason.nvim",
        opts = {},
    },

    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "mason-org/mason.nvim" },
        enabled = function()
            return #(require("core").opts.tools or {}) > 0
        end,
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = require("core").opts.tools,
                run_on_start = true,
                start_delay = 2000,    -- let the UI settle before downloading
                debounce_hours = 24,   -- check for updates at most once a day
                auto_update = false,   -- update on demand with :MasonToolsUpdate
            })
        end,
    },
}
