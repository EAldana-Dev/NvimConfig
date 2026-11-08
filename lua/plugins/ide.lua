return {
  -- Tema
  { "catppuccin/nvim", name = "catppuccin", opts = { flavour = "mocha" } },
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin" } },

  -- Terminal flotante / integrada (Ctrl+\)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = { { "<C-\\>", desc = "Terminal" } },
    opts = { open_mapping = [[<C-\>]], direction = "float", float_opts = { border = "curved" } },
  },

  -- Diffs y historial de git estilo IDE
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Diffview" },
      { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "Historial del archivo" },
    },
  },

  -- Buscar y reemplazar en todo el proyecto
  {
    "MagicDuck/grug-far.nvim",
    keys = { { "<D-S-h>", function() require("grug-far").open() end, desc = "Reemplazar en proyecto" } },
  },

  -- Herramientas que Mason instala automáticamente
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "stylua", "shellcheck", "shfmt", "bash-language-server", "lua-language-server" },
    },
  },
}
