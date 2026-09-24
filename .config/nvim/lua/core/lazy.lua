-- lazy.nvim bootstrap + spec assembly.
--
-- The plugin tree and the lockfile live under stdpath("data"), which NVIM_APPNAME
-- makes distinct per profile, so ":Lazy sync" in one profile can never uninstall
-- another profile's plugins.

local M = {}

local function bootstrap()
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
                { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
                { out, "WarningMsg" },
                { "\nPress any key to exit..." },
            }, true, {})
            vim.fn.getchar()
            os.exit(1)
        end
    end
    vim.opt.runtimepath:prepend(lazypath)
end

--- @param extra table|nil additional lazy.nvim spec entries from the profile
function M.setup(extra)
    bootstrap()

    local core = require("core")

    local spec = { { import = "core.plugins" } }
    vim.list_extend(spec, extra or {})

    require("lazy").setup({
        spec = spec,
        -- Keep the core directory on the runtimepath after lazy.nvim resets it,
        -- so "core.plugins" / "core.dev" stay importable from the other profiles.
        performance = { rtp = { paths = { core.root } } },
        change_detection = { notify = false },
        install = { colorscheme = { "rose-pine", "habamax" } },
    })
end

return M
