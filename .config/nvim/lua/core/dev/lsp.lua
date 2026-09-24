-- Nvim ships with an LSP client, we have to install the servers!
-- nvim-lspconfig contains the client configurations for different language servers.
--
-- Which servers get enabled is decided by the active profile, via the `servers`
-- table passed to require("core").setup{}.  Everything below (capabilities,
-- keymaps, diagnostics) is shared by all of them.
return {
    { "neovim/nvim-lspconfig",
        dependencies = {
            {
                "folke/lazydev.nvim",
                ft = "lua", -- only load on lua files
                opts = {
                    library = {
                        -- Load luvit types when the `vim.uv` word is found
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
        },
        config = function()
            -- Disable LSP client logging (~/.local/state/nvim/lsp.log); use "WARN" to keep problems only
            vim.lsp.log.set_level("OFF")

            local capabilities = require('blink.cmp').get_lsp_capabilities()
            vim.lsp.config('*', { capabilities = capabilities })

            -- Per-profile servers: { clangd = true, basedpyright = { settings = {...} } }
            local servers = require("core").opts.servers or {}
            local enable = {}
            for name, cfg in pairs(servers) do
                if type(cfg) == "table" then
                    vim.lsp.config(name, cfg)
                end
                table.insert(enable, name)
            end
            if #enable > 0 then
                vim.lsp.enable(enable)
            end

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('my.lsp', {}),
                callback = function(args)
                    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

                    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
                    if client:supports_method('textDocument/completion') then
                        vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
                    end

                    -- KEYBINDINGS
                    local opts = { buffer = args.buf, silent = true }
                    vim.keymap.set('n', 'gD', function() vim.lsp.buf.declaration() end, opts)
                    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
                    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
                    vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, opts)
                    vim.keymap.set('n', '<C-k>', function() vim.lsp.buf.signature_help() end, opts)
                    vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end, opts)
                    vim.keymap.set('n', '<leader>rn', function() vim.lsp.buf.rename() end, opts)
                    vim.keymap.set('n', '<leader>ca', function() vim.lsp.buf.code_action() end, opts)
                    vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
                    vim.keymap.set('n', "gl", function() vim.diagnostic.open_float() end, opts)
                    vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
                    vim.keymap.set('n', '<leader>q', function() vim.diagnostic.setloclist() end, opts)
                    vim.keymap.set('n', '<leader>F', function() vim.lsp.buf.format() end, opts)
                end,
            })
        end,
    }
}
