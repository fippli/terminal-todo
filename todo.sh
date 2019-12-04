#!/usr/bin/env bash

TODO_TASK_FILE="${TODO_TASK_FILE:-./todo.txt}"
TODO_HEADER_FILE="${TODO_HEADER_FILE:-./tableHead.sh}"
WARNINGS_SHOWED=false

function mainMenu() {
  printf "\n\n"
  [ -f "$TODO_HEADER_FILE" ] && "$TODO_HEADER_FILE"
  echo "   "
  echo "       - - - - - - - - - - - - - - - - - - - - - -    "
  readTasks
  echo "       - - - - - - - - - - - - - - - - - - - - - - "
  read -r -e -p  "       [A]DD / [D]ELETE / [E] EDIT / [Q]UIT : " CHOICE

  if [[ ${CHOICE} == "a" ]]; then
    addTask
  fi

  if [[ ${CHOICE} == "d" ]]; then
    deleteTask
  fi

  if [[ ${CHOICE} == "e" ]]; then
    editTask
  fi
}

numericOrPrintError() {
  NUMBER="$1"

  if ! [[ "$NUMBER" =~ ^[0-9]+$ ]] ; then
    echo ""
    echo "       ⚠️  Not a valid number!"

    read -r -p "          Press any key to continue..."
    return 0
  fi

  return 1
}

function addTask() {
  read -r -e -p "       ENTER NEW TASK: " TASK
  echo "${TASK}" >> "$TODO_TASK_FILE"
}

editTask () {
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

  if numericOrPrintError "$LINE" == 0; then
      return
  fi

  TASK=$(sed -n "${LINE}"p "$TODO_TASK_FILE")

  # Don't (try) to pre fill the prompt on old bash versions.
  if [ "${BASH_VERSINFO:-0}" -lt 4 ]; then
    read -r -e -p "       EDIT TASK: " EDITED_TASK
  else
    read -r -e -p "       EDIT TASK: " -i "$TASK" EDITED_TASK
  fi

  # Since macOS comes with old BSD version of sed we cannot insert at a specific
  # line, instead we replace it with regexp.
  # With GNU sed this would be 'sed -i.bak "${LINE}i${LINE} $EDITED_TASK"'
  sed -i.bak "${LINE}s/.*/$EDITED_TASK/" "$TODO_TASK_FILE"
}

function readTasks() {
  # Count the lines ins the file
  LINES=$( wc -l < "$TODO_TASK_FILE" )
  i=0
  echo ""
  while [[ $i -lt $((LINES)) ]]; do
    i=$((i+1))
    printf "       [%s] %s\n\n" "$i"  "$( sed "${i}q;d" "$TODO_TASK_FILE" )"
  done
}

function deleteTask() {
  read -r -e -p "       SELECT TASK TO DELETE: " DEL

  if numericOrPrintError "$DEL" == 0; then
      return
  fi

  sed -i.bak "${DEL}d" "$TODO_TASK_FILE"
}

function main() {
  [ -f "$TODO_TASK_FILE" ] || touch "$TODO_TASK_FILE"

  while [[ ${CHOICE} != "q" ]]; do
    clear
    mainMenu
  done
}

main
