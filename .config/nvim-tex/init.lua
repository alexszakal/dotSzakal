-- LaTeX profile.  Start with:  lvim   (NVIM_APPNAME=nvim-tex nvim)
--
-- Builds on the core config in ~/.config/nvim: all shared options, keymaps and
-- core/plugins/ come from there, plus the shared development layer core/dev/.
-- No DAP here (`dap` is left unset), so no debug adapters are downloaded.
--
-- VimTeX owns <localleader> (backslash by default): \ll compile, \lv view,
-- \lc clean, \lt table of contents, \le errors.

local core_root = vim.fn.expand("~/.config/nvim")
vim.opt.runtimepath:append(core_root)
package.path = table.concat({
    package.path,
    core_root .. "/lua/?.lua",
    core_root .. "/lua/?/init.lua",
}, ";")

require("core").setup({
    -- NOTE: the "latex" parser is deliberately absent. On nvim 0.12 it has to be
    -- regenerated with the tree-sitter CLI (not installed), and VimTeX's own syntax
    -- engine is both richer and what upstream recommends for LaTeX anyway.
    parsers = { "bibtex" },

    -- Installed automatically on first start by mason-tool-installer
    tools = { "texlab" },

    servers = {
        texlab = {
            settings = {
                texlab = {
                    build = { onSave = false }, -- VimTeX drives latexmk instead
                    forwardSearch = { executable = "zathura", args = { "--synctex-forward", "%l:1:%f", "%p" } },
                    chktex = { onOpenAndSave = true, onEdit = false },
                    diagnosticsDelay = 300,
                },
            },
        },
    },

    spec = {
        { import = "core.dev" },    -- shared dev layer
        { import = "tex.plugins" }, -- VimTeX, snippets, prose helpers
    },
})

require("tex.options")
