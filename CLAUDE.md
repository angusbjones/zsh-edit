# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Zsh plugin that extends the Zsh Line Editor (ZLE) with better word/subword movement, a scriptable `bind` command, a clipboard viewer, and several editing widgets. Upstream: marlonrichert/zsh-edit.

## Commands

- Tests: `./run-tests.zsh` — runs every `.clitest/*.md` file through `clitest` (a git submodule under `clitest/`) inside an isolated `env -i` zsh with `-f`. After cloning, initialize submodules with `git submodule update --init` or the test runner will not find the `clitest` tool.
- CI: `.github/workflows/clitest.yml` runs the same script on macOS and Ubuntu.

`.clitest/*.md` files are the test spec — each fenced zsh block with `%` prompts is a scenario. Add new tests by appending a prompt/expected-output pair, not by touching the harness.

## Architecture

Entry point `zsh-edit.plugin.zsh` sets `_edit_opts` (a **global** array of zsh options every file re-applies via `setopt $_edit_opts`) and autoloads the functions from `functions/`. All files must keep those options in effect — in particular `warncreateglobal`, so every top-level assignment needs `typeset`/`local`/`-g`.

Layering inside `functions/`:
- `zsh-edit` — one-shot setup script. Defines the terminal escape-sequence arrays (`shift_left`, `alt_ctrl_right`, etc.), registers every ZLE widget with `zle -N`, binds them across `emacs`/`main`/`menuselect` keymaps via the local `.edit.bind` helper, and wires into `zsh-autosuggestions` (`ZSH_AUTOSUGGEST_IGNORE_WIDGETS`, `ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS`) through a one-shot `precmd` hook that self-removes.
- `bind` — user-facing command. Dispatches on `-d` (duplicates), `-n` (escape sequence → human-readable name), `-u` (unused keys), or falls through to `bindkey`. When binding a command string to a key, it wraps the command as a `.`-prefixed ZLE widget backed by `.edit.execute-cmd`.
- `.edit.*` — widget implementations. Widget name is read from `$WIDGET`, so one file often powers several widgets (e.g. `.edit.move-word` handles all eight `{backward-,forward-,backward-kill-,kill-}{sub,shell-}word` variants by pattern-matching `$WIDGET`). The `.` prefix is deliberate: it tells autosuggestions and syntax-highlighting to ignore these widgets.
- `_bind` — zsh completion spec for the `bind` command (`#compdef bind`).

Integration conventions to preserve:
- Per-widget config goes through `zstyle ':edit:<widget>:' word-chars ...` and `zstyle ':autocomplete:<widget>:*' ignore yes`. Don't hardcode `$WORDCHARS` overrides.
- When adding a widget, register it with `zle -N` in `zsh-edit` **and** add the `.`-prefixed version to the relevant autosuggest arrays if it mutates buffer/cursor.
- `.edit.execute-cmd` relies on `$CONTEXT` (`start` vs `cont`) to decide between `push-line`+`accept-line` and the PS2 path — preserve that branch when editing.

Shell-word movement in `.edit.move-word` parses via `${(z)BUFFER}` (Zsh's shell lexer) because naive word splitting mis-parses quoted/globbed buffers; subword movement uses `[[:WORD:]]`/`WORDCHARS` with a `[[:lower:]]*[[:upper:]]` rule for camelCase boundaries. Both paths share the same kill/move tail at the bottom of the file.
