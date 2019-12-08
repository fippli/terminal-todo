#!/usr/bin/env bash

todo_task_file=$1
lines=$( wc -l < "$todo_task_file" )
i=$lines

while ((i > 0)); do
  line_number=$i
  task_line="$( sed "${line_number}q;d" "$todo_task_file" )"
  task_status="$(echo $task_line| cut -d']' -f 1)"
  task_text="$(echo $task_line| cut -d']' -f 2)"

  if [[ "$task_status" == "[>" ]] && ((line_number < lines)); then
    # Unselect the selected line
    unselect_task_update="[<]${task_text}"
    sed -i '' "${line_number} s/.*/${unselect_task_update}/" "$todo_task_file"
    
    # Select the previous line
    next_line_number=$((line_number+1))
    next_task_line="$( sed "${next_line_number}q;d" "$todo_task_file" )"
    next_task_text="$(echo $next_task_line| cut -d']' -f 2)"
    select_task_update="[>]${next_task_text}"
    echo "$select_task_update"
    sed -i '' "${next_line_number} s/.*/${select_task_update}/" "$todo_task_file"
  fi

  i=$((i-1))
done