vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = truej}),
	callback = function()
		vim.highlight.on_yank()
	end,
})

opts = {noremap=true, silent=true}
--Remap space as leader key
vim.keymap.set("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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

-- Set <leader>-y to yank text to system clipboard instead of nvim clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Delete into void register
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- Change project using tmux NOT WORKING FOR SOME REASON
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Quickfix navigation through the quickfix list
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")  --Commented out because this is used now for window navigation
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")  --Commented out because this is used now for window navigation
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

-- Debugging COMMENT OUT!!!!!
--[[ vim.keymap.set("n", "<F5>", ":lua require'dap'.continue()<CR>") ]]
--[[ vim.keymap.set("n", "<F3>", ":lua require'dap'.step_over()<CR>") ]]
--[[ vim.keymap.set("n", "<F2>", ":lua require'dap'.step_into()<CR>") ]]
--[[ vim.keymap.set("n", "<F12>", ":lua require'dap'.step_out()<CR>") ]]
--[[ vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>") ]]
--[[ vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>") ]]
--[[ vim.keymap.set("n", "<leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>") ]]
--[[ vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>") ]]
-- DAP-UI
--[[ vim.keymap.set("n", "<leader>du", ":lua require'dapui'.toggle()<CR>") ]]

require("config.lazy")
require("config.options")
