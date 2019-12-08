#!/usr/bin/env bash

todo_task_file=$1
i=0
lines=$( wc -l < "$todo_task_file" )

while [[ $i -lt $((lines)) ]]; do
  line_number=$((i+1))
  task_line="$( sed "${line_number}q;d" "$todo_task_file" )"
  task_status="$(echo $task_line| cut -d']' -f 1)"
  task_text="$(echo $task_line| cut -d']' -f 2)"

  if [[ "$task_status" == "[>" ]] && ((line_number > 1)); then
    # Unselect the selected line
    unselect_task_update="[<]${task_text}"
    sed -i '' "${line_number} s/.*/${unselect_task_update}/" "$todo_task_file"
    
    # Select the previous line
    previous_line_number=$i
    previous_task_line="$( sed "${previous_line_number}q;d" "$todo_task_file" )"
    previous_task_text="$(echo $previous_task_line| cut -d']' -f 2)"
    select_task_update="[>]${previous_task_text}"
    sed -i '' "${previous_line_number} s/.*/${select_task_update}/" "$todo_task_file"
  fi

  i=$((i+1))
done