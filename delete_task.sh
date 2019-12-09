#!/usr/bin/env bash

delete_task () {
  i=0
  lines=$(wc -l < "$todo_task_file")

  while ((i < lines)); do
    line_number=$((i+1))
    task_line="$(sed "${line_number}q;d" "$todo_task_file")"
    task_status="$(echo "$task_line"| cut -d']' -f 1)"

    if [[ "$task_status" == "[>" ]]; then
      # Unselect the selected line
      sed -i.bak "${line_number}d" "$todo_task_file"
      
      # Select the first line
      first_task_line="$(sed "1q;d" "$todo_task_file")"
      first_task_text="$(echo "$first_task_line"| cut -d']' -f 2)"
      first_task_update="[>]${first_task_text}"
      sed -i '' "1 s/.*/${first_task_update}/" "$todo_task_file"
    fi

    i=$((i+1))
  done
}
