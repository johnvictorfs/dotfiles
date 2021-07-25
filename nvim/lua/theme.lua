vim.g.nvchad_theme = "river"

local present, base16 = pcall(require, "base16")

if present then
    base16(base16.themes["river"], true)
    require "highlights"
    return true
else
    return false
end
