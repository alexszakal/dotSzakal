# This is to remind myself on how to use this repository.

The solution came from here:
<https://news.ycombinator.com/item?id=11071754>
and here:
<https://www.atlassian.com/git/tutorials/dotfiles>
and here:
<https://github.com/Siilwyn/my-dotfiles>

## Setup
```sh
git init --bare $HOME/.dotSzakal
alias dotconfig='git --git-dir=$HOME/.my-dotfiles/ --work-tree=$HOME'
dotconfig remote add origin git@github.com:alexszakal/dotSzakal.git
```

## Replication
```sh
echo ".my-dotfiles" >> .gitignore
git clone --bare git@github.com:alexszakal/dotSzakal.git $HOME/.my-dotfiles
dotconfig checkout
```

## Configuration
```sh
dotconfig config status.showUntrackedFiles no
dotconfig remote set-url origin git@github.com:alexszakal/dotSzakal.git
```

## Usage
```sh
dotconfig status
dotconfig add .gitconfig
dotconfig commit -m 'Add gitconfig'
dotconfig push
```
