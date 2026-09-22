# Ownership Inventory — AI surfaces & terminals

> Date: 2026-09-22. Source: Stage 01 S2/S3 + Stage 02 P12/P16. No code changes —
> this file records which surface owns which job so future additions don't
> duplicate an existing one.

## AI surfaces

| Surface | Entry | Shape | Owns | Does NOT own |
|---|---|---|---|---|
| **sidekick.nvim** | `<leader><tab>*` (backend A) | In-editor CLI terminal | CLI agent sessions (Claude/Codex/…), NES completion (deliberately disabled) | Chat UI, ACP sessions |
| **herd.nvim** | `<leader><tab>*` (backend B) | Floating terminal | Spawnable agent CLIs (opencode/claude/…) in a float | Chat UI, ACP sessions |
| **opencode.nvim** | `<leader>o*` | Embedded opencode window (own server) | opencode-native workflow: quick chat, sessions, diff view, snapshots, MCP picker, skills browser, timeline, `<C-p>` palette | Non-opencode providers |
| **agentic.nvim** | `<leader>a*` | ACP chat sidebar | Provider-agnostic ACP chat (opencode-acp by default), model/provider switching, session restore, permissions + diff preview | opencode-specific features (quick chat, snapshots, MCP picker) |

Backend swap: `vim.g.agents_backend` toggled via `<leader>C` (config dashboard);
`lua/agent_backend.lua` installs the active backend's `<leader><tab>*` keymaps.

**Rule of thumb:** opencode-specific work → opencode.nvim; provider-agnostic
chat / ACP → agentic.nvim; a quick CLI agent in a terminal → sidekick/herd.

## Terminals

| Terminal | Entry | Lifetime | Owns |
|---|---|---|---|
| **snacks.terminal** | `<C-\>` (normal), `<C-/>` (float), `<leader>ot` (opencode CLI) | Throwaway | Ad-hoc shells, the raw `opencode` CLI |
| **betterTerm** | `<leader>Xt`, `<leader>X1..5`, send keys `<leader>Xs/Xv/Xf` | Persistent, numbered tabs | Interactive REPLs: `snow sql` (bare = REPL), dbt, astro/airflow shells |
| **sidekick CLI terminal** | `<leader><tab>*` (backend A) | Session-scoped | CLI agent sessions |
| **herd float** | `<leader><tab>*` (backend B) | Session-scoped | CLI agent sessions |
| **opencode window** | `<leader>og` | Plugin-managed | opencode chat/session UI |
| **agentic chat** | `<leader>at` | Plugin-managed | ACP chat |

**Rule of thumb:** one-shot task output → overseer pane; interactive REPL →
betterTerm; throwaway shell → snacks.terminal; agent CLI → sidekick/herd.

## lazyvim-config (S13)

`lazyvim-config/` is a documented stub: it imports `dependencies.nix` +
`plugins.nix` (LazyVim + lazy.nvim bootstrap) and clones `lazy.nvim` from
GitHub at runtime — impure by Nix standards, breaks offline/Docker builds, and
`checker.enabled = true` phones home for updates. It is still built as a
package, check, app, and Docker image. Status: WIP — decide later whether to
exclude it from CI/Docker until it is real, or to remove it.