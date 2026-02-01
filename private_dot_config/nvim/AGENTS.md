# Neovim Config — Agent Instructions

This is a Neovim (0.11+) configuration written in Lua, using lazy.nvim as the package manager.

## General Principles

- **Keep it simple.** Code should be easy to read and reason about.
- **Modular but not over-abstracted.** One file per plugin/concern is fine. Don't create layers of indirection or factory patterns just for the sake of it. If you have to jump through 4 files to understand a keymap, you've gone too far.
- **Prefer builtins.** If Neovim provides it natively, use it. Don't add a plugin for something `vim.lsp`, `vim.diagnostic`, `vim.keymap`, `vim.api`, or `vim.treesitter` already handles.
- **Minimal plugins.** Every plugin is a maintenance burden. Only add one if it provides clear value that can't be reasonably achieved with builtins. If you're unsure, don't add it.
- **Document the weird stuff.** If something is a hack, workaround, or non-obvious, leave a comment explaining _why_ it exists. Future readers (including AI agents) should not have to reverse-engineer intent.
- **No obvious comments.** Don't add comments that restate what the code does. Comments should explain _why_, not _what_. Section dividers (`-- Keymaps`, `-- Options`, `-- Formatting`) are noise when the code is self-explanatory. Keymaps with `desc` fields don't need additional comments. Function names should be descriptive enough to not need a comment restating their purpose. LLM-generated code is especially prone to over-commenting — strip it.

## Discovering the Neovim API

Before implementing something, check whether Neovim already provides it natively. Use these resources:

- **In-editor help:** Run `:help <topic>` inside Neovim (e.g., `:help vim.lsp`, `:help vim.diagnostic`, `:help lua-guide`). The builtin docs are the authoritative source.
- **Online docs:** https://neovim.io/doc/user/ — the full Neovim user manual and API reference.
- **Lua API reference:** https://neovim.io/doc/user/lua.html — covers `vim.api`, `vim.lsp`, `vim.diagnostic`, `vim.treesitter`, `vim.keymap`, `vim.fs`, `vim.iter`, and more.
- **Headless lookup:** Run `nvim --headless -c 'help vim.lsp.buf.format' -c 'qall'` or similar to quickly check if an API exists.
- **`:lua vim.print()`** is useful for inspecting runtime state (e.g., `:lua vim.print(vim.lsp.get_clients())` to see active LSP clients).

When in doubt, search the help docs before reaching for a plugin or writing a wrapper. Neovim 0.11 has a large Lua API surface — most things you need are already there.

## Neovim Best Practices (0.11+)

- Use `vim.keymap.set()` for all keymaps. Never use `vim.api.nvim_set_keymap()` directly.
- Use `vim.api.nvim_create_autocmd()` for autocommands. Group related autocmds with `vim.api.nvim_create_augroup()`.
- Use `vim.opt` / `vim.o` / `vim.bo` / `vim.wo` for options, not `vim.cmd("set ...")`.
- Use `vim.diagnostic` for diagnostics configuration. Don't wrap it unnecessarily.
- Use `vim.notify()` instead of `print()` for user-facing messages.
- Prefer Lua over Vimscript. Only use `vim.cmd()` when there's no Lua equivalent.

### LSP Configuration (Native API)

This config uses the **native Neovim 0.11 LSP API**, not the legacy `lspconfig[server].setup()` pattern.

- Use `vim.lsp.config("server_name", { ... })` to define server configurations.
- Use `vim.lsp.enable("server_name")` to activate them.
- **Per-server config files go in the top-level `lsp/` directory** (`~/.config/nvim/lsp/`). Neovim 0.11 auto-discovers these. When adding a new language server, prefer creating `lsp/<server_name>.lua` that returns the config table, over adding it inline.
- LSP keymaps are set via `LspAttach` autocmd, not globally.
- Formatting is handled by `conform.nvim`, not LSP formatting directly.

