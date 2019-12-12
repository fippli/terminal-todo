#!/usr/bin/env bash

add_task () {
  read -r -e -p "${padding}ENTER NEW TASK: " task

  # Unselect the other tasks. Only the new task
  # should be selected.
  line_number=0
  lines=$(wc -l < "$todo_task_file")

  while ((line_number < lines)); do
    line_number=$((line_number + 1))
    task_status="$(get_task_status "${line_number}")"
    if [ "$task_status" != ":" ]; then
      set_task_status ${line_number} "<"
    fi
  done

  echo "[>]${task}" >> "$todo_task_file"
}