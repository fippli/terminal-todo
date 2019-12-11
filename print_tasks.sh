#!/usr/bin/env bash

print_tasks () {
  clear
  printf "\n\n"
  [ -f "$todo_header_file" ] && header
  echo ""
  echo "${padding}- - - - - - - - - - - - - - - - - - - - - -    "
  read_tasks
  echo "${padding}- - - - - - - - - - - - - - - - - - - - - - "
}
