# README para Claude: replicar este entorno de Neovim en Arch Linux

> **Para Claude:** este archivo describe un entorno Neovim configurado en macOS (noviembre 2026)
> que el usuario quiere replicar **idéntico** en su PC con **Arch Linux**. Sigue los pasos en orden,
> verifica cada uno y avisa al usuario de cualquier fallo. El usuario habla español.
> Esta carpeta (`~/.config/nvim`) ya contiene toda la configuración; normalmente solo hay que
> instalar dependencias del sistema, copiar la carpeta y dejar que se instalen plugins/servidores.

---

## 1. Qué es este entorno

- **Base:** [LazyVim](https://www.lazyvim.org) (gestor de plugins `lazy.nvim`), tema Catppuccin Mocha.
- **Objetivo:** usar Neovim como IDE completo, sobre todo para **Java + Spring Boot + Hibernate (JPA) + Thymeleaf + Bootstrap**,
  y además Python, TypeScript/JS, Lua, Bash, JSON, YAML, Markdown, SQL, Docker, Tailwind, TOML.
- **Proyectos Java:** Java 27 + Spring Boot 4.1.x + Hibernate 7 → se usa **`jakarta.*`**, nunca `javax.persistence/validation/servlet`.

### Versiones en macOS (referencia)

| Herramienta | Versión |
|---|---|
| Neovim | 0.12.6 (**requiere ≥ 0.12**: `spring-boot.nvim` lo exige) |
| OpenJDK | 27.0.1 |
| Maven / Gradle | 3.10.0 / 9.8.2 |
| Node | 26.13 |
| Python | 3.13 (Mason necesita **≥ 3.10** para `debugpy` y `sqlfluff`) |
| ripgrep / fd / fzf / lazygit / tree-sitter-cli | 15.2 / 10.5 / 0.75 / 0.66 / 0.27 |

---

## 2. Estructura de archivos

```
~/.config/nvim/
├── init.lua                  # arranca lua/config/lazy.lua (de LazyVim starter, sin cambios)
├── lazyvim.json              # EXTRAS de LazyVim activados (lenguajes, dap, test, etc.)
├── lazy-lock.json            # versiones exactas de cada plugin (para replicar igual)
├── lua/config/
│   ├── lazy.lua              # bootstrap de lazy.nvim (starter, sin cambios)
│   ├── options.lua           # relativenumber, clipboard del sistema, colorcolumn 120, sin swap...
│   ├── keymaps.lua           # atajos estilo IDE (Cmd+S, Cmd+P, Cmd+B, F5/F9/F10/F11, jk)
│   └── autocmds.lua          # vacío (starter)
├── lua/plugins/
│   ├── ide.lua               # catppuccin, toggleterm, diffview, grug-far, herramientas Mason extra
│   └── java-web.lua          # Spring Boot LS, ajustes jdtls, lemminx, html/css/emmet, Bootstrap
├── snippets/
│   ├── java.json             # entity, repository, service, restcontroller, mvccontroller, onetomany...
│   └── html.json             # thpage, thform, thfield, thtable, bsnavbar (Thymeleaf + Bootstrap 5)
└── README_claude.md          # este archivo
```

### Extras de LazyVim activados (`lazyvim.json`)

coding: mini-surround, neogen, yanky · dap: core, nlua · editor: aerial, dial, harpoon2, illuminate,
inc-rename, mini-move, neo-tree, overseer, refactoring · formatting: prettier · lang: docker, git, java,
json, markdown, python, sql, tailwind, toml, typescript, yaml · linting: eslint · test: core ·
ui: edgy, treesitter-context · util: dot, mini-hipatterns, project, rest

### Plugins añadidos fuera de LazyVim

| Plugin | Para qué |
|---|---|
| `catppuccin/nvim` | tema |
| `akinsho/toggleterm.nvim` | terminal flotante con `Ctrl+\` |
| `sindrets/diffview.nvim` | `<leader>gv` diff, `<leader>gH` historial del archivo |
| `MagicDuck/grug-far.nvim` | buscar/reemplazar en proyecto |
| `JavaHello/spring-boot.nvim` | Spring Boot Language Server + extensiones de jdtls |
| `Jezda1337/nvim-html-css` | clases de Bootstrap 5 (CDN jsdelivr) en `class="..."` de HTML |

### Paquetes de Mason que deben quedar instalados

```
bash-language-server css-lsp debugpy docker-compose-language-service dockerfile-language-server
emmet-language-server eslint-lsp hadolint html-lsp java-debug-adapter java-test jdtls
js-debug-adapter json-lsp lemminx lua-language-server markdown-toc markdownlint-cli2 marksman
prettier pyright ruff shellcheck shfmt sqlfluff stylua tailwindcss-language-server taplo tsc
typescript-language-server vscode-spring-boot-tools vtsls yaml-language-server
```

### Parsers de Treesitter instalados

```
bash c css diff dockerfile dtd git_config git_rebase gitattributes gitcommit gitignore graphql html
http java javascript jsdoc json json5 lua luadoc luap markdown markdown_inline ninja printf
properties python query regex rst scss sql toml tsx typescript vim vimdoc xml yaml
```

---

## 3. Pasos en Arch Linux

### 3.1 Paquetes del sistema

```bash
sudo pacman -Syu --needed \
  neovim git curl unzip wget base-devel \
  ripgrep fd fzf lazygit tree-sitter-cli \
  nodejs npm python python-pip \
  jdk-openjdk maven gradle \
  ttf-jetbrains-mono-nerd \
  wl-clipboard xclip
```

Comprobaciones:
- `nvim --version` → debe ser **≥ 0.12**. Si no, usar `neovim-git` (AUR) o el AppImage oficial.
- `java -version` → idealmente 27 (o la última). Con varios JDK: `archlinux-java status` / `sudo archlinux-java set <jdk>`.
- `python3 --version` → ≥ 3.10 (en Arch siempre lo es).
- Si algún paquete no existe en los repos oficiales (p. ej. `tree-sitter-cli`), buscarlo en AUR o instalar con `npm i -g tree-sitter-cli`.
- **Portapapeles:** `options.lua` usa `clipboard = "unnamedplus"`; en Linux necesita `wl-clipboard` (Wayland) o `xclip` (X11).

### 3.2 Terminal y fuente

Recomendado: **Ghostty**, **kitty** o **WezTerm** (`pacman -S kitty` / `ghostty` / `wezterm`), con la fuente
**JetBrainsMono Nerd Font**. Sin Nerd Font los iconos salen como cuadros.

### 3.3 Copiar la configuración

Copiar esta carpeta entera a `~/.config/nvim` en Arch (por git, USB, `scp`, etc.).
**No** copiar `~/.local/share/nvim` ni `~/.local/state/nvim` desde macOS: contienen binarios para macOS
(Mason, parsers `.so`) que no sirven en Linux. Si ya existe una config previa en Arch, hacer backup:

```bash
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null
```

### 3.4 Instalar plugins (respetando `lazy-lock.json`)

```bash
nvim --headless "+Lazy! restore" +qa
```

(`restore` instala las versiones exactas del lockfile; `sync` las actualizaría.)

### 3.5 Instalar parsers de Treesitter

`nvim-treesitter` usa la rama `main` (API nueva). Comando probado:

```bash
nvim --headless -c 'lua require("lazy").load({plugins={"nvim-treesitter"}}); local o=require("lazy.core.plugin").values(require("lazy.core.config").spec.plugins["nvim-treesitter"],"opts",false); require("nvim-treesitter").install(o.ensure_installed):wait(560000)' -c 'qa!'
```

### 3.6 Instalar paquetes de Mason

LazyVim los instala solo al abrir Neovim de forma interactiva, pero en headless hay que forzarlo
y **esperar** sin bloquear el event loop (un `:wait()` síncrono congela Mason). Comando probado:

```bash
nvim --headless -c 'lua
local r = require("mason-registry")
local L = vim.split("bash-language-server css-lsp debugpy docker-compose-language-service dockerfile-language-server emmet-language-server eslint-lsp hadolint html-lsp java-debug-adapter java-test jdtls js-debug-adapter json-lsp lemminx lua-language-server markdown-toc markdownlint-cli2 marksman prettier pyright ruff shellcheck shfmt sqlfluff stylua tailwindcss-language-server taplo tsc typescript-language-server vscode-spring-boot-tools vtsls yaml-language-server", " ")
r.refresh(function()
  local function c()
    for _, p in ipairs(L) do
      local k = r.get_package(p)
      if not k:is_installed() then
        if not k:is_installing() then k:install() end
        return vim.defer_fn(c, 3000)
      end
    end
    vim.cmd("qa!")
  end
  c()
end)'
```

Si se queda en bucle, revisar `~/.local/state/nvim/mason.log` (causa típica: falta Python ≥ 3.10, `unzip`, `npm` o `java`).

### 3.7 Ajustar atajos para Linux (importante)

`lua/config/keymaps.lua` usa `<D-…>` (tecla **Cmd** de macOS), que no existe en Linux.
Añadir equivalentes con Ctrl conservando los de macOS (para que el mismo archivo sirva en ambos):

| macOS | Linux sugerido | Acción |
|---|---|---|
| `<D-s>` | `<C-s>` | guardar |
| `<D-p>` | `<C-p>` | buscar archivo |
| `<D-S-f>` | `<C-S-f>` | buscar en proyecto |
| `<D-b>` | `<C-b>` | árbol de archivos (*pisa* “página arriba” de Vim; preguntar al usuario) |
| `<D-S-h>` (en `lua/plugins/ide.lua`, grug-far) | `<C-S-h>` | reemplazar en proyecto |

Los atajos `Ctrl+Shift+letra` solo llegan a Neovim en terminales con protocolo de teclado
extendido (kitty, Ghostty, WezTerm). Los atajos con `<espacio>` (leader) funcionan en cualquier terminal.

---

## 4. Verificación (hacerla, no asumir)

1. `nvim --headless "+checkhealth lazyvim" "+w! /tmp/health.txt" +qa! ; grep -E "ERROR|WARNING" /tmp/health.txt` → sin errores.
2. **LSP general:** abrir un `.py`, `.ts` y `.lua` en una carpeta con `git init`; comprobar con
   `vim.lsp.get_clients({bufnr=0})` que aparecen `pyright, ruff` / `vtsls` / `lua_ls`.
3. **Spring Boot:** crear un proyecto Maven mínimo (`spring-boot-starter-parent` 4.1.x, `java.version` 27,
   starters `webmvc`, `data-jpa`, `thymeleaf`, `validation`, `h2`). Compilar con el `mvn` del sistema
   (no ejecutar `mvnw` descargado sin permiso del usuario). Al abrir una entidad deben estar los clientes
   **`jdtls` y `spring-boot`**; el completado de `@Gene` debe ofrecer `GeneratedValue`, y en
   `application.properties` `spring.jpa.show` → `spring.jpa.show-sql`. jdtls tarda 1–2 min la primera vez.
4. **Bootstrap:** en un `.html`, dentro de `class="btn-out"` el cliente `html-css-lsp` debe ofrecer
   `btn-outline-primary` (son ~1800 clases; al filtrar resultados no truncar la lista).
5. **Snippets:** `require("blink.cmp.sources.snippets.default.registry").new({}):get_snippets_for_ft("java")`
   debe incluir `entity`, `repository`, `service`, `restcontroller`.

---

## 5. Problemas que ya aparecieron en macOS (y su solución)

| Problema | Solución |
|---|---|
| `debugpy`/`sqlfluff` no se instalan | Mason necesita Python ≥ 3.10 en el PATH |
| Instalación headless de Mason/Treesitter se cuelga | no usar `:wait()` junto a Mason; usar `vim.defer_fn` en bucle |
| Completado de Bootstrap “vacío” en pruebas | el plugin necesita el texto ya en el buffer parseado; había ~1800 resultados y el script de prueba los truncaba |
| `checkhealth` avisa “fzf not installed” | instalar `fzf` |
| Atajos con Cmd no funcionan | Terminal.app no los envía; usar Ghostty/kitty/WezTerm (en Linux, ver 3.7) |

---

## 6. Atajos principales (para recordárselos al usuario)

`<espacio>` es leader (muestra menú). `<espacio><espacio>` archivos · `<espacio>/` grep · `<espacio>e` árbol ·
`gd` definición · `gr` referencias · `<espacio>cr` renombrar · `<espacio>ca` code actions ·
`F5/F9/F10/F11` depurar · `<espacio>tt` / `<espacio>tr` tests · `<espacio>gg` lazygit · `Ctrl+\` terminal ·
`:Lazy` plugins · `:Mason` servidores · `:LazyExtras` activar más lenguajes.
