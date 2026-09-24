-- CORE profile: general text editing.
--
-- This is the base every other profile builds on:
--   nvim   -> this config                (~/.config/nvim)
--   cvim   -> C++/CUDA, adds core        (~/.config/nvim-cpp)
--   lvim   -> LaTeX, adds core           (~/.config/nvim-tex)
--   pvim   -> Python, adds core          (~/.config/nvim-python)
--
-- Anything put in lua/core/ (options, keymaps, plugins) is picked up by all four.
-- See README.md for the layout.

require("core").setup({})
