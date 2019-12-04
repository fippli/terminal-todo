#!/usr/bin/env bash

# To be able to separate the code into several files after creating a symlink
# to ~/bin/todo the path to the source root is good to have.
# The relative paths to the project files can now  be used
# like so $lib_dir/someProjectScript.sh
this_path=${BASH_SOURCE[0]}
lib_path=$(readlink ${this_path})
lib_dir=$(dirname $lib_path)

TODO_TASK_FILE="${TODO_TASK_FILE:-$lib_dir/todo.txt}"
TODO_HEADER_FILE="${TODO_HEADER_FILE:-$lib_dir/table_head.sh}"
WARNINGS_SHOWED=false

main_menu () {
  printf "\n\n"
  [ -f "$TODO_HEADER_FILE" ] && "$TODO_HEADER_FILE"
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
  NUMBER="$1"

  if ! [[ "$NUMBER" =~ ^[0-9]+$ ]] ; then
    echo ""
    echo "       ⚠️  Not a valid number!"

    read -r -p "          Press any key to continue..."
    return 0
  fi

  return 1
}

add_task () {
  read -r -e -p "       ENTER NEW TASK: " task
  echo "${task}" >> "$TODO_TASK_FILE"
}

edit_task () {
  if [ "${BASH_VERSINFO:-0}" -lt 4 ] && [ "$WARNINGS_SHOWED" = false ]; then
    echo ""
    echo "       ⚠️  Your version of bash doesn't support the -i flag to 'read'."
    echo "       Because of this your task cannot be pre-filled for editing."
    echo ""
    echo "       If you're on macOS, remember that you can install a newer
       version of bash with 'brew install bash'."
    echo ""

    WARNINGS_SHOWED=true
  fi

  read -r -e -p "       SELECT TASK TO EDIT: " LINE

  if numeric_or_print_error "$LINE" == 0; then
      return
  fi

  task=$(sed -n "${LINE}"p "$TODO_TASK_FILE")

  # Don't (try) to pre fill the prompt on old bash versions.
  if [ "${BASH_VERSINFO:-0}" -lt 4 ]; then
    read -r -e -p "       EDIT TASK: " edited_task
  else
    read -r -e -p "       EDIT TASK: " -i "$task" edited_task
  fi

  # Since macOS comes with old BSD version of sed we cannot insert at a specific
  # line, instead we replace it with regexp.
  # With GNU sed this would be 'sed -i.bak "${LINE}i${LINE} $edited_task"'
  sed -i.bak "${LINE}s/.*/$edited_task/" "$TODO_TASK_FILE"
}

read_tasks () {
  # Count the lines ins the file
  LINES=$( wc -l < "$TODO_TASK_FILE" )
  i=0
  echo ""
  while [[ $i -lt $((LINES)) ]]; do
    i=$((i+1))
    printf "       [%s] %s\n\n" "$i"  "$( sed "${i}q;d" "$TODO_TASK_FILE" )"
  done
}

delete_task () {
  read -r -e -p "       SELECT TASK TO DELETE: " DEL

  if numeric_or_print_error "$DEL" == 0; then
      return
  fi

  sed -i.bak "${DEL}d" "$TODO_TASK_FILE"
}

main () {
  [ -f "$TODO_TASK_FILE" ] || touch "$TODO_TASK_FILE"

  while [[ ${choice} != "q" ]]; do
    clear
    main_menu
  done
}

main
