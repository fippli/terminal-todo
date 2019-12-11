#!/usr/bin/env bash

set_task_status () {
  # The input to this function should be the line
  # number of the task that should be unselected
  local line_number=${1}

  # The second input should be the status indicator of the task
  # e.g. [>] for selected or [<] for unselected
  local status=${2}
  
  task_text="$(get_task_text "${line_number}")"
  updated_task="${status}${task_text}"
  sed -i '' "${line_number} s/.*/${updated_task}/" "${todo_task_file}"
}