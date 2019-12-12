#!/usr/bin/env bash

edit_meta_row () {
  # The first input should be the name of the edited field
  # e.g. descripition for [:description]
  field_name="${1}"
  warnings_showed=false

  if [ "${BASH_VERSINFO:-0}" -lt 4 ] && [ "$warnings_showed" = false ]; then
    echo ""
    echo "${padding}⚠️  Your version of bash doesn't support the -i flag to 'read'."
    echo "${padding}Because of this your task cannot be pre-filled for editing."
    echo ""
    echo "${padding}If you're on macOS, remember that you can install a newer
        version of bash with 'brew install bash'."
    echo ""

    warnings_showed=true
  fi

  line_number=1
  lines=$(wc -l < "$todo_task_file")
  found="false"

  # Find the line number of the selected task
  while ((line_number < lines)); do
    task_status="$(get_task_status "${line_number}")"
    line_field_name="$(get_field_name "${line_number}")"

    if [ "$task_status" == ":" ] && [ "${field_name}" == "${line_field_name}" ]; then
      edited_line_number=$line_number
      found="true"
    fi

    line_number=$((line_number + 1))
  done

  edited_task_text="$(get_task_text "${edited_line_number}")"

  # Don't (try) to pre fill the prompt on old bash versions.
  if [ "${BASH_VERSINFO:-0}" -lt 4 ] || [ "$found" == "false" ]; then
    read -r -e -p "${padding}EDIT DESCRIPTION: " edited_task
  else
    read -r -e -p "${padding}EDIT DESCRIPTION: " -i "$edited_task_text" edited_task
  fi

  edited_meta_row="[:${field_name}]$edited_task"
  
  if [ "$found" == "false" ]; then
    echo "${edited_meta_row}" >> "$todo_task_file"
    
    else
    # Since macOS comes with old BSD version of sed we cannot insert at a specific
    # line, instead we replace it with regexp.
    # With GNU sed this would be 'sed -i.bak "${line}i${line} $EDITED_TASK"'
    sed -i.bak "${edited_line_number}s/.*/$edited_task_update/" "$todo_task_file"
  fi

}