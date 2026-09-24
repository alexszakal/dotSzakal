-- Custom text editing keymaps. Shared by every profile (core, cpp, tex, python).
-- Add a mapping here and all four configs pick it up.
--
-- NOTE: <leader> and <localleader> are set in core/init.lua, before this runs.

local opts = { noremap = true, silent = true }

-- Space does nothing on its own (it is the leader)
vim.keymap.set("", "<Space>", "<Nop>", opts)

-- Source lua from the current buffer
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", opts)

-- Press jk fast to enter normal mode
vim.keymap.set("i", "jk", "<ESC>", opts)

-- Append the next line to the current line but keep the position of the cursor
vim.keymap.set("n", "J", "mzJ`z")
-- Keep the cursor in the center while half page jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- Search terms stay in the middle vertically
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Yank to the system clipboard explicitly
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Delete into void register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Change project using tmux NOT WORKING FOR SOME REASON
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Navigation through the location list
-- (<C-k>/<C-j> would be the quickfix equivalents, but they are used for windows)
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Change the word the cursor is currently staying at
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Add executable permissions to the current file
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Source the current file
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})
