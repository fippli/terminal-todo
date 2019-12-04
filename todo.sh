#!/usr/bin/env bash

# To be able to separate the code into several files after creating a symlink
# to ~/bin/todo the path to the source root is good to have.
# The relative paths to the project files can now  be used
# like so $lib_dir/someProjectScript.sh
this_path=${BASH_SOURCE[0]}
lib_dir="$(dirname "$this_path")"

todo_task_file="${TODO_TASK_FILE:-$lib_dir/todo.txt}"
todo_header_file="${TODO_HEADER_FILE:-$lib_dir/table_head.sh}"
warnings_showed=false

main_menu () {
  printf "\n\n"
  [ -f "$todo_header_file" ] && "$todo_header_file"
  echo "   "
  echo "       - - - - - - - - - - - - - - - - - - - - - -    "
  read_tasks
  echo "       - - - - - - - - - - - - - - - - - - - - - - "
  read -r -e -p  "       [A]DD / [D]ELETE / [E]DIT / [Q]UIT : " choice

  if [[ ${choice} == "a" ]]; then
    add_task
  fi

  if [[ ${choice} == "d" ]]; then
    delete_task
  fi

  if [[ ${choice} == "e" ]]; then
    edit_task
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

add_task () {
  read -r -e -p "       ENTER NEW TASK: " task
  echo "${task}" >> "$todo_task_file"
}

edit_task () {
  if [ "${BASH_VERSINFO:-0}" -lt 4 ] && [ "$warnings_showed" = false ]; then
    echo ""
    echo "       ⚠️  Your version of bash doesn't support the -i flag to 'read'."
    echo "       Because of this your task cannot be pre-filled for editing."
    echo ""
    echo "       If you're on macOS, remember that you can install a newer
       version of bash with 'brew install bash'."
    echo ""

    warnings_showed=true
  fi

  read -r -e -p "       SELECT TASK TO EDIT: " line

  if numeric_or_print_error "$line" == 0; then
      return
  fi

  task=$(sed -n "${line}"p "$todo_task_file")

  # Don't (try) to pre fill the prompt on old bash versions.
  if [ "${BASH_VERSINFO:-0}" -lt 4 ]; then
    read -r -e -p "       EDIT TASK: " edited_task
  else
    read -r -e -p "       EDIT TASK: " -i "$task" edited_task
  fi

  # Since macOS comes with old BSD version of sed we cannot insert at a specific
  # line, instead we replace it with regexp.
  # With GNU sed this would be 'sed -i.bak "${line}i${line} $EDITED_TASK"'
  sed -i.bak "${line}s/.*/$edited_task/" "$todo_task_file"
}

read_tasks () {
  # Count the lines ins the file
  lines=$( wc -l < "$todo_task_file" )
  i=0
  echo ""
  while [[ $i -lt $((lines)) ]]; do
    i=$((i+1))
    printf "       [%s] %s\n\n" "$i"  "$( sed "${i}q;d" "$todo_task_file" )"
  done
}

delete_task () {
  read -r -e -p "       SELECT TASK TO DELETE: " del

  if numeric_or_print_error "$del" == 0; then
      return
  fi

  sed -i.bak "${del}d" "$todo_task_file"
}

main () {
  [ -f "$todo_task_file" ] || touch "$todo_task_file"

  while [[ ${choice} != "q" ]]; do
    clear
    main_menu
  done
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
      echo "  --this-dir                         : Create a .todo.txt with every occurance of '# TODO:' or '// TODO:' in the directory files"
      echo " "
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
    --header-file*)
      if [[ "$1" =~ ^[^=]+$ ]]; then
        shift
      fi

      # shellcheck disable=SC2001
      todo_header_file=$(echo "$1" | sed -e 's/^[^=]*=//g')
      shift
      ;;
    --no-color*)
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
    *)
      break
      ;;
  esac
done

main

# vim: set ft=sh sw=2 ts=2 et:
