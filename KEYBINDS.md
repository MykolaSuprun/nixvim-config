# Keybinds Reference

Keybinds that are **not** visible in which-key (insert-mode, non-leader, plugin-internal, function-keys) and are not plain Neovim defaults — plus a few easy-to-forget groups (harpoon, betterTerm, the AI agents).
Scope: `nixvim-config` only.

---

## Completion — blink-cmp

> Active in **insert mode** when the completion menu is open.

| Key | Action |
|-----|--------|
| `<C-space>` | Show / toggle documentation panel |
| `<C-l>` | Accept selected suggestion |
| `<C-j>` | Select next item |
| `<C-k>` | Select previous item |
| `<CR>` | Select next item (fallback to newline) |
| `<Tab>` | Jump to next snippet placeholder |
| `<S-Tab>` | Jump to previous snippet placeholder |
| `<C-n>` | Scroll documentation panel down |
| `<C-p>` | Scroll documentation panel up |
| `<C-h>` | Hide completion menu |

---

## LSP Hover / Documentation Float

> Active in **normal mode** on the hover float itself.

| Key | Action |
|-----|--------|
| `K` | Open hover documentation float (LSP built-in) |
| `<C-w>w` | Move cursor into the hover float |
| `<C-d>` / `<C-u>` | Scroll inside the float (once focused) |
| `q` / `<Esc>` | Close the float |

---

## LSP Navigation

> Non-leader keys — **normal mode**.

| Key | Action |
|-----|--------|
| `gd` | Go to definition (Snacks picker) |
| `gD` | Go to declaration (Snacks picker) |
| `gr` | References (Snacks picker) |
| `gI` | Go to implementation (Snacks picker) |
| `gy` | Go to type definition (Snacks picker) |

---

## Diagnostics

| Key | Mode | Action |
|-----|------|--------|
| `[d` | n | Previous diagnostic (with float) |
| `]d` | n | Next diagnostic (with float) |
| `[e` | n | Previous error (with float) |
| `]e` | n | Next error (with float) |

---

## Flash Motion

| Key | Mode | Action |
|-----|------|--------|
| `<S-s>` | n, x | Flash jump |
| `<C-s>` | n | Flash treesitter selection |

---

## Debug — Function Keys

| Key | Action |
|-----|--------|
| `<F5>` | Continue |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |

---

## DAP-UI Panels

> Keys active **inside** the dap-ui pane windows (scopes, breakpoints, watches, stacks, repl, console).

| Key | Action |
|-----|--------|
| `<CR>` or `double-click` | Expand / collapse element |
| `o` | Open |
| `d` | Remove |
| `e` | Edit |
| `r` | Open REPL |
| `t` | Toggle |

---

## Window / Pane Navigation

| Key | Mode | Action |
|-----|------|--------|
| `<leader>w` | n | Pick window (nvim-window-picker, big floating letter) |
| `<C-w>h/j/k/l` | n | Standard Neovim window navigation |
| `<C-\>` | n | Toggle snacks.terminal |
| `<C-/>` | n | Toggle snacks.terminal float (moved off `<leader>tf`, which collided with "First Tab") |
| `<S-Esc>` | t | Send `<C-\><C-n>` to exit terminal mode |

> The previous `<M-h/j/k/l>` tmux pane-navigation mappings and the `<leader>h/j/k/l` in-editor window navigation were removed. Use `<leader>w` to pick a window by its big floating-letter hint, or `<C-w>` motions for direct navigation.

---

## Bufferline / Tab Cycling

| Key | Mode | Action |
|-----|------|--------|
| `<S-h>` | n | Previous tab |
| `<S-l>` | n | Next tab |
| `<leader><S-tab>` | n | Pick tab |

---

## Aerial Symbol Navigation

> Moves between top-level symbols (functions, classes, etc.) in the current file.

| Key | Mode | Action |
|-----|------|--------|
| `{` | n | Previous symbol |
| `}` | n | Next symbol |

---

## Harpoon Quick Jump

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ha` | n | Add current file to harpoon |
| `<leader>hh` | n | Open harpoon quick menu |
| `<leader>h1` | n | Jump to harpoon file 1 |
| `<leader>h2` | n | Jump to harpoon file 2 |
| `<leader>h3` | n | Jump to harpoon file 3 |
| `<leader>h4` | n | Jump to harpoon file 4 |
| `<leader>hp` | n | Previous harpoon file |
| `<leader>hn` | n | Next harpoon file |

---

## Persistent Terminal (betterTerm)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>Xt` | n | Toggle / new betterTerm tab |
| `<leader>X1` | n | Focus terminal 1 |
| `<leader>X2` | n | Focus terminal 2 |
| `<leader>X3` | n | Focus terminal 3 |
| `<leader>X4` | n | Focus terminal 4 |
| `<leader>X5` | n | Focus terminal 5 |
| `<leader>Xx` | n | Select terminal |
| `<leader>Xr` | n | Rename current terminal |
| `<leader>Xk` | n | Kill current terminal |
| `<leader>Xs` | n | Send current line to terminal |
| `<leader>Xv` | x | Send visual selection to terminal |
| `<leader>Xf` | n | Send whole file to terminal |

---

## Git Hunk Navigation

| Key | Mode | Action |
|-----|------|--------|
| `[h` | n | Previous hunk |
| `]h` | n | Next hunk |

