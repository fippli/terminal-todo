#!/bin/bash

function mainMenu() {
  echo "|"
  echo "|   - - - - - - - - - - - - - - - - - - - - - - -"
  echo "|"
  echo "|   • • • •    • • • •    • • • •      • • • •  "
  echo "|   • • • •   • • • • •   • •  • •    • • • • • "
  echo "|     • •    • •     • •  • •   • •  • •     • •"
  echo "|     • •     • • • • •   • •  • •    • • • • • "
  echo "|     • •      • • • •    • • • •      • • • •  "
  echo "|"
  echo "|   - - - - - - - - - - - - - - - - - - - - - - -"
  readTasks
  echo "|"
  echo "|   - - - - - - - - - - - - - - - - - - - - - - -"
  read -p  "|   [A]DD TASK / [D]ELETE TASK / [Q]UIT : " CHOICE
  echo "|   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -|"

  if [[ ${CHOICE} == "a" ]]; then
    addTask
  fi

  if [[ ${CHOICE} == "d" ]]; then
    deleteTask
  fi
}

function addTask() {
read -p "|   Enter task: " TASK
echo ${TASK} >> tasks.txt
#cat <<EOT >> tasks.txt
#${TASK}
#EOT
}

function readTasks() {
  i=0
  while IFS='' read -r line || [[ -n "${line}" ]]; do
    i=$((i+1))
    echo "|"
    echo "|   [${i}] ${line}"
  done < "tasks.txt"
}

function deleteTask() {
  read -p "|   SELECT TASK TO DELETE: " DEL
  sed -i.bak "${DEL}d" ./tasks.txt
}

function main() {
  while [[ ${CHOICE} != "q" ]]; do
    mainMenu
  done
  cd ${1}
}

main
