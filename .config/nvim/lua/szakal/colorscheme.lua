vim.cmd "colorscheme default"

local colorscheme = "rose-pine"

local statusOK, _ = pcall(vim.cmd, "colorscheme " .. colorscheme )

if not statusOK then
    vim.notify("Colorscheme " .. colorscheme .. " not found!")
    return
end
