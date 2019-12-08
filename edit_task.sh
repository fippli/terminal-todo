#!/usr/bin/env bash

warnings_showed=false

if [ "${BASH_VERSINFO:-0}" -lt 4 ] && [ "$warnings_showed" = false ]; then
  echo ""
  echo "       ⚠️  Your version of bash doesn't support the -i flag to 'read'."
  echo "       Because of this your task cannot be pre-filled for editing."
  echo ""
  echo "       If you're on macOS, remember that you can install a newer
      version of bash with 'brew install bash'."
  echo ""

  warnings_showed=true
fi

i=0
lines=$(wc -l < "$todo_task_file")

# Find the line number of the selected task
while ((i < lines)); do
  line_number=$((i+1))
  task_line="$(sed "${line_number}q;d" "$todo_task_file")"
  task_status="$(echo "$task_line"| cut -d']' -f 1)"

  if [[ "$task_status" == "[>" ]]; then
    edited_line_number=$line_number
  fi

  i=$((i+1))
done

edited_task_line=$(sed -n "${edited_line_number}"p "$todo_task_file")
edited_task_text="$(echo "$edited_task_line"| cut -d']' -f 2)"

# Don't (try) to pre fill the prompt on old bash versions.
if [ "${BASH_VERSINFO:-0}" -lt 4 ]; then
  read -r -e -p "${padding}EDIT TASK: " edited_task
else
  read -r -e -p "${padding}EDIT TASK: " -i "$edited_task_text" edited_task
fi

edited_task_update="[>]$edited_task"

# Since macOS comes with old BSD version of sed we cannot insert at a specific
# line, instead we replace it with regexp.
# With GNU sed this would be 'sed -i.bak "${line}i${line} $EDITED_TASK"'
sed -i.bak "${edited_line_number}s/.*/$edited_task_update/" "$todo_task_file"
