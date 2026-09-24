-- C++ / CUDA profile.  Start with:  cvim   (NVIM_APPNAME=nvim-cpp nvim)
--
-- Builds on the core config in ~/.config/nvim: all shared options, keymaps and
-- core/plugins/ come from there, plus the shared development layer core/dev/
-- (mason, LSP, blink.cmp, treesitter, git, nvim-tree, DAP).
-- Anything below is C++/CUDA specific.

-- Put the core config on the runtimepath so "core.*" is requireable.
local core_root = vim.fn.expand("~/.config/nvim")
vim.opt.runtimepath:append(core_root)
package.path = table.concat({
    package.path,
    core_root .. "/lua/?.lua",
    core_root .. "/lua/?/init.lua",
}, ";")

require("core").setup({
    parsers = { "c", "cpp", "cuda", "cmake", "make", "python", "json", "yaml", "xml", "bash" },

    -- Mason-managed clangd and clang-format, newer than the system LLVM packages
    -- (/usr/bin/clangd 19.1.7, clang-format 18.1.8). mason.nvim prepends its bin
    -- directory to PATH, so the bare "clangd" in the server config below resolves
    -- to the mason build. codelldb is fetched separately by mason-nvim-dap.
    -- Update them later with :MasonToolsUpdate.
    tools = { "clangd", "clang-format" },

    servers = {
        clangd = {
            cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
                "--function-arg-placeholders",
                "--offset-encoding=utf-16",
            },
            -- MRC_SDK is built out of tree; generate2.sh writes compile_commands.json
            -- into ../build/<Config>/ with -DCMAKE_EXPORT_COMPILE_COMMANDS=ON.
            root_markers = { "compile_commands.json", ".clangd", "CMakeLists.txt", ".git" },
        },
        -- Also available once installed via :Mason -> neocmakelsp
        -- neocmake = true,
    },

    dap = { "codelldb" },

    spec = {
        { import = "core.dev" },    -- shared dev layer
        { import = "cpp.plugins" }, -- C++/CUDA only
    },
})

require("cpp.options")
