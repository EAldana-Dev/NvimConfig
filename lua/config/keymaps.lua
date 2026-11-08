-- Atajos familiares de IDEs gráficos, además de los de LazyVim (<espacio> = leader)
local map = vim.keymap.set

-- Guardar con Cmd+S / Ctrl+S
map({ "n", "i", "v" }, "<D-s>", "<cmd>w<cr><esc>", { desc = "Guardar" })

-- Cmd+P: buscar archivo / Cmd+Shift+F: buscar en proyecto
map("n", "<D-p>", function() Snacks.picker.files() end, { desc = "Buscar archivo" })
map("n", "<D-S-f>", function() Snacks.picker.grep() end, { desc = "Buscar en proyecto" })

-- Cmd+B: árbol de archivos
map("n", "<D-b>", "<cmd>Neotree toggle<cr>", { desc = "Árbol de archivos" })

-- F-keys del depurador (como VS Code / IntelliJ)
map("n", "<F5>", function() require("dap").continue() end, { desc = "Debug: continuar" })
map("n", "<F9>", function() require("dap").toggle_breakpoint() end, { desc = "Debug: breakpoint" })
map("n", "<F10>", function() require("dap").step_over() end, { desc = "Debug: step over" })
map("n", "<F11>", function() require("dap").step_into() end, { desc = "Debug: step into" })
map("n", "<S-F11>", function() require("dap").step_out() end, { desc = "Debug: step out" })

-- Salir de modo insert con jk
map("i", "jk", "<esc>", { desc = "Salir de insert" })
