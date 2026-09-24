-- Python specific editor settings, applied on top of core/options.lua.

vim.api.nvim_create_autocmd("FileType", {
    desc = "PEP 8 style: 4 spaces, 88/100 column guide",
    group = vim.api.nvim_create_augroup("python-style", { clear = true }),
    pattern = { "python" },
    callback = function()
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.expandtab = true
        vim.opt_local.colorcolumn = "100"
    end,
})

-- ruff owns formatting even when basedpyright also advertises it
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("python-format", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "basedpyright" then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
        end
    end,
})

-- Run the current file with the interpreter of the active virtualenv
vim.keymap.set("n", "<leader>rr", function()
    vim.cmd("write")
    local python = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/bin/python") or "python3"
    vim.cmd("botright split | terminal " .. python .. " " .. vim.fn.shellescape(vim.fn.expand("%:p")))
end, { desc = "Run current Python file" })
