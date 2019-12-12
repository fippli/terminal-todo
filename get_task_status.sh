#!/usr/bin/env bash

get_task_status () {
  # The input to this function should be the line
  # number of the task
  local line_number=${1}
  
  task_line="$(sed "${line_number}q;d" "${todo_task_file}")"
  task_status="${task_line:1:1}"
  echo "${task_status}"
}