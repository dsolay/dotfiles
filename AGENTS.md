# AGENTS.md — Dotfiles Repository

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory is a stow package that mirrors `$HOME`. The two primary codebases are **Neovim config (Lua)** and **shell scripts/config (Bash)**.

## Repository Structure

```
dotfiles/
├── nvim/.config/nvim/          # Neovim config (Lua, lazy.nvim)
│   ├── init.lua                # Entry: autocmds -> options -> lazy -> keymaps
│   ├── lua/dsolay/config/      # Core config modules (options, keymaps, lsp, formatters)
│   ├── lua/dsolay/utils/       # Utility modules (root, fs, table, env, hi)
│   ├── lua/dsolay/plugins/     # lazy.nvim plugin specs (auto-imported)
│   ├── after/ftplugin/         # Filetype-specific overrides
│   └── after/lsp/              # Per-server LSP configs
├── shell/                      # Bash config (.bashrc, .bash_profile)
│   ├── .bashrc                 # Sources funcs -> settings -> aliases
│   └── .bash/                  # Modules: aliases.sh, funcs.sh, env.bash, key-bindings.bash
├── bin/bin/                    # ~73 executable shell scripts
├── tmux/                       # Tmux config + TPM plugins (submodules)
├── alacritty/                  # Alacritty terminal config (TOML)
├── bspwm/                      # BSPWM + SXHKD hotkey config
├── vim/                        # Legacy Vim config (VimScript)
└── ...                         # polybar, dunst, starship, qutebrowser, etc.
```

## Build / Lint / Test Commands

No build system, test suite, or CI. Deploy via `stow nvim` / `stow -D nvim`.

```bash
stylua nvim/.config/nvim/            # Lua formatter (config: nvim/.config/nvim/.stylua.toml)
shellcheck bin/bin/*                  # Shell linter
shellcheck shell/.bash/*.sh
source ~/.bashrc                      # Reload shell config
# In Neovim: :Lazy reload <plugin>   # Reload a single plugin
# In Neovim: :source %              # Re-source current Lua file
```

## Code Style — Lua (Neovim Config)

### Formatting

- **Indentation:** 4 spaces (enforced by `.stylua.toml`)
- **Line width:** 120 characters max
- **Formatter:** StyLua — run before committing Lua changes

### Naming Conventions

| Element              | Convention          | Example                              |
|----------------------|---------------------|--------------------------------------|
| Local variables      | `snake_case`        | `lsp_config`, `status_ok`            |
| Local functions      | `snake_case`        | `get_best_formatter`, `file_exists`   |
| Module tables        | `SCREAMING_CASE`    | `FORMATTERS`, `LSP`                   |
| Module constants     | `SCREAMING_CASE`    | `FORMATTERS.PRIORITIES`, `DIAGNOSTIC_ICONS` |
| Namespace            | `dsolay.<area>.*`   | `dsolay.config.lsp`, `dsolay.plugins.editor` |

### Module Patterns

- **Config modules** — revealing module: `local M = {} ... return M`
- **Plugin modules** — return array of lazy.nvim specs: `return { { "author/plugin.nvim", ... } }`
- **Side-effect modules** (init, lazy bootstrap) — no return value
- **Utils modules** — `init.lua` re-exports submodules; submodules use `function M.name()` style (not revealing module). Prefer granular requires: `require("dsolay.utils.root").get()` over flat access.

### Imports and Error Handling

- **First-party modules:** bare `require` — `local cfg = require("dsolay.config.lsp")`
- **Third-party/plugin modules:** always `pcall`:
  ```lua
  local status_ok, module = pcall(require, "module-name")
  if not status_ok then return end
  ```
- Guard variable naming: `status_ok` or `<module>_status`
- Use early `return` on failure, never nest the happy path

### Comment Style

- **Section headers:** `-- ====...====` box delimiters
- **Doc comments:** LuaDoc `--- @param name type`, `--- @return type`
- **Inline comments:** explain "why", not "what"

### LSP Server Configuration

Per-server configs live in `after/lsp/<server>.lua` (e.g., `after/lsp/ts_ls.lua`).
Filetype overrides live in `after/ftplugin/<ft>.lua`.

## Code Style — Bash (Shell Scripts)

### Formatting

- **Shebang:** always `#!/bin/bash` — scripts are NOT POSIX-portable
- **Indentation:** 2 spaces
- **Linter:** ShellCheck — use `# shellcheck` directives for valid suppressions

### Naming Conventions

| Element              | Convention            | Example                             |
|----------------------|-----------------------|-------------------------------------|
| Environment vars     | `SCREAMING_CASE`      | `HISTCONTROL`, `GOPATH`             |
| Local variables      | `snake_case`          | `tempus_theme`, `target_desktop`    |
| Private functions    | `_underscore_prefix`  | `_checkexec`, `_fetchpr`, `_help`   |
| Public functions     | `snake_case` or hyphenated | `docker-ip`, `ssh-init`, `arc` |
| Alias prefixes       | Short mnemonic groups | `g*` (git), `d*` (docker), `dc*` (compose), `p*` (pacman) |

### Key Patterns

```bash
# Conditional sourcing
# shellcheck source=.bash/funcs.sh
[ -f ~/.bash/funcs.sh ] && source ~/.bash/funcs.sh

# Command existence guard (use _checkexec)
_checkexec() { command -v "$1" >/dev/null; }
if _checkexec docker; then alias dps='docker ps'; fi

# Argument validation
[[ $# -lt 1 ]] && { printf "Usage: myfunc <arg>\n" >&2; return 1; }
```

**Always double-quote variables:** `"$1"`, `"$HOME"`, `"${variable}"`.

### Comment Style

- **Section headers:** `# Title` followed by `# ====` or `# ----` underline
- **ShellCheck directives** above the relevant line: `# shellcheck disable=2142`
- **File headers:** description block with copyright + GPL notice (for standalone scripts)

## Git Conventions

### Commit Messages — Conventional Commits

```
<type>(<scope>): <description>
```

| Type       | Usage                                  |
|------------|----------------------------------------|
| `feat`     | New functionality or configuration     |
| `fix`      | Bug fixes                              |
| `chore`    | Plugin updates, cleanup, maintenance   |
| `refactor` | Restructuring without behavior change  |

**Scopes:** `nvim`, `shell`, `nvim, treesitter`, `nvim, dap`, `fontconfig`, etc.
Multiple scopes comma-separated when a change spans areas.

**Examples:** `feat(nvim): setup snacks.nvim and yanky.nvim`, `chore(nvim): update plugins`

### Rules

- Never add "Co-Authored-By" or AI attribution to commits
- Keep descriptions lowercase, imperative mood
- Scope is optional for cross-cutting changes

## Environment Context

- **OS:** Arch Linux
- **Shell:** Bash (not zsh/fish)
- **Terminal:** Alacritty
- **Editor:** Neovim (lazy.nvim plugin manager, Mason for LSP/formatters)
- **Colorscheme:** Gruvbox (dark default, light toggle via alacritty symlink)
- **Multiplexer:** Tmux (TPM for plugins)
- **Window Manager:** BSPWM
- **Prompt:** Starship
- **Runtime manager:** mise (formerly rtx)
- **Leader key:** `,` (comma)
