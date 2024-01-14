# Hide

## Introduction

`Hide` is a vim-like editor that pretty much does the same things as vim.
It also provides with a pretty simple way of implementing syntax highlighting and rules to check for errors before compilation/running of a program.

`Hide` provides an IDE-like editing experience in your terminal (sort of).

![Alt text](preview)

## Feature Highlights

-   `tabs` -> you can open multiple files and arrange them horizontally or vertically. `Hide` provides a grid layout for your editing
-   `suggestions` -> decrease strain on fingers and mispelling
-   `multiline editing` -> reduce number of times you have to rewrite something
-   `search file` -> reduce time spent trying to find where in the directory something is placed. while also providing you with the content of the file to make sure it's the one you want.
-   `:!` -> to quickly make shell calls
-   `syntax highlighting` -> syntax highlighting is easy to implement for any given language and doesn't require much learning.

## Getting started

-   clone repository
-   enter compiler directory
-   build/rebuild compiler
-   enter `hamble` directory (the build tool for `halppp`)
-   use `halppp` to build an executable of `hamble` with `-r` flag for speed optimizations
-   copy `hamble` executable `main` to somewhere it can be accessed by the shell. Ex: `$HOME/.local/bin/`
-   enter `hide` directory
-   build with `hamble++ build -r`
-   run using the command `hide`

```bash
git clone git@github:peg0ne/halppp
cd halppp/compiler
./rebuild.sh
cd ../hamble
halppp main.ha -r
cp main $HOME/.local/bin/hamble++
cd ../hide
hamble++ build -r
hide
```

## Text editing

### Modes

-   `Normal` -> In this mode commands is your friend
-   `Insert` -> In this mode it's like using any other texteditor
-   `CmdHan` -> In this mode you can input commands such as `:w` write to file, `:wq` write and close current file and much more
-   `FileEx` -> You will see a tab opening up on the left where you can select and open a file.

### Basic key commands

-   `ESC` -> will return you to normal mode in basically any situation.
-   `TAB` -> unlike other editors `TAB` is used only to shift lines so even if you use it at the end of a line it will append `4 spaces` at the beginning of the line
-   `LSHIFT + TAB` -> similar to `TAB`
    but it removes up to `4 spaces` from the beginning of the line.
-   `RIGHT ARROW` -> move cursor right
-   `LEFT ARROW` -> move cursor left
-   `DOWN ARROW` -> move cursor down
-   `UP ARROW` -> move cursor up
-   `PGUP` -> move cursor up a page
-   `PGDN` -> move cursor down a page
-   `HOME` -> move cursor to the start of the line
-   `END` -> move cursor to the end of the line
-   `SHIFT + UP ARROW` -> move line up one
-   `SHIFT + DOWN ARROW` -> move line down one

### `Normal` mode specific key commands

-   `:` -> enter `CmdHan` mode
-   `i` -> enter `Insert` mode
-   `a` -> enter `Insert` mode and jump one forward
-   `v` -> enter `Visual` mode (Still in works)
-   `SPACE + f` -> enter `FileEx` mode
-   `SPACE + s` -> enter `File search` window
-   `SPACE + S` -> enter `Content File search` window
-   `SPACE + T` -> enter `Terminal` window
-   `j` -> move cursor up
-   `k` -> move cursor down
-   `l` -> move cursor right
-   `h` -> move cursor left
-   `x` -> delete char under cursor
-   `m` -> add a cursor below
-   `M` -> add a cursor at next word found under cursor
-   `n` -> selection to lowercase
-   `N` -> selection to uppercase
-   `e` -> move to end of word
-   `w` -> move to next word
-   `b` -> move back a word
-   `u` -> undo
-   `r` -> redo
-   `R` -> replace helper shown in bottom of screen
-   `s` -> search helper shown in bottom of screen
-   `f` -> find word under selection
-   `F` -> reverse find word under cursor
-   `p` -> paste line below
-   `P` -> paste at cursor
-   `;` -> remove multi cursors
-   `C` -> cuts from cursor to end and enters insert mode
-   `c + d` -> cuts entire line and enters insert mode on line below
-   `c + e` -> cuts from cursor until end of word and enters insert mode
-   `c + w` -> cuts from cursor until end of word including following spaces and enters insert mode
-   `D` -> cuts from cursor to end
-   `d + d` -> cuts entire line
-   `d + e` -> cuts from cursor until end of word
-   `d + w` -> cuts from cursor until end of word including following spaces
-   `<number> dd` cuts `<number>` of lines together
-   `Y` -> cuts from cursor to end
-   `y + y` -> copies entire line
-   `<number> yy` copies `<number>` of lines together
-   `z + z` -> make window center on cursor
-   `z + .` -> make window center on cursor
-   `z + t` -> make window move so that the cursor is at the top of the window
-   `z + b` -> make window move so that the cursor is at the bottom of the window
-   `o` -> toggle number diff or just regular line nr
-   `t` -> toggle check errors using rules
-   `SPACE + t` -> split horizontal
-   `SPACE + v` -> split vertical
-   `SPACE + h` -> move to editor on the left
-   `SPACE + l` -> move to editor on the right
-   `SPACE + j` -> move to editor above
-   `SPACE + k` -> move to editor below
-   `SPACE + c` -> toggle comments
-   `SPACE + p` -> opens command pallete
-   `SPACE + ->` -> moves to next file opened
-   `SPACE + <-` -> moves to previous file opened

### CmdHan commands

-   `q` -> exits out of the current window, will exit entirely if it's the last editor left.
-   `w` -> writes changes to file
-   `wq` -> does `w` then `q`
-   `touch <filename>` -> creates a new file with the specified file name
-   `mkdir <filename>` -> create a new directory with the specified director name
-   `syntax <lang>` -> sets the syntax of the editor with the specified language (EX: `syntax rs`, `syntax py`)
-   `!<command>` -> executes the command in the shell
-   `<number>` -> moves cursor of active editor to the line that corresponds to the specified number

## Customization

Currently customization is limited unless you change sourcecode. However you are able to create custom syntax and rules and suggestions to any language easily.

`$HOME/.config/hide` contains the language configurations and are named as `<LanguageFileName>.json` (EX: Rust would be `rs.json`). Some languages are already implemented so look in that folder if you wanna create or improve on any language.
