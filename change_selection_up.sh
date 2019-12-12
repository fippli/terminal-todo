#!/usr/bin/env bash

change_selection_up () {
  i=0
  lines=$(wc -l < "$todo_task_file")

  while ((i < lines)); do
    line_number=$((i + 1))
    task_status="$(get_task_status ${line_number})"

    if [ "${task_status}" = ">" ]; then
      set_task_status ${line_number} "<"
      
      # Select the previous line
      previous_line_number=$i
      start_line=$i
      previous_task_status="$(get_task_status "${previous_line_number}")"
      
      # Check that we dont overwrite a meta field
      while [ "$previous_task_status" != "<" ]; do
        previous_line_number=$((previous_line_number - 1))
        if ((previous_line_number <= 0)); then
          previous_line_number=$lines
        fi
        previous_task_status="$(get_task_status "${previous_line_number}")"
        if [ "$previous_line_number" == "$start_line" ]; then
          break
        fi
      done
      
      set_task_status "${previous_line_number}" ">"
      break
    fi

    i=$((i + 1))
  done
}