%{
  title: "Automate Your Mac Setup and Keep It Up to Date",
  description: "Let me show you how I automate the setup of my development environment.",
  keywords: ["mac", "setup", "automate", "script", "update"],
  archive: true
}
---

It is rather common that companies have scripts to get their developer machines up and running. Many of us also create our own version to have our personal setup running on a new computer quickly.

A few years ago I also started doing this for my setup. One problem I came across was that my setup got out of date pretty quick and it was most definitely not matching my previous settings when using it to setup a new machine; more likely, it was completely broken and wouldn't run at all.

I wanted to fix this and make my setup script more useful. For the past year or so I have been using a new kind of setup script. It is probably even wrong to call it setup script. My setup script now is an **update script** instead.

The changes required are rather minimal. You simply need to make sure each command is idempotent - each command in the script has to work the same no matter how many times in a row you execute it.

The best part about this is that now you can also use this script to keep your system up to date and you have a single file that describes all of your setup in a reproducible way.

I run [my setup script](https://github.com/jorinvo/dotfiles/blob/mac/setup-mac) every week or so to have the latest software available.

What does it look like in practice?

Many commands work the same in an install and an update script. For example, to keep your Mac's software up to date, you use `sudo softwareupdate -i -a`.

Other changes are as simple as replacing each `mkdir` command with
`mkdir -p` to ignore errors.

And files should only be linked if they don't exist yet. My helper function to do so looks like this:

```
link_to() {
  if [ ! -e "$2" ]; then
    if [ ! -e "$1" ]; then
      printf "\nWARNING: cannot link $1 because it does not exist\n"
    else
      mkdir -p "$(dirname "$2")"
      ln -s "$1" "$2"
      printf "\nLinked $2"
    fi
  fi
}
```

[Homebrew](https://brew.sh/) should only install packages not already installed (If you are not using `brew` yet, do yourself a favor, stop right now and check it out; you don't want to install software without it). In my case I keep the packages in a separate [`brew.txt`](https://github.com/jorinvo/dotfiles/blob/mac/brew.txt) file. To install only new packages I filter them like this:

```
printf "\nInstalling Brew taps\n"
comm -23 <(sort brew.txt) <(brew leaves) | xargs brew install
# Update brew.txt
brew leaves > brew.txt
printf "\nInstalling Cask taps\n"
comm -23 <(sort cask.txt) <(brew cask ls) | xargs brew cask install
# Update brew.txt
brew cask ls > cask.txt
```

You can use the above method also for other sources such as [npm packages](https://www.npmjs.com/) and [RubyGems](https://rubygems.org/).

The next thing might not be helpful to you unless you are using Vim, but I also setup and update [Neovim](https://neovim.io/) and [vim-plug](https://github.com/junegunn/vim-plug) here:

```
# Neovim
test -d ~/.vim || mkdir ~/.vim
if [ ! -d ~/.config/nvim ]
then
  ln -s ~/.vim ~/.config/nvim
  ln -s ~/.vimrc ~/.config/nvim/init.vim
  ln -s /usr/share/vim/vim74/spell/ ~/.config/nvim/
  printf "\nLinked Neovim config"
fi

## vim-plug
if [ ! -e ~/.config/nvim/autoload/plug.vim ]
then
  printf "\nInstalling vim-plug"
  curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
nvim +PlugInstall +PlugUpgrade +PlugUpdate +PlugClean! +UpdateRemotePlugins +qall
```

Have a look at my Mac [dotfiles](https://github.com/jorinvo/dotfiles/tree/mac) to find out more. Maybe you find some new trick to add to your Vim or Bash setup.
I would love to hear from you about some part of your setup that you automated!