#### Role of nvim-lspconfig plugin

The `nvim-lspconfig` plugin is **not deprecated** — only the old `require('lspconfig').server.setup()` module/framework is. The plugin still serves an important role: it provides **server-specific default configurations** (cmd, filetypes, root markers, default settings) in its `lsp/` directory. `vim.lsp.config` automatically discovers and merges these defaults with your local configs.

Config resolution order (later wins):
1. `lsp/` files from plugins on `'runtimepath'` (e.g., nvim-lspconfig's defaults)
2. `after/lsp/` files on `'runtimepath'`
3. Explicit `vim.lsp.config()` calls

So: nvim-lspconfig provides sane defaults, and your local `lsp/<server>.lua` files or `vim.lsp.config()` calls override/extend them. You don't need to redefine `cmd`, `filetypes`, or `root_markers` if the defaults from nvim-lspconfig already work.

## Lua Best Practices

- Always use `local`. No implicit globals.
- Keep functions short and focused.
- Don't use metatables or OOP patterns unless genuinely needed.
- Use `vim.tbl_extend`, `vim.tbl_deep_extend`, `vim.list_extend` for table operations.
- Use early returns to reduce nesting.
- Strings: prefer `string.format()` or Lua concatenation over `vim.cmd` string building.

## lazy.nvim Best Practices

- Each plugin gets its own file in `lua/seruman/plugins/`.
- LSP-related plugins go in `lua/seruman/plugins/lsp/`.
- Plugin specs are auto-imported via `{ import = "seruman/plugins" }` and `{ import = "seruman/plugins.lsp" }` in `init.lua`.
- Use lazy-loading where it makes sense (`event`, `ft`, `cmd`, `keys`). Don't lazy-load things that need to be available immediately (colorscheme, core UI).
- Pin plugins via `lazy-lock.json` (committed). Don't modify the lockfile manually.
- Use `dependencies` to declare plugin relationships, not manual load ordering.
- Use `opts` table when the plugin's `config` is just calling `setup(opts)`. Only use `config` function when you need custom logic beyond `setup()`.

## Directory Structure

```
~/.config/nvim/
├── init.lua                  -- Entry point: options, keymaps, autocmds, lazy bootstrap
├── lsp/                      -- Per-server LSP configs (0.11 native auto-discovery)
├── lua/
│   └── seruman/
│       ├── plugins/          -- lazy.nvim plugin specs (one file per plugin)
│       │   └── lsp/          -- LSP-related plugin specs (lspconfig, completion, etc.)
│       └── lsp/
│           └── java/         -- Java LSP helpers (jdtls, gradle, etc.)
├── ftplugin/                 -- Filetype-specific settings (e.g., java.lua for jdtls)
├── ftdetect/                 -- Custom filetype detection
├── after/queries/            -- Custom treesitter queries
├── colors/                   -- Custom colorscheme (seruzen)
├── queries/                  -- Treesitter query overrides
└── filetype.lua              -- Custom filetype rules
```

## Workflow Rules

When working on this config:

1. **One thing at a time.** Don't batch unrelated changes. Make a single focused change, test it, then move on.
2. **Create todos** to track multi-step work. Mark them done as you go.
3. **Always test/assert changes.** Use `bootty` to run Neovim interactively (supports sending keystrokes and taking screenshots, including VT sequence export for color assertions). Use headless Neovim (`nvim --headless`) for non-interactive checks (e.g., verifying a plugin loads, LSP starts, no errors on startup).
4. **Check for errors after changes.** Run `nvim --headless -c 'qall'` or equivalent to verify no startup errors.
5. **Don't blindly trust that a change works.** Verify keymaps fire, plugins load, LSP attaches — whatever is relevant to the change.

## Things to Avoid

- Don't create wrapper functions around simple APIs just to "clean things up."
- Don't scatter a single plugin's config across multiple files. If a plugin's config is self-contained, keep it in one file.
