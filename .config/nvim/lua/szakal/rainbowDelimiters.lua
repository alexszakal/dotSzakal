-- This module contains a number of default definitions
local status_ok, rainbow_delimiters = pcall(require, "rainbow-delimiters")
if not status_ok then
    print("Could not load the rainbowDelimiters package")
    return
end

vim.g.rainbow_delimiters = {
    strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        commonlisp = rainbow_delimiters.strategy['local'],
    },
    query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
    },
    highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
    },
--    blacklist = {'c', 'cpp'},
    blacklist = { },
}
