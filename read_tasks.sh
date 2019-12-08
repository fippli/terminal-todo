#!/usr/bin/env bash

todo_task_file=$1
padding="       "
bold=$(tput bold)
normal=$(tput sgr0)

lines=$( wc -l < "$todo_task_file" )
i=0
echo ""

while [[ $i -lt $((lines)) ]]; do
  i=$((i+1))
  task_line="$( sed "${i}q;d" "$todo_task_file" )"
  task="$(echo $task_line| cut -d']' -f 2)"
  task_status="$(echo $task_line| cut -d']' -f 1)"
  
  if [ "$task_status" = "[>" ]; then
    # The selected task should be bold
    printf "${bold}${padding}%s${normal}\n\n" "$task"  
  else
    # All other tasks should be normal
    printf "${normal}${padding}%s\n\n" "$task"
  fi
done
