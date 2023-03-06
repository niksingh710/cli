# Shell
This is the shell config i do use for my bash and zsh.

There is a rc file that sources the common stuff among both the shells and make sure its working.

Then a variable that checks the current shell name and executes extra specific shell stuff for that.

These all files are being sourced so the variables are flowing from each file to the below one.

## Module
This dir stores tools specific aliases and configs

# Keymaps
There are no leader key in this but a vim mode for zsh.

## Zsh

`jk` is the key that is used to switch to vim normal mode in zsh-vim.

| keymap | action |
|--------|--------|
| j,k in vim mode | history scroll |
| Alt-h,j,k,l | tab completion scroll |
| h,j,k,l in tab completion mode | selection scroll |
| ctrl+/ | Arch linux pkg installation with fzf preview |
| ctrl+alt+/ | Arch linux pkg uninstall with fzf preview |
