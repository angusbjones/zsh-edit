#!/bin/zsh
# Helper for .clitest/subword.md — drives .edit.move-word outside ZLE by
# managing LBUFFER/RBUFFER/CURSOR manually and sourcing the widget each step.

subword-stops() {
  local dir=$1 buf=$2
  local WIDGET=.${dir}-subword
  local +h WORDCHARS=
  typeset -gi CURSOR
  typeset -g LBUFFER= RBUFFER=
  if [[ $dir == backward ]]; then
    CURSOR=${#buf}
  else
    CURSOR=0
  fi
  local stops=() prev=
  while :; do
    LBUFFER=${buf[1,CURSOR]}
    RBUFFER=${buf[CURSOR+1,-1]}
    prev=$CURSOR
    source $PWD/functions/.edit.move-word
    (( CURSOR == prev )) && break
    stops+=( $CURSOR )
  done
  print -r -- "${dir} (${#stops}): ${stops[*]}"
}
