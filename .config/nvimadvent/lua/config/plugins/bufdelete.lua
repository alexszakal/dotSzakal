return {
    "famiu/bufdelete.nvim",
    config = function()
        -- Delete buffer without messing up windows, splits
        vim.keymap.set('n', '<leader>c', ":Bdelete <CR>")
    end
}
