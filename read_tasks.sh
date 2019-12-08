#!/usr/bin/env bash

todo_task_file=$1
padding="       "
bold=$(tput bold)
normal=$(tput sgr0)

# Count the lines ins the file
lines=$( wc -l < "$todo_task_file" )
i=0
echo ""
while [[ $i -lt $((lines)) ]]; do
  i=$((i+1))
  task_line="$( sed "${i}q;d" "$todo_task_file" )"
  task="$(echo $task_line| cut -d']' -f 2)"
  task_status="$(echo $task_line| cut -d']' -f 1)"
  if [ "$task_status" = "[>" ]; then
    printf "${bold}${padding}%s${normal}\n\n" "$task"  
  else
    printf "${normal}${padding}%s\n\n" "$task"
  fi
done
