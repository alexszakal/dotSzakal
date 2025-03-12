# This is to remind myself on how to use this repository.

The solution came from here:
<https://news.ycombinator.com/item?id=11071754>
and here:
<https://www.atlassian.com/git/tutorials/dotfiles>
and here:
<https://github.com/Siilwyn/my-dotfiles>

## Setup a new repo of this type
```sh
git init --bare $HOME/.dotSzakal
alias dcon='git --git-dir=$HOME/.dotSzakal/ --work-tree=$HOME'
dcon remote add origin git@github.com:alexszakal/dotSzakal.git
```

## Replication to a fresh system
```sh
echo ".dotSzakal" >> .gitignore
alias dcon='git --git-dir=$HOME/.dotSzakal/ --work-tree=$HOME'
git clone --bare git@github.com:alexszakal/dotSzakal.git $HOME/.dotSzakal
dcon checkout
```

## Configuration
```sh
dcon config status.showUntrackedFiles no
dcon remote set-url origin git@github.com:alexszakal/dotSzakal.git
```

## Usage
```sh
dcon status
dcon add .gitconfig
dcon commit -m 'Add gitconfig'
dcon push
```
