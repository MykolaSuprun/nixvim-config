# Ownership Inventory — AI surfaces & terminals

> Updated 2026-11-07. Records which surface owns which job so future additions
> don't duplicate an existing one. (The earlier herd.nvim / opencode.nvim /
> agentic.nvim surfaces and the `<leader>C` backend-swap dashboard are gone.)

## AI surfaces

| Surface | Entry | Shape | Owns | Does NOT own |
|---|---|---|---|---|
| **sidekick.nvim** | `<leader><tab>*`, `<c-.>` focus | In-editor terminal running an AI CLI (opencode / claude) | CLI agent sessions with editor context (`{this}`, `{file}`, `{selection}`), snacks-picker → agent send (`<a-a>`). NES is deliberately disabled (needs Copilot LSP). | Chat UI, ACP sessions |
| **codecompanion.nvim** | `<leader>a*` | Chat buffer / inline edit / action palette | Chat over ACP (opencode `acp`), inline edits + `:CodeCompanionCmd` via LM Studio, code review, saved chats (`codecompanion-history`), herdr state reporting | Long-running CLI agent sessions |
| **herdr-nvim** | `<leader>h*` | Bridge to herdr agent panes | Annotating lines/selections and sending them (or `path:line` refs) to an agent pane in the surrounding herdr session | Running agents itself (herdr does) |

**Rule of thumb:** a quick agent CLI in a split → sidekick; provider-agnostic
chat / inline edit → codecompanion; hand context to an agent already running
in a herdr pane → herdr-nvim.

## Terminals

| Terminal | Entry | Lifetime | Owns |
|---|---|---|---|
| **snacks.terminal** | `<C-\>` (split), `<C-/>` / `<C-_>` (float) | Throwaway | Ad-hoc shells; the sqlit TUI (`<leader>Qsi`) |
| **betterTerm** | `<leader>Xt`, `<leader>X1..5`, send keys `<leader>Xs/Xv/Xf` | Persistent, numbered tabs | Interactive REPLs: `snow sql` (bare = REPL), dbt, astro/airflow shells |
| **sidekick CLI terminal** | `<leader><tab>*` | Session-scoped | AI CLI agent sessions |
| **overseer output pane** | `<leader>O*`, `<leader>Qo` | One-shot per task | Build / test / lint / dbt / Snowflake template output |

**Rule of thumb:** one-shot task output → overseer pane; interactive REPL →
betterTerm; throwaway shell → snacks.terminal; agent CLI → sidekick.
