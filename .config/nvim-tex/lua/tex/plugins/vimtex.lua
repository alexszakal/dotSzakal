-- VimTeX: compilation, PDF viewer sync, motions, text objects, ToC, error list.
-- Everything hangs off <localleader> (a backslash, set in core/init.lua):
--   \ll  toggle continuous compilation      \lv  forward search in the viewer
--   \lk  stop compilation                   \lc  clean aux files
--   \lt  table of contents                  \le  error/quickfix list
--   \li  VimTeX info                        \lm  list of insert-mode maps
return {
    {
        "lervag/vimtex",
        lazy = false,       -- VimTeX must be loaded before the first tex buffer opens
        init = function()
            -- latexmk is installed system wide (/usr/bin/latexmk)
            vim.g.vimtex_compiler_method = "latexmk"
            vim.g.vimtex_compiler_latexmk = {
                aux_dir = "build",
                out_dir = "build",
                callback = 1,
                continuous = 1,
                options = {
                    "-verbose",
                    "-file-line-error",
                    "-synctex=1",
                    "-interaction=nonstopmode",
                },
            }

            -- PDF viewer. zathura gives proper forward/inverse SyncTeX;
            -- mupdf (the one currently installed) can only be reloaded, not synced.
            if vim.fn.executable("zathura") == 1 then
                vim.g.vimtex_view_method = "zathura"
            else
                vim.g.vimtex_view_method = "general"
                vim.g.vimtex_view_general_viewer = "mupdf"
            end

            vim.g.vimtex_quickfix_mode = 2      -- open the quickfix window but keep the cursor
            vim.g.vimtex_quickfix_open_on_warning = 0
            vim.g.vimtex_mappings_enabled = 1
            vim.g.vimtex_indent_enabled = 1
            vim.g.vimtex_syntax_enabled = 1     -- conceal + math highlighting
            vim.g.vimtex_syntax_conceal = {
                accents = 1, ligatures = 1, cites = 1, fancy = 1,
                greek = 1, math_bounds = 1, math_delimiters = 1,
                math_fracs = 1, math_super_sub = 1, math_symbols = 1,
                sections = 0, styles = 1,
            }
            vim.g.vimtex_toc_config = {
                name = "TOC",
                layers = { "content", "todo", "include" },
                split_width = 40,
                show_help = 0,
            }

            -- Ignore warnings that are noise in practice
            vim.g.vimtex_quickfix_ignore_filters = {
                "Underfull \\\\hbox",
                "Overfull \\\\hbox",
                "LaTeX Warning: .\\+ float specifier changed to",
                "Package hyperref Warning: Token not allowed in a PDF string",
            }
        end,
    },
}
