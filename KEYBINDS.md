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

## AI Agents — sidekick / herd (`<leader><tab>`)

> The same keys have **different actions depending on the active backend**
> (switch via `<leader>C` → agents-backend). Default: `herd` standalone,
> `sidekick` when nvim runs inside a herdr pane.

| Key | Mode | herd backend | sidekick backend |
|-----|------|--------------|------------------|
| `<leader><tab>t` | n | Toggle agent float | Toggle CLI terminal |
| `<leader><tab>s` | n | Select agent | Select CLI |
| `<leader><tab>S` | n | Dashboard | — |
| `<leader><tab>f` | n | — | Focus terminal |
| `<leader><tab>p` | n, x | — | Pick prompt |
| `<leader><tab>x` | n, x | — | Send `{this}` to CLI |
| `<leader><tab>e` | n | — | Send `{file}` to CLI |
| `<leader><tab>D` | n | Send LSP diagnostics to agent | — |
| `<leader><tab>j` | n | Jump to `path:line` refs from output (quickfix) | — |
| `<leader><tab>` | x | Send selection to agent | — |
| `<leader><tab>d` | n | — | Detach CLI |

---

## agentic — ACP Chat (`<leader>a`)

> Provider is `opencode-acp`; sessions are interchangeable with the opencode
> terminal TUI.

| Key | Mode | Action |
|-----|------|--------|
| `<leader>at` | n, v | Toggle chat window |
| `<leader>aa` | n, v | Add selection / file to context |
| `<leader>an` | n, v | New session |
| `<leader>ar` | n, v | Restore session |
| `<leader>ad` | n | Add current-line diagnostics to context |
| `<leader>aD` | n | Add buffer diagnostics to context |

> Insert mode is deliberately excluded — `<Space>a` + `t`/`n`/`r` collides with
> ordinary prose (" a t", " a n", " a r"). Model/provider switching lives inside
> the agentic widget (below).

### agentic — widget keys

> Active **inside** the agentic chat/prompt buffers only. `<localleader>` is `\`.

| Key | Mode | Action |
|-----|------|--------|
| `<localleader>m` | n | Switch model (keeps history) |
| `<localleader>s` | n | Switch ACP provider (keeps history) |
| `<localleader>t` | n | Select thought-effort level |
| `<localleader>o` | n | Open options modal |
| `<localleader>l` | n | List live sessions and open one |
| `<localleader>]` / `<localleader>[` | n | Next / previous session |
| `<localleader>D` | n | Destroy current session |
| `<S-Tab>` | n, v, i | Switch agent mode |
| `<CR>` / `<C-s>` | n / n, v, i | Submit prompt |
| `<localleader>p` / `<C-v>` | n / i | Paste image from clipboard |
| `<Tab>` | i | Accept file completion |
| `q` | n | Hide widget (session keeps running) |
| `d` | n, v | Remove file / selection / diagnostic at cursor |
| `]]` / `[[` | n | Next / previous chat heading |
| `]t` / `[t` | n | Next / previous tool call |
| `]c` / `[c` | n | Next / previous diff hunk |

---

## opencode.nvim — Window-Internal Keys

> Active **inside** opencode's input/output windows only (the plugin's global
> keymaps are disabled; our `<leader>o*` binds replace them).

### Input window

| Key | Mode | Action |
|-----|------|--------|
| `<CR>` / `<S-CR>` | n / n, i | Submit prompt |
| `<C-p>` | n, i | Command palette (model/provider, session, agent, variant, timeline) |
| `@` | i | Mention completion (blink menu) |
| `/` | i | Slash-command completion (blink menu) |
| `#` | i | Context-items completion (blink menu) |
| `<M-v>` | i | Paste image from clipboard |
| `<M-m>` | n, i | Switch agent mode (build/plan) |
| `<M-r>` | n, i | Cycle model variants |
| `<M-i>` | n, i | Toggle input window |
| `<up>` / `<down>` | n, i | Prompt history (at buffer boundaries) |
| `<esc>` / `<C-c>` | n | Close windows / cancel request |

> `~` is disabled — it opened the plugin's file picker on a plain character.
> File mentions still work via `@` + the blink completion menu.
> `<C-p>` shadows blink's scroll-documentation-up inside the opencode input
> window only.

### Output window

| Key | Mode | Action |
|-----|------|--------|
| `]]` / `[[` | n | Next / previous message |
| `]u` / `[u` | n | Next / previous *user* message |
| `<tab>` | n | Toggle input/output panes |
| `i` | n | Focus input |
| `gr` | n | Browse code references |
| `gf` / `<CR>` | n | Jump to file / target at cursor |

### Quick-chat context tags

> Prefixes for `<leader>oa` prompts (e.g. `<leader>oa` then `#errors fix these`):
> `#cursor` `#errors` `#warnings` `#info` `#file` `#selection` `#agents` `#buffer` `#git_diff`
