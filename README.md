# Terminal Todo

TODO list for the terminal.

## Installation

Get a copy of the code and run `make`:

```sh
make install

```

Available macros to configure your installation:

* `TODO_INSTALL_DIR`- Where to install the executable (should be in your `PATH`)
* `TODO_TASK_FILE` - The default task file
* `TODO_HEADER_FILE`- The default header
* `TODO_NO_COLOR` - Disable colors (if default header is used)
* `TODO_RANDOM_COLOR` - Randomize colors (if default header is used)

```sh
make \
    TODO_INSTALL_DIR="$HOME/.bin" \
    TODO_TASK_FILE="$HOME/.todo" \
    TODO_HEADER_FILE=$(pwd)/table_head_ansii_color.sh \
    TODO_RANDOM_COLOR=1 \
    install
```

To uninstall, ensure you've set the correct `TODO_INSTALL_DIR` if not default and
run:

```sh
make TODO_INSTALL_DIR="$HOME/.bin" uninstall
```

<img src="./img/install.gif" width="600"/>

## Basic usage

Run:

```sh
todo
```

in your terminal to open the program.

The same variables set when installing can be set to override the default
behaviour when running the program. If you want to run a new todo list, run:

```sh
TODO_TASK_FILE=my-new-file todo
```
