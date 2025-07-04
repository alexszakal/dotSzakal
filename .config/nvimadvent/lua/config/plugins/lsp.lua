-- Nvim ships with an LSP Client, we have to install the servers!
-- nvim-lspconfig contains the client configurations for different language servers
return {
    {"neovim/nvim-lspconfig",
        dependencies = {
            {
                "folke/lazydev.nvim",
                ft = "lua", -- only load on lua files
                opts = {
                    library = {
                        -- See the configuration section for more details
                        -- Load luvit types when the `vim.uv` word is found
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
        },
        config = function()
            local capabilities = require('blink.cmp').get_lsp_capabilities()
            require('lspconfig').clangd.setup{capabilities=capabilities,
                cmd={"clangd"}}

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('my.lsp', {}),
                callback = function(args)
                    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
                    if client:supports_method('textDocument/implementation') then
                        -- Create a keymap for vim.lsp.buf.implementation ...
                    end

                    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
                    if client:supports_method('textDocument/completion') then
                        -- Optional: trigger autocompletion on EVERY keypress. May be slow!
                        -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
                        -- client.server_capabilities.completionProvider.triggerCharacters = chars

                        vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
                    end

                    -- Auto-format ("lint") on save.
                    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
                    if not client:supports_method('textDocument/willSaveWaitUntil')
                        and client:supports_method('textDocument/formatting') then
                        vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format() end)
                        --   vim.api.nvim_create_autocmd('BufWritePre', {
                        --     group = vim.api.nvim_create_augroup('my.lsp', {clear=false}),
                        --     buffer = args.buf,
                        --     callback = function()
                        --       vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                        --     end,
                        --   })
                    end

                    -- KEYBINDINGS
                    local opts = { buffer = bufnr, silent = true }
                    vim.keymap.set('n', 'gD', function() vim.lsp.buf.declaration() end, opts)
                    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
                    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
                    vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, opts)
                    vim.keymap.set('n', '<C-k>', function() vim.lsp.buf.signature_help() end, opts)
                    vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end, opts)
                    vim.keymap.set('n', '<leader>rn', function() vim.lsp.buf.rename() end, opts)
                    vim.keymap.set('n', '<leader>ca', function() vim.lsp.buf.code_action() end, opts)
                    vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev() end, opts)
                    vim.keymap.set('n', "gl", function() vim.diagnostic.open_float() end, opts)
                    vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next() end, opts)
                    vim.keymap.set('n', '<leader>q', function() vim.diagnostic.setloclist() end, opts)
                    vim.keymap.set('n', '<leader>F', function() vim.lsp.buf.format() end, opts)
                end,
            })
        end,
    }
}
