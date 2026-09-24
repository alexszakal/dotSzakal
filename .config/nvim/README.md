# Neovim profiles

Four configurations. The **core** config is the base; the other three layer on top of it.

| Command | `NVIM_APPNAME` | Config directory        | Purpose                  |
|---------|----------------|-------------------------|--------------------------|
| `nvim`  | *(unset)*      | `~/.config/nvim`        | general text editing     |
| `cvim`  | `nvim-cpp`     | `~/.config/nvim-cpp`    | C++ / CUDA (MRC_SDK)     |
| `lvim`  | `nvim-tex`     | `~/.config/nvim-tex`    | LaTeX                    |
| `pvim`  | `nvim-python`  | `~/.config/nvim-python` | Python                   |

Starter scripts live in `~/scripts/nvim/`. Add that directory to `PATH`:

```sh
export PATH="$HOME/scripts/nvim:$PATH"
```

## How the layering works

Each profile's `init.lua` appends `~/.config/nvim` to the `runtimepath` and to
`package.path`, then calls `require("core").setup{...}`. So **anything added to
`~/.config/nvim/lua/core/` is immediately live in all four configs** — a new
keymap in `core/keymaps.lua` needs no change anywhere else.

`NVIM_APPNAME` also redirects `stdpath("data")`, `stdpath("state")` and
`stdpath("cache")`, so every profile has its own plugin tree and its own
`lazy-lock.json`. Running `:Lazy sync` in one profile can never touch another's.

```
~/.config/nvim/                     CORE — loaded by every profile
├── init.lua                        require("core").setup({})
├── lua/core/
│   ├── init.lua                    setup(), leaders, the shared opts table
│   ├── lazy.lua                    lazy.nvim bootstrap + spec assembly
│   ├── options.lua                 shared editor options          <-- edit here
│   ├── keymaps.lua                 shared text editing keymaps    <-- edit here
│   ├── plugins/                    ALWAYS loaded, every profile
│   │   ├── colorscheme.lua         rose-pine
│   │   ├── mini.lua                mini.statusline
│   │   ├── bufferline.lua          buffer tabs
│   │   ├── bufdelete.lua           <leader>c
│   │   └── telescope.lua           <leader>f / <leader>g / <C-t>
│   └── dev/                        shared DEV layer, imported by cpp/tex/python only
│       ├── mason.lua               :Mason — installs servers and debuggers
│       ├── lsp.lua                 capabilities, keymaps, enables opts.servers
│       ├── blinkCmp.lua            completion
│       ├── treesitter.lua          base parsers + opts.parsers
│       ├── gitsigns.lua  neogit.lua  nvimTree.lua
│       └── dap.lua                 only enabled when opts.dap is non-empty
│
├── ~/.config/nvim-cpp/lua/cpp/     clangd config, MRC_SDK style, rainbow delimiters
├── ~/.config/nvim-tex/lua/tex/     VimTeX, texlab, LuaSnip, prose options, zen-mode
└── ~/.config/nvim-python/lua/python/  basedpyright+ruff, venv-selector, neotest, jupytext
```

## Adding things

* **A keymap or option for everything** → `lua/core/keymaps.lua` / `lua/core/options.lua`.
* **A plugin for everything** → a new file in `lua/core/plugins/`.
* **A plugin for all three dev profiles** → a new file in `lua/core/dev/`.
* **A plugin for one profile** → `~/.config/nvim-<p>/lua/<p>/plugins/`.
* **An LSP server / treesitter parser / debug adapter for one profile** → the
  `servers` / `parsers` / `dap` fields of that profile's `require("core").setup{}` call.

## Tooling

Language servers and debuggers install themselves on first start. Each profile
lists its mason packages in the `tools` field of `require("core").setup{}`;
`mason-tool-installer` installs whatever is missing 2s after startup and then
re-checks at most once a day.

| Profile | Auto-installed                                        | From the system |
|---------|-------------------------------------------------------|-----------------|
| `cvim`  | `clangd`, `clang-format`, `codelldb`                  | —               |
| `lvim`  | `texlab`                                              | `latexmk`       |
| `pvim`  | `basedpyright`, `ruff`, `debugpy`                     | —               |

`cvim` uses the mason builds of clangd (23.1.0) and clang-format (23.1.1), which
are well ahead of the system LLVM packages (`/usr/bin/clangd` 19.1.7,
`clang-format` 18.1.8). mason prepends its `bin/` to `PATH`, so the bare
`"clangd"` in the server config resolves to the mason build automatically.

If clangd 23 ever disagrees with the compiler MRC_SDK is built with (MSVC v194 /
system GCC), drop `"clangd"` from `tools` in `~/.config/nvim-cpp/init.lua` and
point `cmd` at `/usr/bin/clangd` to go back to the system version.

Commands: `:Mason` to browse/install interactively, `:MasonToolsUpdate` to update
this profile's declared tools, `:MasonToolsInstall` to re-run the install pass.

Two optional extras, neither required:

* `lvim` — install **zathura** with `zathura-pdf-mupdf` for SyncTeX forward and
  inverse search. VimTeX detects it at startup and otherwise falls back to plain
  `mupdf` (reload only, no sync).
* `pvim` — `pip install jupytext` enables editing `.ipynb` files as plain Python.

The previous single config is backed up at `~/.config/nvim.bak-20260924`.
