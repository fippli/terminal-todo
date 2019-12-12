#!/usr/bin/env bash

# If no task is selected select the first
init_selection () {
  line_number=0
  lines=$(wc -l < "$todo_task_file")
  got_selection="false"

  while ((line_number < lines)); do
    line_number=$((line_number + 1))
    task_status="$(get_task_status "${line_number}")"
    if [ "$task_status" = ">" ]; then
      got_selection="true"
    fi
  done

  if [ "$got_selection" = "false" ]; then
    select_first_available_task "1"
  fi
}