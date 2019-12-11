#!/usr/bin/env bash

read_tasks () {
  color="\033[30m"
  background_color="\033[46m"
  reset_color="\033[0m"

  lines=$(wc -l < "$todo_task_file")
  i=0
  echo ""

  while ((i < lines)); do
    i=$((i+1))
    task="$(get_task_text "${i}")"
    task_status="$(get_task_status "${i}")"
    
    if [ "$task_status" = "[>" ]; then
      # The selected task should be bold
      printf "${padding}${background_color}${color} %s ${reset_color}\n\n" "$task"  
    else
      # All other tasks should be normal
      printf "${padding}%s\n\n" "$task"
    fi
  done
}
