#!/bin/bash

function mainMenu() {
  printf "\n\n"
  ./tableHead.sh
  echo "   "
  echo "       - - - - - - - - - - - - - - - - - - - - - -    "
  readTasks
  echo "       - - - - - - - - - - - - - - - - - - - - - - "
  read -p  "       [A]DD TASK / [D]ELETE TASK / [Q]UIT : " CHOICE

  if [[ ${CHOICE} == "a" ]]; then
    addTask
  fi

  if [[ ${CHOICE} == "d" ]]; then
    deleteTask
  fi

}



function addTask() {
  read -p "       ENTER NEW TASK: " TASK
  echo ${TASK} >> todo.txt
}

function readTasks() {
  # Count the lines ins the file
  LINES=$( wc -l < ./todo.txt )
  i=0
  echo ""
  while [[ $i -lt $((LINES)) ]]; do
    i=$((i+1))
    printf "       [${i}] $( sed "${i}q;d" ./todo.txt )\n\n"
  done
}

function deleteTask() {
  read -p "       SELECT TASK TO DELETE: " DEL
  sed -i.bak "${DEL}d" "./todo.txt"
}

function main() {
  while [[ ${CHOICE} != "q" ]]; do
    clear
    mainMenu
  done
}

main
