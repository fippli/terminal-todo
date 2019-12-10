#!/usr/bin/env bash

get_task_text () {
  # The input to this function should be the line
  # number of the task
  local line_number=${1}
  
  task_line="$(sed "${line_number}q;d" "${todo_task_file}")"
  task_text="$(echo "$task_line"| cut -d']' -f 2)"
  echo "${task_text}"
}