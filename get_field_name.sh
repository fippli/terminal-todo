#!/usr/bin/env bash

# This function returns what comes after
# : in [:field_name] i.e. field_name
get_field_name () {
  # The input to this function should be the line
  # number of the task
  local line_number=${1}
  
  task_line="$(sed "${line_number}q;d" "${todo_task_file}")"
  task_status="$(echo "${task_line}" | cut -d ']' -f 1)"
  field_name="${task_status:2}"
  echo "${field_name}"
}