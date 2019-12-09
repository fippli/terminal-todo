#!/usr/bin/env bash

read -r -e -p "${padding}ENTER NEW TASK: " task

# Unselect the other tasks. Only the new task
# should be selected.
line_number=0
lines=$(wc -l < "$todo_task_file")
while [[ $line_number -lt $((lines)) ]]; do
  line_number=$((line_number+1))
  task_line="$(sed "${line_number}q;d" "$todo_task_file")"
  task_text="$(echo "$task_line"| cut -d']' -f 2)"
  task_update="[<]${task_text}"
  sed -i '' "${line_number} s/.*/${task_update}/" "$todo_task_file"
done


echo "[>]${task}" >> "$todo_task_file"