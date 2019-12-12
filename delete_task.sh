#!/usr/bin/env bash

delete_task () {
  i=0
  lines=$(wc -l < "$todo_task_file")

  while ((i < lines)); do
    line_number=$((i+1))
    task_status="$(get_task_status "${line_number}")"

    if [ "${task_status}" = ">" ]; then
      # Delete the selected line
      sed -i.bak "${line_number}d" "$todo_task_file"
      
      # Select the first line
      set_task_status "1" "[>]"
    fi

    i=$((i+1))
  done
}
