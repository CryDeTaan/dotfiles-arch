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
