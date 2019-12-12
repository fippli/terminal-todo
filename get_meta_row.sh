#!/usr/bin/env bash

get_meta_row () {
  # The first input argument should be the name
  # of the meta data row that should be returned
  meta_field=${1}

  lines=$(wc -l < "$todo_task_file")
  i=0

  while ((i < lines)); do
    i=$((i+1))
    task_status="$(get_task_status "${i}")"
    field_name="$(get_field_name "${i}")"
    
    if [ "$task_status" = ":" ] && [ "$meta_field" = "$field_name" ]; then
      line_text="$(get_task_text "${i}")"
      echo "$line_text"
    fi
  done
}
