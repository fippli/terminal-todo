PROJECT_PATH       = $(shell pwd)
PROJECT_APP        = $(PROJECT_PATH)/todo.sh

APP_NAME           = todo
TODO_INSTALL_DIR  ?= $(HOME)/bin
APP_PATH           = $(TODO_INSTALL_DIR)/$(APP_NAME)

TODO_TASK_FILE    ?= $(TODO_INSTALL_DIR)/todo.txt
TODO_HEADER_FILE  ?= $(PROJECT_PATH)/table_head_ansii_color.sh
TODO_NO_COLOR     ?=
TODO_RANDOM_COLOR ?=

define FILE_CONTENT
#!/usr/bin/env bash

TODO_TASK_FILE="$${TODO_TASK_FILE:-$(TODO_TASK_FILE)}" \\
TODO_HEADER_FILE="$${TODO_HEADER_FILE:-$(TODO_HEADER_FILE)}" \\
TODO_NO_COLOR="$${TODO_NO_COLOR:-$(TODO_NO_COLOR)}" \\
TODO_RANDOM_COLOR="$${TODO_RANDOM_COLOR:-$(TODO_RANDOM_COLOR)}" \\
$(PROJECT_APP)
endef

export FILE_CONTENT

# This will grep the double comment marker (##) and map all targets to the
# comment which will just print the comment next to each target for documenting
# purposes.
help: ## Show this help text
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; \
		{printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install: ## Install the todo application
	@echo "Installing '$(APP_NAME)' in $(TODO_INSTALL_DIR)"
	@echo "$$FILE_CONTENT" > $(APP_PATH)
	@chmod 755 $(APP_PATH)

uninstall: ## Uninstall the todo application
	@echo "Uninstalling '$(APP_NAME)' from $(TODO_INSTALL_DIR)"
	@rm -f $(APP_PATH)

.PHONY: help install uninstall
