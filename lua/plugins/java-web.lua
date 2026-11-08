-- Java + Spring Boot + Hibernate (JPA) + Thymeleaf/JSP + Bootstrap

-- JSP: usar el parser de HTML de Treesitter (resaltado y clases de Bootstrap en class="...")
vim.treesitter.language.register("html", "jsp")

return {
  -- Servidores y herramientas que Mason instala
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "vscode-spring-boot-tools", -- Spring Boot: application.properties/yml, beans, endpoints
        "lemminx", -- XML: pom.xml con autocompletado
        "html-lsp",
        "css-lsp",
        "emmet-language-server", -- div.container>div.row>div.col-6 + Tab
      },
    },
  },

  -- Parsers de sintaxis
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "java", "html", "css", "scss", "javascript", "xml", "properties", "sql", "yaml" } },
  },

  -- LSP para HTML/CSS/XML/Emmet
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = { filetypes = { "html", "jsp" } },
        cssls = {},
        lemminx = {},
        emmet_language_server = { filetypes = { "html", "jsp", "css", "scss", "javascriptreact", "typescriptreact" } },
      },
    },
  },

  -- Spring Boot Language Server (el mismo que usa VS Code)
  {
    "JavaHello/spring-boot.nvim",
    ft = { "java", "yaml", "jproperties" },
    dependencies = { "mfussenegger/nvim-jdtls" },
    opts = {},
  },

  -- Ajustes de jdtls: extensiones de Spring, imports, Lombok, completado más útil
  {
    "mfussenegger/nvim-jdtls",
    dependencies = { "JavaHello/spring-boot.nvim" },
    opts = function(_, opts)
      opts.jdtls = function(config)
        config.init_options = config.init_options or {}
        config.init_options.bundles = config.init_options.bundles or {}
        local ok, sb = pcall(require, "spring_boot")
        if ok then
          vim.list_extend(config.init_options.bundles, sb.java_extensions())
        end
        return config
      end
      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
          configuration = { updateBuildConfiguration = "automatic" },
          maven = { downloadSources = true },
          eclipse = { downloadSources = true },
          references = { includeDecompiledSources = true },
          implementationsCodeLens = { enabled = true },
          referencesCodeLens = { enabled = true },
          signatureHelp = { enabled = true, description = { enabled = true } },
          contentProvider = { preferred = "fernflower" }, -- ver código de librerías sin fuentes
          completion = {
            -- Sugerencias de imports estáticos frecuentes en Spring/tests
            favoriteStaticMembers = {
              "org.junit.jupiter.api.Assertions.*",
              "org.assertj.core.api.Assertions.*",
              "org.mockito.Mockito.*",
              "org.mockito.ArgumentMatchers.*",
              "org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
              "org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
            },
            -- No sugerir paquetes viejos/internos (evita importar javax.* por error)
            filteredTypes = {
              "com.sun.*",
              "sun.*",
              "jdk.*",
              "java.awt.*",
              "javax.persistence.*",
              "javax.validation.*",
              "javax.servlet.*",
              "javax.annotation.PostConstruct",
              "javax.annotation.PreDestroy",
            },
            importOrder = { "java", "jakarta", "org", "com", "" },
          },
          sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
          codeGeneration = {
            toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
            useBlocks = true,
            generateComments = false,
          },
        },
      })
    end,
  },

  -- Clases de Bootstrap en el autocompletado de HTML / plantillas Thymeleaf
  {
    "Jezda1337/nvim-html-css",
    ft = { "html", "jsp" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      enable_on = { "html", "jsp" },
      style_sheets = {
        "https://cdn.jsdelivr.net/npm/bootstrap@5/dist/css/bootstrap.min.css",
      },
    },
  },

  -- Snippets de HTML/Bootstrap (thpage, bsnavbar...) también en archivos JSP
  {
    "saghen/blink.cmp",
    opts = {
      sources = { providers = { snippets = { opts = { extended_filetypes = { jsp = { "html" } } } } } },
    },
  },
}
