---
date: 2016-05-23T17:09:59+02:00
draft: true
title: Why use Vim and NeoVim
---

For a while now I have switched to VIM for all my editing needs.
I'm using NeoVim to be more precise.


VIM itself is already a really great text editor.

It's everywhere. You feel at home on any UNIX system - even just via SSH.

Yes, it takes a bit to learn all the shortcuts.
You can get started working quicker when learning a different editor.
But which ever editor you choose, as you spend a lot of time working it will be worth investing in knowing some shortcuts.
And this is what VIM is good at.
It's designed for shortcuts. Shortcuts compose and have easy to memorize patterns.
Even for more complicated shortcuts you don't hurt your hands by trying to press all these keys at once.
And the help system is intuitive and easy to use.

VIM feels a lot like programming your editing.
You can automate every little thing and take the automation to a more sophisticated level as you go.
First, you might repeat a command using the dot. Then you might decide to create a macro.
Later, you might put it right into your configuration file.

You are working right in your terminal.
The terminal is a super powerful tool to get work done.
Being right in the context makes things it ways easier to switch back end forth.

Vim gives you a language for editing that maps directly to what you are trying do
achieve when editing text or code.
(put link to stack overflow post here)



Awesome Plugins:
https://github.com/tpope/vim-commentary
https://github.com/tpope/vim-surround


Make "Open with" Application on Ubuntu Systems:

Create `.local/share/applications/nvim.desktop`:

    [Desktop Entry]
    Categories=;
    Comment=Edit file in NeoVim
    Exec=nvim %f
    GenericName=Process Viewer
    Hidden=false
    Icon=vim
    Name=NeoVim
    Terminal=true
    Type=Application
    Version=1.0


Commands:
:term, :mks, macros for terminal


Nice mappings:

    " SPACE to save
    nmap <space> :w<CR>

    " Command line history completion with ctrl-p and ctrl-n
    cnoremap <C-p> <Up>
    cnoremap <C-n> <Down>

    if has('nvim')
      " ESC in terminal to exit insert mode
      tnoremap <esc> <C-\><C-n>
    endif

    " Switch between the last two files with TAB
    nnoremap <tab> <c-^>

    " Allow dot command in visual mode
    vnoremap . :norm.<CR>
    vnoremap @ :norm@


And use nvim-client for editing:
https://github.com/jorinvo/dotfiles/blob/master/bin/nvim-client
