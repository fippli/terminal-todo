#!/usr/bin/env bash
ln -s $(pwd)/todo.sh ${INSTALL_DIR:-"~/bin/todo"}

chmod +x ~/bin/todo
