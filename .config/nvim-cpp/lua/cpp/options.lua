-- C++/CUDA specific editor settings, applied on top of core/options.lua.

-- Treat CUDA sources as C++ for anything that has no cuda-specific support
vim.filetype.add({
    extension = {
        cu = "cuda",
        cuh = "cuda",
        inl = "cpp",
        ipp = "cpp",
        hpp = "cpp",
    },
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "MRC_SDK house style: 4 spaces, 120 column guide",
    group = vim.api.nvim_create_augroup("cpp-style", { clear = true }),
    pattern = { "c", "cpp", "cuda", "cmake" },
    callback = function()
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.expandtab = true
        vim.opt_local.colorcolumn = "120"
        vim.opt_local.cindent = true
    end,
})

-- Jump between the header and the source of the current file (clangd extension)
vim.keymap.set("n", "<leader>h", function()
    local client = vim.lsp.get_clients({ bufnr = 0, name = "clangd" })[1]
    if not client then
        vim.notify("clangd is not attached to this buffer", vim.log.levels.WARN)
        return
    end
    local params = { uri = vim.uri_from_bufnr(0) }
    client:request("textDocument/switchSourceHeader", params, function(err, result)
        if err or not result then
            vim.notify("No matching source/header file", vim.log.levels.WARN)
            return
        end
        vim.cmd.edit(vim.uri_to_fname(result))
    end, 0)
end, { desc = "Switch between source and header" })
