#!/usr/bin/env bash

todo_from_file () {
    # Find all `TODO`-markings in any file.
    grep -rn --exclude-dir={.git,node_modules} "^ *\(#\|//\).*TODO:" . | \
        sed -E 's/^([0-9]+).*TODO[: ]*/\1:TODO:/' | \
        awk -F':' '{printf "%s - %s:%s\n", $4, $1, $2}' > .todo
}
