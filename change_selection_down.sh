#!/usr/bin/env bash

change_selection_down () {
  lines=$(wc -l < "$todo_task_file")
  i=0

  while ((i < lines)); do
    line_number=$((i + 1))
    task_status="$(get_task_status "${line_number}")"

    if [ "$task_status" = "[>" ]; then
      # Unselect the selected line
      set_task_status ${line_number} "[<]"
      
      # Select the next line
      next_line_number=$((line_number + 1))
      
      if ((next_line_number > lines)); then
        next_line_number=1
      fi

      set_task_status "${next_line_number}" "[>]"
      break
    fi

    i=$((i + 1))
  done
}