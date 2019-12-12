#!/usr/bin/env bash

select_first_available_task () {
  start_number=${1:-1}
  line_number=${start_number}
  lines=$(wc -l < "$todo_task_file")

  if ((line_number >= lines)); then
    line_number=1
  fi

  while ((line_number < lines)); do
    task_status="$(get_task_status "${line_number}")"
    
    if [ "$task_status" == "<" ]; then
      set_task_status "${line_number}" ">"
      break
    fi
    
    line_number=$((line_number + 1))

    if ((line_number > lines)); then
      line_number=1
    fi

    if [ "${line_number}" == "${start_number}" ]; then
      break
    fi
  done
}
