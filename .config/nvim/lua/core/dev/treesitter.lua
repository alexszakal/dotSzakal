-- Neovim already has the treesitter engine built in.
-- Nvim treesitter ships the constantly maintained parsers, queries and match them.
--
-- The base parser list below is shared; the active profile adds its own languages
-- through the `parsers` field of require("core").setup{}.
return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate", -- TSUpdate command has to be called after package update by Lazy
        branch = "master",
        config = function()
            local parsers = { "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" }
            vim.list_extend(parsers, require("core").opts.parsers or {})

            require('nvim-treesitter.configs').setup {
                ensure_installed = parsers,
                auto_install = false,
                highlight = {
                    enable = true,

                    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
                    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
                    -- the name of the parser)
                    -- Disable slow treesitter highlight for large files
                    disable = function(lang, buf)
                        local max_filesize = 100 * 1024 -- 100 KB
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end
                    end,

                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    additional_vim_regex_highlighting = false,
                },
            }
        end,
    }
}
