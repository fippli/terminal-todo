#!/usr/bin/env bash

change_selection_up () {
  i=0
  lines=$(wc -l < "$todo_task_file")

  while ((i < lines)); do
    line_number=$((i+1))
    task_line="$(sed "${line_number}q;d" "$todo_task_file")"
    task_status="$(echo "$task_line"| cut -d']' -f 1)"
    task_text="$(echo "$task_line"| cut -d']' -f 2)"

    if [[ "$task_status" == "[>" ]]; then
      # Unselect the selected line
      unselect_task_update="[<]${task_text}"
      sed -i '' "${line_number} s/.*/${unselect_task_update}/" "$todo_task_file"
      
      # Select the previous line
      previous_line_number=$i
      echo $previous_line_number
      if ((previous_line_number == 0)); then
        echo "Hello"
        previous_line_number=$lines
      fi
      previous_task_line="$(sed "${previous_line_number}q;d" "$todo_task_file")"
      previous_task_text="$(echo "$previous_task_line"| cut -d']' -f 2)"
      select_task_update="[>]${previous_task_text}"
      sed -i '' "${previous_line_number} s/.*/${select_task_update}/" "$todo_task_file"
      break
    fi

    i=$((i+1))
  done
}