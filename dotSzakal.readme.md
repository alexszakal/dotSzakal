# my-dotfiles

## Setup
```sh
git init --bare $HOME/.dotSzakal
alias dotconfig='git --git-dir=$HOME/.my-dotfiles/ --work-tree=$HOME'
dotconfig remote add origin git@github.com:alexszakal/dotSzakal.git
```

## Replication
```sh
git clone --separate-git-dir=$HOME/.dotSzakal https://github.com/alexszakal/dotSzakal.git my-dotfiles-tmp
rsync --recursive --verbose --exclude '.git' my-dotfiles-tmp/ $HOME/
rm --recursive my-dotfiles-tmp
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
