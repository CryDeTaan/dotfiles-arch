#!/bin/bash

set -e  

# static variables
gitpath="$HOME/.dotfiles"
gitorigin="https://github.com/leonjza/dotfiles.git"
debug=false

# defaults for file & config locations
oh_my_zsh="$HOME/.oh-my-zsh"
zsh_rc="$HOME/.zshrc"


# defaults for commandline options
install_app=false
show_usage=false

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
    Simple Dotfiles installer based on https://github.com/leonjza/dotfiles. Shouts to @leonjza
    Usage: install app
    Examples:
        install zsh
        install vim
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

    echo_green "ZSH config install complete!"

}


function install_vim() {

    echo_green "Installing Vim configuration"

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

function install_components() {

    case $install_target in
        none)
            echo_yellow "Installing nothing..."
            return
        ;;
        zsh)
            install_zsh
        ;;
        vim)
            install_vim
        ;;
    esac

}

while [[ $# -gt 1 ]]; do
        case $1 in
        zsh)
        install_target="$1"
        shift # past argument
        ;;
        vim)
        uninstall_target="$1"
        shift # past argument
        ;;
        *)
        show_usage=true
        ;;
    esac


# usage
if [ "$showusage" = true ]; then
    usage
    exit 2
fi

# install
if [[ ! "$install_target" = false ]]; then
    echo "Running install on: $install_target"
    install_components
else
    echo_debug "Running usage(), no args -gt 1 found"
    usage
fi
