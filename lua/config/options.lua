-- Opciones extra sobre los valores por defecto de LazyVim
local opt = vim.opt

opt.relativenumber = true
opt.scrolloff = 8
opt.wrap = false
opt.colorcolumn = "120"
opt.swapfile = false
opt.undofile = true
opt.clipboard = "unnamedplus" -- usa el portapapeles de macOS
opt.mouse = "a"

-- Formatear al guardar (desactivar con <leader>uf)
vim.g.autoformat = true
