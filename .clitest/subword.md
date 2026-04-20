```zsh
% typeset -ga _edit_opts=( extendedglob NO_listbeep NO_shortloops )
% emulate -L zsh; setopt $_edit_opts
% source $PWD/.clitest/subword-helper.zsh
% subword-stops forward  'ENV_VAR=value command --option-flag camelCaseWord ~/dir/?*.ext'
forward (21): 3 4 7 8 13 21 24 30 31 35 41 45 49 51 52 55 56 57 58 59 62
% subword-stops backward 'ENV_VAR=value command --option-flag camelCaseWord ~/dir/?*.ext'
backward (21): 59 58 57 56 55 52 51 50 45 41 36 31 30 24 22 14 8 7 4 3 0
% subword-stops forward  'camelCaseWord'
forward (3): 5 9 13
% subword-stops backward 'camelCaseWord'
backward (3): 9 5 0
% subword-stops forward  'a--b/?*.c'
forward (8): 1 3 4 5 6 7 8 9
% subword-stops backward 'a--b/?*.c'
backward (8): 8 7 6 5 4 3 1 0
% subword-stops forward  '   trailing'
forward (1): 11
% subword-stops backward 'leading   '
backward (1): 0
%
```
