# Neovim Configuration

A hand-rolled, modular Neovim configuration built directly on
[`lazy.nvim`](https://github.com/folke/lazy.nvim) — **not** a distribution
(LazyVim/AstroNvim/NvChad). It borrows proven patterns from those distros
(the `User FileOpened` lazy-load event, category-split plugin files, the
`mini.*` ecosystem) while keeping every choice explicit and owned in-tree.

> **Leader key:** `,` (comma) — set in `lua/options.lua`.
> **Target:** modern Neovim (uses `vim.lsp`, `vim.diagnostic`, treesitter
> `main` branch, and is already wired for `blink.cmp`).

---

## Philosophy / Sentiment

This config optimizes for **a polished, IDE-like editing experience that the
author fully understands and controls**. Distinguishing traits:

- **Framework-free but distro-literate.** No abstraction layer sits between you
  and `lazy.nvim`. Patterns are lifted from LazyVim/AstroNvim deliberately, not
  inherited wholesale.
- **Modular by concern.** Plugins are split into one file per domain
  (`editing`, `ui`, `lsp`, `navigation`, …), each returning a plain `lazy.nvim`
  spec table. Adding/removing a capability touches one file.
- **Per-language LSP as data.** Language support is declared in tiny
  `lua/plugins/languages/<lang>.lua` modules consumed by
  [`quarry.nvim`](https://github.com/rsmdt/quarry.nvim) — each file lists the
  server, formatter, and linter as a single unit (see below).
- **UI-forward.** Heavy, intentional investment in visual polish: `noice`,
  a custom `lualine` that surfaces active LSP/formatter/linter tools,
  `bufferline`, scrollbar, indent guides, animated window resizing, and a
  startup dashboard.
- **Markdown & visual workflows are first-class.** `markview`, `image.nvim`,
  `diagram.nvim` (mermaid), and `codesnap` reflect a docs/screenshot-oriented
  workflow beyond plain coding.
- **Lazy by default with deliberate exceptions.** `defaults.lazy = false`
  globally, but most specs declare precise `event`/`keys`/`cmd`/`ft` triggers;
  colorschemes and a few UI pieces load eagerly on purpose.

---

## Directory Structure

```
init.lua                     Entry point: requires core modules, bootstraps lazy.nvim
lazy-lock.json               Pinned plugin commits (70 plugins)
.luarc.json                  lua_ls / LuaLS workspace settings

lua/
├── options.lua              vim.opt settings (leader, UI, indentation, undo, search)
├── mappings.lua             Global non-plugin keymaps (Y, H/L, splits, ESC clears search)
├── autocmd.lua              Autocommands (yank highlight, last-line, auto-mkdir,
│                            "User FileOpened"/"DirOpened" synthetic events, auto code-action)
│
├── core/
│   ├── icons.lua            Central icon set (referenced everywhere)
│   └── utils.lua            Helpers — notably u.has(plugin) for conditional config
│
├── configs/
│   └── lualine.lua          Statusline definition (custom tools() component)
│
└── plugins/                 One lazy.nvim spec file per domain
    ├── colorschemes.lua     tokyonight (default), nightfox, catppuccin + dark-notify
    ├── completions.lua      nvim-cmp stack + LuaSnip + lspkind
    ├── debugging.lua        nvim-dap + dap-ui
    ├── editing.lua          treesitter, mini.ai/surround, git (neogit/gitsigns/diffview),
    │                        autopairs, markview, image/diagram, codesnap, trouble, treesj
    ├── formatting.lua       conform.nvim
    ├── linting.lua          nvim-lint
    ├── lsp.lua              mason, quarry.nvim (LSP hub), lazydev, fastaction,
    │                        lsp_lines, outline, diagnostics config
    ├── navigation.lua       flash, which-key, tmux-navigator, visual-multi
    │                        (+ imports navigation/ subdir)
    ├── ui.lua               lualine, bufferline, noice, fidget, scrollbar,
    │                        indent guides, windows.nvim, alpha dashboard
    │
    ├── navigation/
    │   ├── fzf-lua.lua      Primary fuzzy finder (<leader>f…)
    │   └── mini-files.lua   Floating file explorer (<leader>e)
    │
    └── languages/           Per-language LSP/format/lint units (consumed by quarry.nvim)
        ├── lua.lua          lua_ls + stylua + luacheck
        ├── markdown.lua     marksman + vale
        ├── python.lua       pyright + ruff
        └── typescript.lua   ts_ls + eslint_d + prettierd
```

### Load order (`init.lua`)

1. `require("options")` → `require("mappings")` → `require("autocmd")`
2. Bootstrap `lazy.nvim` (clone if missing)
3. `lazy.setup({ import = "plugins" })` — auto-imports every file under
   `lua/plugins/`, which in turn import their subdirectories.

---

## Key Conventions

### Adding a language
Create `lua/plugins/languages/<lang>.lua` returning a `quarry.nvim` spec that
names the server + tools. It is auto-imported via the
`{ import = "plugins.languages" }` dependency in `lua/plugins/lsp.lua`. Example
(`languages/python.lua`): `pyright` LSP + `ruff` formatter/linter, with
server settings inline.

### Conditional configuration
`lua/core/utils.lua` exposes `u.has("<plugin>")`, used in `lsp.lua` to rewire
keymaps only when a plugin is present — e.g. `gd`/`gr` route through `fzf-lua`
and `<leader>a` routes through `fastaction.nvim` when available. LSP
`capabilities` already detect **both** `cmp_nvim_lsp` and `blink.cmp`, so the
completion engine can be swapped without touching LSP code.

### Icons
All glyphs come from `lua/core/icons.lua`. Reference it rather than hard-coding
Nerd Font characters.

### Synthetic events
`autocmd.lua` fires `User FileOpened` / `User DirOpened` once per session
(AstroNvim pattern). Many plugins lazy-load on `User FileOpened` instead of
`BufReadPost` to defer until a *real* file is opened.

---

## Keymap Highlights

| Key | Action |
|-----|--------|
| `,` | Leader |
| `<leader>e` | Toggle floating file explorer (mini.files) |
| `<leader>ff` / `fg` / `fw` | Find files / live grep / word (fzf-lua) |
| `<leader>e` `<leader>o` | Explorer / symbol outline |
| `<leader>a` / `<leader>r` | Code action / rename |
| `gd` `gr` `gi` `gt` | LSP goto definition / refs / impl / type (via fzf-lua) |
| `<leader>p` / `<leader>l` | Format (conform) / Lint (nvim-lint) |
| `<leader>L` | Toggle diagnostics virtual-text ↔ virtual-lines |
| `]c` / `[c` | Next / previous git hunk |
| `<leader>j` | Split/join with treesj |
| `<C-h/j/k/l>` | Tmux-aware window navigation |
| `<ESC>` | Clear search highlight |

Run `<leader>?` for the which-key popup.

---

## Notable / Unusual Choices

- **`quarry.nvim`** instead of the conventional `mason-lspconfig` + per-server
  `lspconfig` wiring — collapses server/formatter/linter declaration into one
  per-language module.
- **`fzf-lua`** as the picker (not Telescope or the newer snacks picker).
- **`mini.files`** as the file explorer (not neo-tree/nvim-tree).
- **nvim-cmp + LuaSnip** retained as the completion stack (LSP layer is already
  blink-ready, but cmp is still active).
- **`windows.nvim` + `animation.nvim` + `middleclass`** for animated window
  resizing, and **`nvim-scrollbar`** — heavier UI than most modern configs ship.
- **Treesitter on the `main` branch** (the post-rewrite API).

See `docs/` for prior analysis notes.
```
