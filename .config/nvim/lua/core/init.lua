-- Shared entry point for every profile.
--
--   ~/.config/nvim          -> core         (nvim)
--   ~/.config/nvim-cpp      -> C++/CUDA     (cvim)
--   ~/.config/nvim-tex      -> LaTeX        (lvim)
--   ~/.config/nvim-python   -> Python       (pvim)
--
-- Each profile's init.lua puts this directory on the runtimepath and then calls
-- require("core").setup{...}. Everything in core/options.lua, core/keymaps.lua
-- and core/plugins/ is therefore shared by all four configs.

local M = {}

--- Absolute path of the core config (this directory's grandparent).
M.root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h:h")

--- Options the active profile passed to setup(); read by the modules in core/dev/.
---@class CoreOpts
---@field parsers  string[]|nil  extra treesitter parsers to install
---@field servers  table|nil     LSP servers: name -> vim.lsp.config table (or true for defaults)
---@field tools    string[]|nil  mason packages to auto-install (servers, linters, formatters)
---@field dap      string[]|nil  mason-nvim-dap adapters; nil/empty disables DAP entirely
---@field spec     table|nil     extra lazy.nvim spec entries, e.g. { { import = "cpp.plugins" } }
---@field localleader string|nil defaults to "\\"
M.opts = {}

function M.setup(opts)
    M.opts = opts or {}

    -- Leaders must be set before any mapping and before lazy.nvim loads.
    vim.g.mapleader = M.opts.leader or " "
    vim.g.maplocalleader = M.opts.localleader or "\\"

    require("core.options")
    require("core.keymaps")
    require("core.lazy").setup(M.opts.spec)
end

return M
