#!/usr/bin/env bash

change_selection_up () {
  i=0
  lines=$(wc -l < "$todo_task_file")

  while ((i < lines)); do
    line_number=$((i + 1))
    task_status="$(get_task_status ${line_number})"

    if [ "${task_status}" = "[>" ]; then
      set_task_status ${line_number} "[<]"
      
      # Select the previous line
      previous_line_number=$i
      if ((previous_line_number == 0)); then
        previous_line_number=$lines
      fi
      
      set_task_status "${previous_line_number}" "[>]"
      break
    fi

    i=$((i + 1))
  done
}