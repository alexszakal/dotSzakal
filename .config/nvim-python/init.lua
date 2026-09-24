-- Python profile.  Start with:  pvim   (NVIM_APPNAME=nvim-python nvim)
--
-- Builds on the core config in ~/.config/nvim: all shared options, keymaps and
-- core/plugins/ come from there, plus the shared development layer core/dev/
-- (mason, LSP, blink.cmp, treesitter, git, nvim-tree, DAP).

local core_root = vim.fn.expand("~/.config/nvim")
vim.opt.runtimepath:append(core_root)
package.path = table.concat({
    package.path,
    core_root .. "/lua/?.lua",
    core_root .. "/lua/?/init.lua",
}, ";")

require("core").setup({
    parsers = { "python", "toml", "json", "yaml", "rst", "bash", "ninja" },

    -- Installed automatically on first start by mason-tool-installer
    tools = { "basedpyright", "ruff" },

    servers = {
        basedpyright = {
            settings = {
                basedpyright = {
                    analysis = {
                        typeCheckingMode = "standard", -- "off"|"basic"|"standard"|"strict"|"recommended"|"all"
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticSeverityOverrides = {
                            -- ruff reports these already
                            reportUnusedImport = "none",
                            reportUnusedVariable = "none",
                        },
                    },
                },
            },
        },
        -- Linting + formatting + import sorting
        ruff = {
            init_options = {
                settings = { lineLength = 100 },
            },
        },
    },

    dap = { "debugpy" },

    spec = {
        { import = "core.dev" },       -- shared dev layer
        { import = "python.plugins" }, -- Python only
    },
})

require("python.options")
