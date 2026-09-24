# LaTeX profile (`lvim`)

Start it with `lvim` (`~/scripts/nvim/lvim`, which sets `NVIM_APPNAME=nvim-tex`).

This config layers on the core config in `~/.config/nvim`: every shared option
and text-editing keymap comes from `lua/core/`, so `jk`, `<C-h/j/k/l>`,
`<S-h>`/`<S-l>`, `<leader>y`, `<leader>d` and the rest behave exactly as they do
in plain `nvim`. What follows is only what this profile adds on top.

`<localleader>` is a **backslash** (`\`). VimTeX hangs almost everything off it.

---

## Quick start

```
lvim paper.tex     # open
\ll                # start latexmk in continuous mode — it now recompiles on every write
\lv                # open the PDF at the cursor's position (forward search)
\le                # jump to the error list if something breaks
\lk                # stop the compiler
```

Compilation is **continuous**: `\ll` toggles a latexmk daemon that watches the
file, so you press it once per session, not once per build. Aux files and the
PDF go to a `build/` subdirectory next to the document, keeping the source
directory clean.

---

## VimTeX — the core of the profile

VimTeX does compilation, viewer synchronisation, motions, text objects and
structural editing. `\li` shows what it thinks about the current project;
`\lm` lists the insert-mode math abbreviations.

### Compiling and viewing

| Key   | Action                                              |
|-------|-----------------------------------------------------|
| `\ll` | Toggle continuous compilation (latexmk)             |
| `\lo` | Show the compiler output                            |
| `\lk` | Stop compilation for this project (`\lK` for all)   |
| `\lv` | Forward search: jump the PDF viewer to the cursor   |
| `\lc` | Clean aux files (`\lC` also removes the PDF)        |
| `\le` | Open the error/warning list                         |
| `\lq` | Open the raw latexmk log                            |
| `\lt` | Table of contents (`\lT` toggles it)                |
| `\ls` | Toggle which file counts as the project's main file |
| `\lx` | Reload VimTeX after changing its configuration      |
| `\la` | Context menu for the thing under the cursor         |

The ToC (`\lt`) is a navigable outline of sections, `\todo` notes and
`\include`s — `<CR>` jumps to an entry, `q` closes it.

### Text objects

These work with every operator, so `cie` changes an environment's body, `dad`
deletes a delimiter pair with its contents, `vi$` selects inline math.

| Object      | Selects                                   |
|-------------|-------------------------------------------|
| `ie` / `ae` | Environment body / with `\begin`–`\end`   |
| `i$` / `a$` | Math zone, inner / with the delimiters    |
| `id` / `ad` | Delimiter pair, inner / with delimiters   |
| `ic` / `ac` | Command argument / the whole command      |
| `im` / `am` | Math group                                |
| `iP` / `aP` | Section, inner / whole                    |

### Structural editing

Change, delete or toggle the construct the cursor sits in, without selecting it:

| Key   | Action                                                    |
|-------|-----------------------------------------------------------|
| `cse` | Change the surrounding environment (prompts for the name) |
| `dse` | Delete the surrounding environment, keep its body         |
| `tse` | Toggle between `\[ \]` and an environment                 |
| `tss` | Toggle the environment's starred variant                  |
| `csc` | Change the command name under the cursor                  |
| `dsc` | Delete the command, keep its argument                     |
| `tsc` | Toggle the command's star (`\section` ↔ `\section*`)      |
| `tsf` | Toggle between `\frac{a}{b}` and `a/b`                    |
| `cs$` | Change the math environment                               |
| `ds$` | Delete the surrounding math                               |
| `csd` | Change the delimiter pair (e.g. `()` → `\left(\right)`)   |
| `dsd` | Delete the delimiter pair                                 |
| `tsd` | Toggle delimiter size modifiers (`(` ↔ `\left(`)          |
| `tsb` | Toggle a command onto its own line                        |

### Motions

`]]` / `[[` jump to the next/previous section start, `][` / `[]` to section
ends. `%` matches `\begin`/`\end` and `\left`/`\right`, not just brackets.

### Insert-mode math abbreviations

Inside a math zone, a backtick prefix expands Greek letters and symbols:
`` `a `` → `\alpha`, `` `b `` → `\beta`, `` `= `` → `\equiv`, and so on.
`\lm` prints the full list.

### Conceal

`conceallevel` is 2 in LaTeX buffers, so `\alpha` renders as `α`, `\ldots` as
`…`, and sub/superscripts shrink — the raw text reappears on the line the cursor
is on. Section commands are deliberately *not* concealed. Turn it off for a
buffer with `:setlocal conceallevel=0`.

---

## texlab — the language server

Installed automatically by mason on first start. It handles what VimTeX does not:

* **Diagnostics** from ChkTeX on open and save (not while typing).
* **Go to definition** on `\ref`/`\cite` (`gd`), and **references** (`gr`).
* **Rename** a label everywhere with `<leader>rn`.
* **Completion** of labels, citation keys, package and environment names.

The LSP keymaps are shared with the other dev profiles and come from
`~/.config/nvim/lua/core/dev/lsp.lua`: `gd`, `gD`, `gi`, `gr`, `K`,
`<leader>rn`, `<leader>ca`, `<leader>F` (format), `[d` / `]d` (diagnostics),
`gl` (show diagnostic), `<leader>q` (diagnostics to location list).

texlab's own build-on-save is **disabled** — latexmk under VimTeX owns
compilation, and running both would fight over the aux files.

> **Note:** `K` is LSP hover here, which shadows VimTeX's package-documentation
> lookup. Use `:VimtexDocPackage` when you want the package docs instead.

---

## Completion — blink.cmp with the VimTeX source

In `.tex` buffers the completion sources are, in priority order:
`vimtex`, `lsp`, `snippets`, `path`, `buffer`.

The VimTeX source (via `blink.compat` + `cmp-vimtex`) is what makes `\cite{`
offer the actual entries from your `.bib` files, with author and title visible in
the menu, and `\ref{` offer real labels from the document.

`<C-space>` opens the menu, `<C-y>` accepts, `<C-n>`/`<C-p>` move, `<C-e>`
dismisses. Signature help is on.

---

## Snippets — LuaSnip

`friendly-snippets` ships a LaTeX set out of the box (environments, `frac`,
sections, figures, tables).

| Key             | Mode          | Action                        |
|-----------------|---------------|-------------------------------|
| `<C-l>`         | insert/select | Expand, or jump to next field |
| `<C-h>`         | insert/select | Jump to the previous field    |

Autosnippets are enabled. Your own snippets go in
`~/.config/nvim-tex/snippets/*.lua` — that directory is loaded lazily, so a new
file is picked up on the next start. A minimal example:

```lua
-- ~/.config/nvim-tex/snippets/tex.lua
local ls = require("luasnip")
local s, t, i = ls.snippet, ls.text_node, ls.insert_node
return {
    s("fig", {
        t({ "\\begin{figure}[htbp]", "    \\centering", "    \\includegraphics[width=" }),
        i(1, "0.8"), t({ "\\linewidth]{" }), i(2, "path"), t({ "}", "    \\caption{" }),
        i(3, "caption"), t({ "}", "    \\label{fig:" }), i(4, "label"),
        t({ "}", "\\end{figure}" }),
    }),
}
```

---

## Writing helpers

| Key          | Action                                                      |
|--------------|-------------------------------------------------------------|
| `<leader>z`  | Zen mode — 90-column centred column, no line numbers        |
| `<leader>o`  | Outline sidebar (aerial), a symbol tree of the document     |
| `<leader>ts` | Toggle spell checking for this buffer                       |
| `<C-s>`      | *(insert mode)* fix the last spelling mistake and carry on  |
| `z=`         | Spelling suggestions for the word under the cursor          |
| `zg`         | Add the word under the cursor to the dictionary             |

### Spell checking

On by default in `tex`, `bib`, `markdown` and `text` buffers. `en_us` is always
active — Neovim bundles the English dictionary.

**Hungarian is opt-in.** No `hu` spell file ships with Neovim, and naming a
missing language makes Neovim prompt "Cannot find spell file for hu — download?"
on every buffer, so `lua/tex/options.lua` only adds `hu` once a `spell/hu*.spl`
file exists somewhere on the `runtimepath`. To add one, convert the hunspell
dictionary (`app-dicts/myspell-hu` on Gentoo, which installs into
`/usr/share/hunspell/`):

```vim
:!mkdir -p ~/.config/nvim-tex/spell
:mkspell ~/.config/nvim-tex/spell/hu /usr/share/hunspell/hu_HU
```

Restart `lvim` and `hu` is picked up automatically. Until then, `:setlocal
spelllang+=hu` in a single buffer will trigger the download prompt, which you
can decline.

### Prose-oriented buffer settings

Applied only to those filetypes, so code buffers keep the core defaults:

* soft `wrap` with `linebreak` and `breakindent` — lines break at word
  boundaries and wrapped text keeps its indent;
* `textwidth=0`, so nothing is ever hard-wrapped for you — paragraphs stay one
  logical line per sentence/paragraph and diffs stay readable;
* `j`/`k` move by *screen* line, `gj`/`gk` behaviour, unless you give a count
  (`5j` still moves 5 real lines, so relative numbers keep working);
* no colour column, and 2-space indentation.

---

## What comes from the shared layers

From `core/plugins/` (in every profile): rose-pine, mini.statusline,
bufferline, `<leader>c` to close a buffer, and telescope — `<leader>f` find
files, `<leader>g` git files, `<C-t>` live grep.

From `core/dev/`: mason, nvim-lspconfig, blink.cmp, treesitter, gitsigns,
neogit (`:Neogit`) and nvim-tree.

**No DAP here.** The debugger is gated on the profile declaring adapters, and
this one does not, so nothing debug-related is downloaded or loaded.

**No `latex` treesitter parser**, deliberately. On nvim 0.12 it has to be
regenerated with the tree-sitter CLI, which is not installed, and VimTeX's own
syntax engine is richer for LaTeX and is what upstream recommends. The `bibtex`
parser *is* installed and highlights `.bib` files.

---

## Setup

`texlab` installs itself on first start via mason. Nothing else is required —
`latexmk` is already at `/usr/bin/latexmk`.

**PDF viewer.** For SyncTeX forward search (`\lv`) and inverse search
(ctrl-click in the PDF jumps to the source line), install **zathura** with
`zathura-pdf-mupdf`. VimTeX detects it at startup; without it, it falls back to
plain `mupdf`, which can only reload the file — `\lv` will open the PDF but not
sync to the cursor.

---

## Changing things

| Want to change…                        | Edit                                            |
|----------------------------------------|-------------------------------------------------|
| latexmk flags, output dir, viewer      | `lua/tex/plugins/vimtex.lua`                    |
| wrap/spell/conceal behaviour           | `lua/tex/options.lua`                           |
| texlab settings, treesitter parsers    | `init.lua`                                      |
| zen-mode width, outline                | `lua/tex/plugins/writing.lua`                   |
| snippets                               | `snippets/*.lua`, or `lua/tex/plugins/snippets.lua` |
| anything shared with the other configs | `~/.config/nvim/lua/core/`                      |

Adding a keymap to `~/.config/nvim/lua/core/keymaps.lua` makes it available in
this profile and in `nvim`, `cvim` and `pvim` at the same time.
