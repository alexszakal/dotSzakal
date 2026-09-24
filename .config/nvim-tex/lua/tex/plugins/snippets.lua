-- LuaSnip + a LaTeX snippet set, wired into blink.cmp (which core/dev provides).
-- friendly-snippets ships environments/frac/sections for tex out of the box.
return {
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            local luasnip = require("luasnip")
            require("luasnip.loaders.from_vscode").lazy_load()
            -- Drop your own snippets in ~/.config/nvim-tex/snippets/*.lua
            require("luasnip.loaders.from_lua").lazy_load({
                paths = { vim.fn.stdpath("config") .. "/snippets" },
            })

            luasnip.config.setup({
                history = true,
                updateevents = "TextChanged,TextChangedI",
                enable_autosnippets = true,
            })

            vim.keymap.set({ "i", "s" }, "<C-l>", function()
                if luasnip.expand_or_jumpable() then luasnip.expand_or_jump() end
            end, { silent = true, desc = "Expand snippet / jump forward" })
            vim.keymap.set({ "i", "s" }, "<C-h>", function()
                if luasnip.jumpable(-1) then luasnip.jump(-1) end
            end, { silent = true, desc = "Jump backward in snippet" })
        end,
    },

    -- Tell blink.cmp to use LuaSnip and to offer VimTeX's citation/label completions
    {
        "saghen/blink.cmp",
        optional = true,
        opts = {
            snippets = { preset = "luasnip" },
            sources = {
                per_filetype = {
                    tex = { "vimtex", "lsp", "snippets", "path", "buffer" },
                },
                providers = {
                    vimtex = { name = "vimtex", module = "blink.compat.source", score_offset = 100 },
                },
            },
        },
        dependencies = {
            { "saghen/blink.compat", version = "*", opts = {} },
            "micangl/cmp-vimtex",
        },
    },
}
