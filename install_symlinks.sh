#!/usr/bin/env bash
IFS=$'\n\t'
set -xeou pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# suppress shell login message
[[ ! -f ~/.hushlogin ]] && touch ~/.hushlogin

for f in .zshrc \
    .Brewfile \
    .vimrc \
    .editorconfig \
    .github_username \
    .gitignore_global \
    .kubectl_aliases \
    .tmux.conf \
    .wakeup; do
    if [ -f "$HOME/$f" ]; then rm "$HOME/$f"; fi
    ln -sf "$SCRIPT_DIR/$f" "$HOME/$f"
done

# gnupg
if [ -f "$HOME/.gnupg" ] && [ ! -L "$HOME/.gnupg" ]; then
    echo "$HOME/.gnupg is not a symlink. Delete it manually."
    exit 1
else
    [ -L "$HOME/.gnupg" ] && unlink "$HOME/.gnupg"
    ln -sf "$SCRIPT_DIR/.gnupg" "$HOME/.gnupg"
    # make directory unreadable by others
    chmod -R o-rx "$SCRIPT_DIR/.gnupg"
    # make symlink available only to current user
    chmod 700 "$HOME/.gnupg"
fi

# install zsh-completions
ZSH_COMPLETIONS=~/.oh-my-zsh/custom/plugins/zsh-completions
[[ -d "$ZSH_COMPLETIONS" ]] || git clone \
    https://github.com/zsh-users/zsh-completions "$ZSH_COMPLETIONS"

# install zsh-autosuggestions
ZSH_AUTOSUGGESTIONS=~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
[[ -d "$ZSH_AUTOSUGGESTIONS" ]] || git clone \
    https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGGESTIONS"

# install zsh-syntax-highlighting
ZSH_SYNTAX_HIGHLIGHTING=~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
[[ -d "$ZSH_SYNTAX_HIGHLIGHTING" ]] || git clone \
    https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_HIGHLIGHTING"

# install iterm2 shell integration (for touchbar support etc)
#   see:  https://github.com/caskroom/homebrew-cask/issues/39439
curl -L https://iterm2.com/misc/install_shell_integration.sh | bash
