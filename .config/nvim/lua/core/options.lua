-- General editor options. Shared by every profile (core, cpp, tex, python).
-- Profile-specific overrides belong in the profile's own options module.

vim.opt.backup = false                          -- creates a backup file
vim.opt.clipboard = "unnamedplus"               -- allows neovim to access the system clipboard
vim.opt.cmdheight = 2                           -- more space in the neovim command line for displaying messages
vim.opt.colorcolumn = "120"
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.conceallevel = 0                        -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file
vim.opt.hlsearch = true                         -- highlight all matches on previous search pattern
vim.opt.incsearch = true
vim.opt.ignorecase = true                       -- ignore case in search patterns
vim.opt.mouse = "a"                             -- allow the mouse to be used in neovim
vim.opt.pumheight = 10                          -- pop up menu height
vim.opt.showmode = true
vim.opt.showtabline = 2                         -- always show tabs
vim.opt.smartcase = true                        -- smart case
vim.opt.smartindent = true                      -- make indenting smarter again
vim.opt.splitbelow = true                       -- force all horizontal splits to go below current window
vim.opt.splitright = true                       -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false
vim.opt.termguicolors = true                    -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 1000                       -- time to wait for a mapped sequence to complete (ms)
vim.opt.undofile = true                         -- enable persistent undo
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.updatetime = 50                         -- faster completion (4000ms default)
vim.opt.writebackup = false
vim.opt.expandtab = true                        -- convert tabs to spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4                          -- number of spaces inserted for each indentation
vim.opt.cursorline = true                       -- highlight the current line
vim.opt.number = true                           -- set numbered lines
vim.opt.relativenumber = true                   -- set relative numbered lines
vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes"                      -- always show the sign column, avoids text shifting
vim.opt.wrap = false                            -- display lines as one long line
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 16
vim.opt.guifont = "monospace:h17"

vim.opt.shortmess:append "c"
vim.opt.isfname:append("@-@")

vim.cmd "set whichwrap+=<,>,[,],h,l"            -- keystrokes that allow linewrapping movements
vim.cmd [[set iskeyword+=-]]                    -- adds '-' to keywords
