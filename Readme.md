# Cli Configuration
This is my cli configuration mostly tried to keep it keyboard driven and much focused to be working on TTY.

This setup contains many useful utilities and my editor to.
Seprating Cli from all other config to make sure that can easily setup this on any system Independent of GUI.
Quickly able to run on TTY too.

# Setup

## Vim
Quick vim setup for TTY.
`curl https://gist.githubusercontent.com/niksingh710/335a8b821dd53031eb5e12e80c7ae7e5/raw/06dfec1e4c501d552da760bd8321f4a248a4227a/vim > ~/.vimrc`

# Utilities

These are the some utilities that comes on top of my head that user should have it.
If i miss out something make sure to check error and resetup it. 😅

- [fzf](https://github.com/junegunn/fzf) Fuzzy finder gives god like navigation and other powers if used correctly.
  - [fd](https://github.com/sharkdp/fd) simple sexy faster `find`
  - [rg](https://github.com/BurntSushi/ripgrep) someone said this is better grep (so just have it)
- [lunarvim](https://www.lunarvim.org/) Nvim with less efforts
- [exa](https://github.com/ogham/exa) Better ls
- [bat](https://github.com/sharkdp/bat) cat command with wings
- [git](https://git-scm.com/) Git cli
- [rclone](https://rclone.org/) Rclone cloud drive mounter
- [tmux](https://github.com/tmux/tmux) Oh yeah this makes split in TTY (A multiplexer) Just u need it you don't know but u do.
  - [tmp](https://github.com/tmux-plugins/tpm) only plugin manager this tool have.
  - [urlview](https://github.com/sigpipe/urlview) access urls available in tmux view
- [simplehttp](https://github.com/niksingh710/simplehttp) Simple go utility to host folder on a network.<make sure firewall enables port>
- [zsh](https://www.zsh.org/) Shell on steroid (bounded by ur vision)
  - [starhip](https://github.com/starship/starship) Prompt on Steroid
  - [zoxide](https://github.com/ajeetdsouza/zoxide) Lazy cd.
    > Plugins and all is already managed in `.zshconfig` by [znap](https://github.com/marlonrichert/zsh-snap).

    > [zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode) This plugin overrides fzf keymaps and someother zsh stuff.
    so sourcing a different file `zvm_after_init_commands+=('. file)` 

- Other pkgs like
  - Bash completions
  - Zsh completions

- Arch Specific
  - pkgfile
  - pkg conf
  - [yay](https://github.com/Jguer/yay) Aur helper.

  ```
  yay -S rustup python python-pip fnm-bin go tmux tmux-bash-completion-git zsh-completion-git bash-complete-alias bash-completion fd ripgrep shellcheck-bin shfmt advcpmv pistol-git bat exa git glow urlview git-secret
  ```

Make sure to have [go](https://go.dev/), [python](https://www.python.org/), [nodejs](https://nodejs.org/en/), [rustup](https://rustup.rs/) is installed. ensure getting rust setup after installing rustup.
also ensure that `pip` `npm` `cargo` are available and working.
* Note
> For node js I prefer to use [fnm](https://github.com/Schniz/fnm)

# Keymaps
The keymaps are purely based on vim keymaps.

### Leader key
Leader is a key type when pressed then it waits for the next key combo to be pressed to execute instructions.

| Tool | Leader |
|------|--------|
| Lunarvim | space |
| Tmux | c-a (Control-a) |

### Basic

These are some basic keymap patterns can be seen around.

  `j` and `k` keys to move up and down
  `h` and `l` keys to move left right

  More specific tool mapping will be present inside the tool config.

### Tmux

Make sure to press `Leader, Shift+I` to install plugins

Leader key `Ctrl-a`

| keymaps | action |
|---------|--------|
| leader,v | split vertical |
| leader,s | split horizontal |
| leader,r | Reloading tmux config |
| leader,m | Maximize pane |
| leader,j,k,l,h | Resize pane |
| leader,x | kill-pane |
| leader,q | kill-window |
| leader,Q | kill-session |
| leader,H,L | Scroll through window |
| leader,V | Visual Mode |
| leader,u | url-viewer |
| ctrl-g | Floating terminal |
| ctrl-h,j,k,l | Christoomy pane switcher switches pane in vim and tmux |

### Lvim

Use `Leader,S,k` to list all keymappings.

# GPG
Download the private.key from google-drive `gpg --import private.key`