---

## Neotest — Jump Between Failures

| Key | Mode | Action |
|-----|------|--------|
| `[T` | n | Previous failed test |
| `]T` | n | Next failed test |

---

## Obsidian (`<leader>O`) + Overseer

> `<leader>O` is a shared prefix: bare `O` opens the Obsidian command menu,
> `O` + key runs overseer. Every overseer bind waits `timeoutlen` (300 ms)
> for disambiguation — accepted cost, so Obsidian directs use free keys only.

| Key | Mode | Action |
|-----|------|--------|
| `<leader>O` | n | Obsidian command menu |
| `<leader>Oq` | n | Obsidian quick switch note |
| `<leader>Of` | n | Obsidian search vault |
| `<leader>Ot` | n | Overseer toggle tasks list |
| `<leader>Or` | n | Overseer run task (template picker) |
| `<leader>Oa` | n | Overseer task action |
| `<leader>Oo` | n | Overseer open tasks list |
| `<leader>Oc` | n | Overseer close tasks list |
| `<leader>Os` | n | Overseer run shell command as task |
| `<leader>OR` | n | Overseer restart last task |
| `<leader>Ow` | n | Overseer watch (restart on save) |

---

## AI Agents — sidekick (CLI agents, `<leader><tab>`)

> sidekick.nvim manages external AI coding CLIs (claude / opencode / …) in its
> own terminal window. NES (next-edit suggestions) is intentionally off — it
> requires the Copilot language server, which this config refuses.

| Key | Mode | Action |
|-----|------|--------|
| `<leader><tab>t` | n | Toggle CLI terminal |
| `<leader><tab>s` | n | Select CLI (installed only) |
| `<leader><tab>f` | n | Focus terminal |
| `<leader><tab>p` | n, x | Pick prompt |
| `<leader><tab>x` | n, x | Send `{this}` (position + selection) |
| `<leader><tab>e` | n | Send `{file}` |
| `<leader><tab>v` | x | Send visual selection |
| `<leader><tab>d` | n | Detach CLI |
| `<c-.>` | n, t, i, x | Focus CLI terminal |

> Inside a Snacks picker, `<a-a>` sends the selected items to the active CLI.
> With `cli.mux.enabled = true` (off by default) sessions persist across
> Neovim restarts via tmux.

---

## CodeCompanion — chat / inline / ACP (`<leader>a`)

> Chat talks to **opencode over ACP** (`opencode acp`) and therefore uses the
> models, MCP servers, permissions and rules from
> `~/.config/opencode/opencode.jsonc` — sessions stay interchangeable with the
> opencode TUI. Inline and cmd use **LM Studio** over its OpenAI-compatible
> endpoint (`http://localhost:1234`). `AGENTS.md` autoloads as rules.
> `#{...}` inserts editor context (`#{buffer}`, `#{diagnostics}`,
> `#{selection}`, `#{quickfix}`, `#{diff}`, …).

| Key | Mode | Action |
|-----|------|--------|
| `<leader>aa` | n, x | Toggle chat |
| `<leader>aA` | n, x | Action palette (prompts / inline / cmd) |

### Chat-buffer keys (buffer-local, plugin defaults)

> Active inside the chat / inline windows only.

| Key | Mode | Action |
|-----|------|--------|
| `<C-s>` / `<CR>` | n / n, i | Submit prompt |
| `?` | n | Show all keymaps |
| `ga` | n | Change adapter / model |
| `gr` | n | Regenerate response |
| `gs` | n | Edit system prompt |
| `gM` | n | Clear rules |
| `gx` | n | Clear chat |
| `gy` | n | Yank code block |
| `gc` | n | Codeblock actions |
| `gR` | n | Go to file under cursor |
| `}}` / `{{` | n | Next / previous chat |
| `]]` / `[[` | n | Next / previous heading |
| `gtx` / `gty` | n | Cycle approval mode / YOLO |
| `gv` | n | View diff |
| `g1` – `g4` | n | Always-accept / accept / reject / cancel |
| `ga` / `gr` / `u` | n | Accept / reject / undo hunk |
| `]h` / `[h` | n | Next / previous hunk |

---

## herdr-nvim — herdr bridge (`<leader>h`)

> The annotation flow between Neovim and the coding agents running in herdr
> panes. Needs nvim running **inside** a herdr session (herdr exports
> `HERDR_WORKSPACE_ID` / `HERDR_TAB_ID`) and the `herdr` binary on PATH.
> `comment` and `ref` honor the command range, so the visual-mode binds carry
> the selection automatically.

| Key | Mode | Action |
|-----|------|--------|
| `<leader>hc` | n, x | Comment line / selection |
| `<leader>hl` | n | List comments (float) |
| `<leader>hs` | n | Paste comments into the agent input |
| `<leader>hS` | n | Send comments (auto-submit) |
| `<leader>hi` | n, x | Insert `path:line` reference |

> The herdr-side keys (`prefix+e` nvim sidebar, `prefix+o` file picker) live in
> `~/.config/herdr/config.toml` and belong to the Rust half installed with
> `herdr plugin install ChmaraX/herdr-nvim`. See the vault plan
> `200_projects/nixvim-config/review/stage-05-ai-stack-consolidation-plan.md`.
