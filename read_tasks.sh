#!/usr/bin/env bash

bold=$(tput bold)
italic="\e[3m"
normal=$(tput sgr0)
cyan="\033[0;36m"
background_color="\e[46m"
reset_color="\033[0m"

lines=$(wc -l < "$todo_task_file")
i=0
echo ""

while [[ $i -lt $((lines)) ]]; do
  i=$((i+1))
  task_line="$(sed "${i}q;d" "$todo_task_file")"
  task="$(echo "$task_line"| cut -d']' -f 2)"
  task_status="$(echo "$task_line"| cut -d']' -f 1)"
  
  if [ "$task_status" = "[>" ]; then
    # The selected task should be bold
    printf "${padding}${italic}${background_color} %s ${normal}${reset_color}\n\n" "$task"  
  else
    # All other tasks should be normal
    printf "${normal}${padding}%s\n\n" "$task"
  fi
done
