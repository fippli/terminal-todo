#!/usr/bin/env bash

print_tasks () {
  clear
  description="$(get_meta_row "description")"
  printf "\n\n"
  [ -f "$todo_header_file" ] && header
  echo ""
  echo "${padding}${description}"
  echo "${padding}- - - - - - - - - - - - - - - - - - - - - - "
  read_tasks
  echo "${padding}- - - - - - - - - - - - - - - - - - - - - - "
}
