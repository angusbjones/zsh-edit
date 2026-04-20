
# Zsh Edit

_Zsh Edit_ is a set of handy utilities for making life easier on the Zsh command line.

> **About this fork.** This is a trimmed fork of [marlonrichert/zsh-edit](https://github.com/marlonrichert/zsh-edit) that ships the navigation widgets (subword/shell-word movement + kills, line/buffer movement, Redo) and the `bind` command.  The clipboard viewer, find-replace, recover-line, repeat-word, reverse-yank-pop, and the extra line-kill shortcuts are commented out in `functions/zsh-edit` — uncomment the relevant block to re-enable any of them.  The widget source files are untouched.


## Requirements

Tested to work with Zsh 5.8 and newer.


## Installating & updating

I recommend using [Znap](https://github.com/marlonrichert/zsh-snap) or installing the plugin manually.  You can also
install it using any 3rd-party framework or plugin manager you like, but I won't document that here.


### Using Znap

Aust add this to your `.zshrc` file:
```zsh
znap source marlonrichert/zsh-edit
```
To update, run `znap pull`.


### Manually

1. Clone the repo:
   ```zsh
   % git clone --depth 1 https://github.com/marlonrichert/zsh-edit.git
   ```
1. Source the plugin in your `.zshrc` file:
   ```zsh
   source <your plugins dir>/zsh-edit/zsh-edit.plugin.zsh
   ```
1. Restart your shell:
   ```zsh
   exec zsh
   ```
To update:
```zsh
% cd <your plugins dir>/zsh-edit
% git pull
```


## `bind` Command

`bind` is a drop-in extension of Zsh's built-in [`bindkey`](https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Zle-Builtins): it accepts the same keymap flags (e.g. `-M emacs`) and the same `KEY WIDGET` pairs, but it also lets you bind ordinary shell commands.  When the second argument isn't a widget name, `bind` wraps it as a throwaway ZLE widget so the command runs without accepting or clearing your current line:
```zsh
bind  '^[:' 'cd ..'
bind  '^[-' 'pushd -1' \
      '^[=' 'pushd +0'
```
The wrapping widget is named with a leading `.` so that `zsh-autosuggestions` and `zsh-syntax-highlighting` ignore it.

List duplicate keybindings in the main keymap or another one.
```zsh
bind -d
bind -dM viins
```

List unused keybindings in the main keymap or another one.
```zsh
bind -u
bind -uM emacs
```

Look up which combination of keys could generate an escape sequence listed by `bind` or `bindkey`.
```zsh
% bind -n '^[[5~' '^[^[OA'
"^[[5~"    PageUp
"^[^[OA"   Alt-Up
```


## Key Bindings

_Zsh Edit_ adds the keyboard shortcuts below to your `main` and `emacs` keymaps.
* By default, the `emacs` keymap is your `main` keymap.
* However, if you use `vi` mode, then your `main` keymap will be the `viins` keymap.

All key bindings can be modified through [Zsh's `bindkey`
command](https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Zle-Builtins), _after_ sourcing _Zsh Edit_.

⚠️ Note:
* Not all terminals support all key bindings.
* In some terminals, instead of <kbd>Alt</kbd>, you'll have to press <kbd>Esc</kbd> or <kbd>Ctrl</kbd><kbd>[</kbd>.
* In many terminals, <kbd>Home</kbd>, <kbd>End</kbd>, <kbd>PgUp</kbd> and <kbd>PgDn</kbd> scroll the terminal buffer and
  don't send any keystrokes to the shell.  To use these keys in the shell, you'll have to hold an additional modifier
  key, usually <kbd>Shift</kbd>.  Refer to your terminal's documentation and/or settings for more info.

|Command|`emacs` keymap|`main` keymap||
|-|-:|-:|-:
|Redo (reverse Undo)                                                                         |<kbd>Alt</kbd><kbd>/</kbd>
||
|Backward [subword](#subword-movement)|<kbd>Ctrl</kbd><kbd>Alt</kbd><kbd>B</kbd>  |<kbd>Ctrl</kbd><kbd>←</kbd>|<kbd>Ctrl</kbd><kbd>Alt</kbd><kbd>←</kbd>
|Forward [subword](#subword-movement) |<kbd>Ctrl</kbd><kbd>Alt</kbd><kbd>F</kbd>  |<kbd>Ctrl</kbd><kbd>→</kbd>|<kbd>Ctrl</kbd><kbd>Alt</kbd><kbd>→</kbd>
|Backward shell word                  |<kbd>Alt</kbd><kbd>B</kbd>                 |<kbd>Alt</kbd><kbd>←</kbd> |<kbd>Shift</kbd><kbd>←</kbd>
|Forward shell word                   |<kbd>Alt</kbd><kbd>F</kbd>                 |<kbd>Alt</kbd><kbd>→</kbd> |<kbd>Shift</kbd><kbd>→</kbd>
|Beginning of line                    |<kbd>Ctrl</kbd><kbd>A</kbd>                |<kbd>Home</kbd>            |<kbd>Ctrl</kbd><kbd>X</kbd> <kbd>←</kbd>
|End of line                          |<kbd>Ctrl</kbd><kbd>E</kbd>                |<kbd>End</kbd>             |<kbd>Ctrl</kbd><kbd>X</kbd> <kbd>→</kbd>
|Beginning of buffer                  |<kbd>Alt</kbd><kbd><</kbd>                 |<kbd>PgUp</kbd>            |<kbd>Ctrl</kbd><kbd>X</kbd> <kbd>↑</kbd>
|End of buffer                        |<kbd>Alt</kbd><kbd>></kbd>                 |<kbd>PgDn</kbd>            |<kbd>Ctrl</kbd><kbd>X</kbd> <kbd>↓</kbd>
||
|Backward delete character                  |                                         |<kbd>⌫</kbd>
|Forward delete character                   |                                         |<kbd>⌦</kbd>
|Backward kill [subword](#subword-movement) |<kbd>Ctrl</kbd><kbd>H</kbd>              |<kbd>Ctrl</kbd><kbd>⌫</kbd>                |<kbd>Alt</kbd><kbd>Ctrl</kbd><kbd>⌫</kbd>
|Forward kill [subword](#subword-movement)  |<kbd>Ctrl</kbd><kbd>Alt</kbd><kbd>D</kbd>|<kbd>Ctrl</kbd><kbd>⌦</kbd>                |<kbd>Alt</kbd><kbd>Ctrl</kbd><kbd>⌦</kbd>
|Backward kill shell word                   |<kbd>Ctrl</kbd><kbd>W</kbd>              |<kbd>Alt</kbd><kbd>⌫</kbd>                 |<kbd>Shift</kbd><kbd>⌫</kbd>
|Forward kill shell word                    |<kbd>Alt</kbd><kbd>D</kbd>               |<kbd>Alt</kbd><kbd>⌦</kbd>                 |<kbd>Shift</kbd><kbd>⌦</kbd>

The following bindings from upstream are commented out in `functions/zsh-edit` — uncomment to re-enable:

|Command|`emacs` keymap|`main` keymap||
|-|-:|-:|-:
|Recover last line aborted with <kbd>Ctrl</kbd><kbd>C</kbd> or <kbd>Ctrl</kbd><kbd>G</kbd>   |<kbd>Ctrl</kbd><kbd>Alt</kbd><kbd>G</kbd>
|[Replace all](#Replace-all-occurences-of-a-character)                                       |<kbd>Ctrl</kbd><kbd>]</kbd>
|[Reverse yank pop](#clipboard-viewer)                                                       |<kbd>Alt</kbd><kbd>Y</kbd>
|Repeat word up                                                                              |<kbd>Alt</kbd><kbd>.</kbd>
|Repeat word down                                                                            |<kbd>Alt</kbd><kbd>,</kbd>
|Repeat word left                                                                            |<kbd>Ctrl</kbd><kbd>Alt</kbd><kbd>-</kbd>
|Repeat word right                                                                           |<kbd>Alt</kbd><kbd>Shift</kbd><kbd>-</kbd>
|Backward kill line (extra combos — stock <kbd>Ctrl</kbd><kbd>U</kbd> still works)           |                             |<kbd>Ctrl</kbd><kbd>Shift</kbd><kbd>⌫</kbd>|<kbd>Ctrl</kbd><kbd>X</kbd> <kbd>⌫</kbd>
|Forward kill line (extra combos — stock <kbd>Ctrl</kbd><kbd>K</kbd> still works)            |                             |<kbd>Ctrl</kbd><kbd>Shift</kbd><kbd>⌦</kbd>|<kbd>Ctrl</kbd><kbd>X</kbd> <kbd>⌦</kbd>

The clipboard viewer also depends on a `precmd` hook that's commented out with the yank widgets.


## Replace All Occurences of a Character

> _Disabled by default in this fork.  Uncomment the `find-replace-char` block in `functions/zsh-edit` to re-enable._

Press <kbd>Ctrl</kbd><kbd>]</kbd> followed by two characters and each substring consisting of one or
more occurences of the first character will be replaced entirely with the second character.  This is
useful, for example, if you pasted a list of files separated by line breaks into the command line,
but you need them to be separated with spaces instead.

If you've just pasted something or the region is active, only the pasted or selected text is
affected.  This way, you can find-and-replace selectively.  Otherwise, this widget always operates
on the whole command line.


## Clipboard Viewer

> _Disabled by default in this fork.  Uncomment the clipboard-viewer block (yank widgets + `precmd` plumbing) in `functions/zsh-edit` to re-enable, along with the `reverse-yank-pop` binding just below it._

Whenever you use <kbd>yank</kbd> (`^Y` in `emacs`), <kbd>vi-put-after</kbd> (`p` in `vicmd`) or
<kbd>vi-put-after</kbd> (`P` in `vicmd`) to paste a kill into the command line, _Zsh Edit_ will list
the contents of your kill ring (including the cut buffer) below your command line.

Additionally, _Zsh Edit_ adds a new widget <kbd>reverse-yank-pop</kbd>, which lets you cycle in the
opposite direction.  It is bound to `^[Y` in the `emacs` keymap.


## Subword Movement

Zsh's widgets <kbd>forward-word</kbd>, <kbd>backward-word</kbd>, <kbd>kill-word</kbd> and <kbd>backward-kill-word</kbd>
fail to stop on many of the positions that we humans see as word boundaries:

```zsh
# Zsh with default WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>' moves/deletes way too much:
#              >       >             >             >          >
% ENV_VAR=value command --option-flag camelCaseWord ~/dir/*.ext
# <             <       <             <             <

# Zsh with  WORDCHARS='' is bit better, but skips punctuation clusters & doesn't find subWords:
#    >   >     >         >      >    >               >     >
% ENV_VAR=value command --option-flag camelCaseWord ~/dir/*.ext
# <   <   <     <         <      <    <               <     <
```

_Zsh Edit_ adds new widgets with better parsing rules that can find all the word boundaries that matter to us as humans.
Additionally, it adds smarter movement: If the cursor is inside a word, it will move to the beginning or end of that
same word, not the next one.  This way, you can quickly toggle between the beginning and the end of each word.

For example:

```zsh
# Zsh Edit with WORDCHARS=''
#   >   >     >       >  >     >    >     >   >   >  >  >      >
% ENV_VAR=value command --option-flag camelCaseWord ~/dir/?*.ext
# <   <   <     <       < <      <    <    <   <    < <      <
```

To stop a character from being treated as a subword separator, simply add it to `$WORDCHARS`.  For example, by treating
`~`, `*` and `?` as word characters, you can get more precise subword movement in path strings:

```zsh
# Zsh Edit with WORDCHARS='~*?'
#  > >   >  >   >
% cd ~/dir/?*.ext
# <  < <   <  <
```

If you don't want to change your `$WORDCHARS` globally, you can instead use the following:

```zsh
zstyle ':edit:*' word-chars '~*?'
```

This will change `$WORDCHARS` only for the widgets provided by Zsh Edit.  The key format is `:edit:<widget-name>:` (with a trailing colon), so you can also scope overrides to a single widget — for example, to keep `_` as a boundary when moving forward but not when moving backward:

```zsh
zstyle ':edit:backward-subword:' word-chars '_'
```

Only the subword family (`{forward,backward,kill,backward-kill}-subword`) reads this zstyle; shell-word widgets parse the buffer via Zsh's shell lexer and ignore `$WORDCHARS` entirely.


## Author

© 2020-2025 [Marlon Richert](https://github.com/marlonrichert)


## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
