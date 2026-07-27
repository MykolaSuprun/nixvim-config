# Keybinds Reference

Keybinds that are **not** visible in which-key (insert-mode, non-leader, plugin-internal, function-keys) and are not plain Neovim defaults.
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
