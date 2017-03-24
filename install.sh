#!/bin/bash

set -e  

# static variables
gitpath="$HOME/.dotfiles"
gitorigin="https://github.com/CryDeTaan/dotfiles-arch.git"
debug=false

# defaults for file & config locations
oh_my_zsh="$HOME/.oh-my-zsh"
zsh_rc="$HOME/.zshrc"

# helper functions
# colors!
function echo() { command echo -e " * $*"; }
function echo_green() { command echo -e "$(tput setaf 2; tput bold)$*$(tput sgr0)"; }
function echo_red() { command echo -e "$(tput setaf 1)$*$(tput sgr0)"; }
function echo_yellow() { command echo -e "$(tput setaf 3)$*$(tput sgr0)"; }
function echo_debug() { if [ "$debug" = true ]; then command echo -e "$(tput setaf 3; tput bold)>>> $*$(tput sgr0)"; fi }
# curl
function curl() { command curl -fsSL "$1" -o "$2"; }


function usage() {

    cat <<EOF
    #################
    Simple Dotfiles installer
    #################
    Based on https://github.com/leonjza/dotfiles. Shouts to @leonjza
    
    Usage: install <app>
    Examples:
        install zsh
        install vim
        
        The following are for arch config
        install xresources
        install i3  
        install rofi
EOF

}

function install_zsh() {

    local temp="$(mktemp)"
    echo_green "Installing ZSH configuration"

    # make sure zsh is available
    if ! hash zsh 2>/dev/null; then
        echo_red "zsh is not installed or in your PATH. Not installing this configuration."
        return
    fi

    # Ensure that *.d directory exists
    echo_debug "Creating *.d directory in $HOME/.dotfiles.d/zshrc.d"
    mkdir -p $HOME/.dotfiles.d/zshrc.d

    echo "Downloading oh-my-zsh installer"
    echo_debug "Saving installer to $temp"
    curl "https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh" $temp

    echo_debug "Preventing the installer from starting ZSH when its done"
    sed -i -r "s/env zsh//" $temp

    echo "Running oh-my-zsh installer..."
    echo_debug "Using sh to run $temp"
    sh $temp
    echo_debug "Removing downloaded installer"
    rm -f $temp

    echo "Installing plugins"
    echo_debug "Using oh-my-zsh directory: $oh_my_zsh/custom/plugins"

# Syntax highlighting
    if [[ ! -d "$oh_my_zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
        git clone git://github.com/zsh-users/zsh-syntax-highlighting.git $oh_my_zsh/custom/plugins/zsh-syntax-highlighting
    else
        echo_yellow "Syntax highligthing plugin already exists."
    fi

    # Auto suggestions
    if [[ ! -d "$oh_my_zsh/custom/plugins/zsh-autosuggestions" ]]; then
        git clone git://github.com/zsh-users/zsh-autosuggestions $oh_my_zsh/custom/plugins/zsh-autosuggestions
    else
        echo_yellow "Autosuggestions plugin already exists."
    fi
    echo_debug "Symlinking .zshrc $gitpath/rc/zshrc to $zsh_rc"
    ln -sf $gitpath/rc/zshrc $zsh_rc

    echo "Symlinking *.zsh files to $HOME/.dotfiles.d/zshrc.d/"
    ln -sf $gitpath/dotfiles.d/zshrc.d/* $HOME/.dotfiles.d/zshrc.d


    echo "Configuring custom zsh theme"
    echo "Creating Directories $oh_my_zsh/custom/themes"

    # Ensure that custom theme  directory exist
    echo "Creating custom theme directory in $oh_my_zsh/custom/themes/"
    mkdir -p $oh_my_zsh/custom/themes/

    echo "Symlinking zsh-theme file to $oh_my_zsh/custom/themes"
    ln -sf $gitpath/config/oh-my-zsh/custom/themes/* $oh_my_zsh/custom/themes/

    echo_green "ZSH config install complete!"

}


function config_vim() {

    echo_green "Configuring Vim."

    # make sure vim is available
    if ! hash vim 2>/dev/null; then
        echo_red "vim is not installed or in your PATH. Not installing this configuration."
        return
    fi

    # Ensure that *.d directory exists
    echo_debug "Creating *.d directory in $HOME/.dotfiles.d/vimrc.d"
    mkdir -p $HOME/.dotfiles.d/vimrc.d

    echo_debug "Preparing the vim plugin directory at $vim_plugin_dir"
    mkdir -p $vim_plugin_dir

    echo "Installing Vim Plugins"

    # Vundle
    if [[ ! -d "$vim_plugin_dir/bundle/Vundle.vim" ]]; then
        git clone https://github.com/gmarik/Vundle.vim $vim_plugin_dir/bundle/Vundle.vim
    else
        echo_yellow "Vundle already exists."
    fi

    # Molokai
    if [[ ! -d "$vim_plugin_dir/bundle/molokai" ]]; then
        git clone https://github.com/tomasr/molokai $vim_plugin_dir/bundle/molokai
    else
        echo_yellow "Molokai color scheme already exists."
    fi

    echo "Installing Vim configuration file"

    ## Backup the current one
    if [[ -f "$vim_rc" ]]; then
        backup_config $vim_rc
    fi

    echo_debug "Symlinking $gitpath/rc/vimrc to $vim_rc"
    ln -sf $gitpath/rc/vimrc $vim_rc

    echo "Symlinking *.vim files to $HOME/.dotfiles.d/vimrc.d/"
    ln -sf $gitpath/dotfiles.d/vimrc.d/* $HOME/.dotfiles.d/vimrc.d

    echo "Running vim plugin installer"
    vim +PluginInstall +qall

    echo_green "Vim config install complete!"

}

function config_xresources() {

    echo_green "Configuring Xresources."
    
    echo "Symlinking Xresources to $HOME/.Xresources"
    ln -sf $gitpath/rc/Xresources $HOME/.Xresources

    echo_green "Xresources configuration complete!"
}

function config_i3() {

    echo_green "Configuring i3."
    
     if ! hash i3 2>/dev/null; then
        echo_red "i3 is not installed or in your PATH. Not installing this configuration."
        return
    fi
    
     # Ensure that i3 directory exist
    echo "Creating i3 directory in $HOME/.config"
    mkdir -p $HOME/.config/i3/scripts/
    
    echo "Symlinking i3 config files to $HOME/.config/i3/"
    ln -sf $gitpath/config/i3/config $HOME/.config/i3
    ln -sf $gitpath/config/i3/*.conf $HOME/.config/i3

    echo "Symlinking i3 script files to $HOME/.config/i3/scripts"
    ln -sf $gitpath/config/i3/scripts/* $HOME/.config/i3/scripts

    echo_green "i3 configuration complete!"
}

function config_rofi() {

    echo_green "Configuring i3."
    
      if ! hash rofi 2>/dev/null; then
        echo_red "rofi is not installed or in your PATH. Not installing this configuration."
        return
    fi
    
     # Ensure that rofi directory exist
    echo "Creating rofi directory in $HOME/.config"
    mkdir -p $HOME/.config/rofi
    
    echo "Symlinking rofi config file to $HOME/.config/rofi/"
    ln -sf $gitpath/config/rofi/config $HOME/.config/rofi

    echo_green "rofi configuration complete!"
}

case $1 in
zsh)
install_zsh
;;
vim)
config_vim
;;
xresources)
config_xresources
;;
i3)
config_i3
;;
rofi)
config_rofi
;;
*)
usage
;;
esac
