local chad_modules = {
    "options",
    "mappings",
    "utils"
}

for i = 1, #chad_modules, 1 do
    pcall(require, chad_modules[i])
end

-- g.nvchad_theme = "river"
-- base16(base16.themes["nvchad-nord"], true)
