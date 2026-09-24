-- Prose-oriented settings, applied to LaTeX/markdown/text buffers only, so the
-- core defaults (no wrap, no spell) stay intact for everything else.

-- English ships with Neovim. Hungarian does not: adding "hu" unconditionally
-- makes Neovim prompt "Cannot find spell file for hu - download?" on every
-- buffer, so only enable it once a hu spell file is actually present.
-- To add one:  see the Spell checking section of README.md
local spelllang = { "en_us" }
if #vim.fn.globpath(vim.o.runtimepath, "spell/hu*.spl", false, true) > 0 then
    table.insert(spelllang, "hu")
end
vim.opt.spelllang = spelllang

vim.api.nvim_create_autocmd("FileType", {
    desc = "Prose editing: soft wrap, spell check, wrap-aware motions",
    group = vim.api.nvim_create_augroup("tex-prose", { clear = true }),
    pattern = { "tex", "plaintex", "bib", "markdown", "text" },
    callback = function(args)
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true       -- break at word boundaries, not mid-word
        vim.opt_local.breakindent = true
        vim.opt_local.spell = true
        vim.opt_local.conceallevel = 2       -- VimTeX renders \alpha, \ldots inline
        vim.opt_local.textwidth = 0          -- soft wrap only, do not hard-break lines
        vim.opt_local.colorcolumn = ""
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2

        -- j/k move by screen line when the text is wrapped
        local opts = { buffer = args.buf, silent = true }
        vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", vim.tbl_extend("force", opts, { expr = true }))
        vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", vim.tbl_extend("force", opts, { expr = true }))
        vim.keymap.set("n", "<Down>", "gj", opts)
        vim.keymap.set("n", "<Up>", "gk", opts)

        -- Fix the last spelling mistake without leaving insert mode
        vim.keymap.set("i", "<C-s>", "<c-g>u<Esc>[s1z=`]a<c-g>u", opts)
        -- Toggle spell checking
        vim.keymap.set("n", "<leader>ts", function()
            vim.opt_local.spell = not vim.opt_local.spell:get()
        end, vim.tbl_extend("force", opts, { desc = "Toggle spell check" }))
    end,
})
