#!/usr/bin/env bash

ansii_shadow() {
  local T="${1:-$W}"
  local O="${2:-$W}"
  local D="${3:-$W}"
  local OO="${4:-$W}"

  printf "${T}${padding}████████╗${O} ██████╗ ${D}██████╗ ${OO} ██████╗ \n"
  printf "${T}${padding}╚══██╔══╝${O}██╔═══██╗${D}██╔══██╗${OO}██╔═══██╗\n"
  printf "${T}${padding}   ██║   ${O}██║   ██║${D}██║  ██║${OO}██║   ██║\n"
  printf "${T}${padding}   ██║   ${O}██║   ██║${D}██║  ██║${OO}██║   ██║\n"
  printf "${T}${padding}   ██║   ${O}╚██████╔╝${D}██████╔╝${OO}╚██████╔╝\n"
  printf "${T}${padding}   ╚═╝   ${O} ╚═════╝ ${D}╚═════╝ ${OO} ╚═════╝ \n${NONE}"
}

init_colors() {
  NONE="\033[0m"    # Reset terminal color

  COLOR_BLACK="\033[0;30m" # Black
  COLOR_0="\033[0;31m"     # Red
  COLOR_1="\033[0;32m"     # Green
  COLOR_2="\033[0;33m"     # Yellow
  COLOR_3="\033[0;34m"     # Blue
  COLOR_4="\033[0;35m"     # Magenta
  COLOR_5="\033[0;36m"     # Cyan
  COLOR_6="\033[0;37m"     # White
}

set_random_colors() {
  init_colors

  local NUM_COLORS=7

  C1="COLOR_$(( "$RANDOM" % "$NUM_COLORS" ))"
  C2="COLOR_$(( "$RANDOM" % "$NUM_COLORS" ))"
  C3="COLOR_$(( "$RANDOM" % "$NUM_COLORS" ))"
  C4="COLOR_$(( "$RANDOM" % "$NUM_COLORS" ))"
}

set_colors() {
  init_colors

  C1="COLOR_0"
  C2="COLOR_2"
  C3="COLOR_4"
  C4="COLOR_5"
}

if [ -n "$TODO_NO_COLOR" ]; then
  ansii_shadow
else
  if [ -n "$TODO_RANDOM_COLOR" ]; then
    set_random_colors
  else
    set_colors
  fi

  ansii_shadow "${!C1}" "${!C2}" "${!C3}" "${!C4}"
fi

# vim: set ft=sh ts=2 sw=2 et:
