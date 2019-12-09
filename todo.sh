#!/usr/bin/env bash

# To be able to separate the code into several files after creating a symlink
# to ~/bin/todo the path to the source root is good to have.
# The relative paths to the project files can now  be used
# like so $lib_dir/someProjectScript.sh
this_path=${BASH_SOURCE[0]}
lib_dir="$(dirname "$this_path")"
export todo_task_file="${TODO_TASK_FILE:-$lib_dir/.todo}"
export padding="       "
todo_header_file="${TODO_HEADER_FILE:-$lib_dir/table_head.sh}"
no_local=false # Skip reading of local .todo file

# Don't know if there is a better way to do this??
# shellcheck source=/dev/null
. "${lib_dir}/read_tasks.sh"
# shellcheck source=/dev/null
. "${lib_dir}/add_task.sh"
# shellcheck source=/dev/null
. "${lib_dir}/delete_task.sh"
# shellcheck source=/dev/null
. "${lib_dir}/edit_task.sh"
# shellcheck source=/dev/null
. "${lib_dir}/change_selection_up.sh"
# shellcheck source=/dev/null
. "${lib_dir}/change_selection_up.sh"
# shellcheck source=/dev/null
. "${lib_dir}/change_selection_down.sh"
# shellcheck source=/dev/null
. "${lib_dir}/change_selection_down.sh"
# shellcheck source=/dev/null
. "$lib_dir/todo_from_file.sh"


main_menu () {
  printf "\n\n"
  [ -f "$todo_header_file" ] && "$todo_header_file"
  echo "   "
  echo "       - - - - - - - - - - - - - - - - - - - - - -    "
  read_tasks
  echo "       - - - - - - - - - - - - - - - - - - - - - - "
  echo -n "       [A]DD / [D]ELETE / [E]DIT / [Q]UIT: "
  read -s -r -n 1 choice
  echo ""

  if [[ ${choice} == "a" ]]; then
    add_task
  fi

  if [[ ${choice} == "d" ]]; then
    delete_task
  fi

  if [[ ${choice} == "e" ]]; then
    edit_task
  fi

  if [[ ${choice} == "w" ]]; then
    change_selection_up
  fi

  if [[ ${choice} == "k" ]]; then
    change_selection_up
  fi

  if [[ ${choice} == "s" ]]; then
    change_selection_down
  fi

  if [[ ${choice} == "j" ]]; then
    change_selection_down
  fi
}

numeric_or_print_error () {
  number="$1"

  if ! [[ "$number" =~ ^[0-9]+$ ]] ; then
    echo ""
    echo "       ⚠️  Not a valid number!"

    read -r -p "          Press any key to continue..."
    return 0
  fi

  return 1
}

main () {
  [ -f "$todo_task_file" ] || touch "$todo_task_file"

  while [[ ${choice} != "q" ]]; do
    clear
    main_menu
  done

  clear
}

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "todo - Manage TODO lists"
      echo " "
      echo "  --help                             : Print this help text"
      echo "  --task-file (TODO_TASK_FILE)       : Set the file to store TODOs in"
      echo "  --header-file (TODO_HEADER_FILE)   : Set the path to header"
      echo "  --no-color (TODO_NO_COLOR)         : Disable colors if ansi header is used"
      echo "  --random-color (TODO_RANDOM_COLOR) : Use random colors if ansi heade ris used"
      echo "  --no-local                         : Don't use local .todo file even if it exist"
      echo "  --this-dir                         : Create a .todo with every occurance of '# TODO:' or '// TODO:' in the directory files"
      echo " "
      exit 0
      ;;
    --this-dir*)
      todo_from_file
      shift
      exit 0
      ;;
    --task-file*)
      if [[ "$1" =~ ^[^=]+$ ]]; then
        shift
      fi

      # shellcheck disable=SC2001
      todo_task_file=$(echo "$1" | sed -e 's/^[^=]*=//g')
      shift
      ;;
    --header-file)
      if [[ "$1" =~ ^[^=]+$ ]]; then
        shift
      fi

      # shellcheck disable=SC2001
      todo_header_file=$(echo "$1" | sed -e 's/^[^=]*=//g')
      shift
      ;;
    --no-color)
      if [ -n "$TODO_RANDOM_COLOR" ]; then
        echo "Cannot combine --no-color with --random-color"
        exit 1
      fi

      export TODO_NO_COLOR=1
      shift
      ;;
    --random-color*)
      if [ -n "$TODO_NO_COLOR" ]; then
        echo "Cannot combine --no-color with --random-color"
        exit 1
      fi

      export TODO_RANDOM_COLOR=1
      shift
      ;;
    --no-local)
      no_local=true
      shift
      ;;
    *)
      break
      ;;
  esac
done

if [ "$no_local" = "false" ]; then
  [ -f "./.todo" ] && todo_task_file="./.todo"
fi

main

# vim: set ft=sh sw=2 ts=2 et:
