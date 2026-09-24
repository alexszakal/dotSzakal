return {
    'lewis6991/gitsigns.nvim',
    config = function()
        local status_ok, gitsigns = pcall(require, "gitsigns")
        if not status_ok then
            return
        end

        gitsigns.setup {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "契" },
                topdelete = { text = "契" },
                changedelete = { text = "▎" },
                untracked = { text = "┆" },
            },
            signs_staged = {
                add          = { text = '┃' },
                change       = { text = '┃' },
                delete       = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
                untracked    = { text = '┆' },
            },
            signs_staged_enable = true,
            signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
            numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
            linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir = {
                follow_files = true,
            },
            auto_attach = true,
            attach_to_untracked = true,
            current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
                delay = 500,
                ignore_whitespace = false,
                virt_text_priority = 100,
                use_focus = true,
            },
            current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil, -- Use default
            max_file_length = 40000,
            preview_config = {
                -- Options passed to nvim_open_win
                style = "minimal",
                relative = "cursor",
                row = 0,
                col = 1,
            },
            on_attach = function(bufnr)
                local gs = require("gitsigns")
                vim.keymap.set('n', ']c', function()
                    if vim.wo.diff then return ']c' end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                end, {expr=true})
                vim.keymap.set('n', '[c', function()
                    if vim.wo.diff then return '[c' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                end, {expr=true})
                vim.keymap.set('n', '<leader>hs', gs.stage_hunk)
                vim.keymap.set('n', '<leader>hr', gs.reset_hunk)
                vim.keymap.set('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
                vim.keymap.set('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
                vim.keymap.set('n', '<leader>hS', gs.stage_buffer)
                vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk)
                vim.keymap.set('n', '<leader>hR', gs.reset_buffer)
                vim.keymap.set('n', '<leader>hp', gs.preview_hunk)
                vim.keymap.set('n', '<leader>hb', function() gs.blame_line{full=true} end)
                vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame)
                vim.keymap.set('n', '<leader>hd', gs.diffthis)
                vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end)
                vim.keymap.set('n', '<leader>td', gs.toggle_deleted)
            end

        }
    end
}
