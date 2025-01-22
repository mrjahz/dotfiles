# ----
# This script assumes you've already installed hyprland
# ----

# Synchronise repositories and update packages 
sudo pacman -Syu

# General stuff
sudo pacman -S git zsh kitty fastfetch otf-font-awesome --needed --noconfirm

# Pop Shell & Launcher
echo "Install Pop Shell and Launcher (y/n)?"
read popshell
if [[ "$popshell" ]] then
    mkdir ~/builds
    (cd ~/builds && git clone https://github.com/pop-os/shell.git)
    (cd ~/builds/shell && make local-install)
    gsettings --schemadir ~/.local/share/gnome-shell/extensions/pop-shell@system76.com/schemas set org.gnome.shell.extensions.pop-shell activate-launcher "['<Super>space']"
    sudo pacman -Sy pop-launcher
fi
echo "Pop Shell Installed, but requires logout/login"

# Interactive Installs
echo "Install Neovim (y/n)?"
read neovim 
[ "$neovim" = "y" ] && sudo pacman -S neovim --needed --noconfirm
echo "Install Bat (superpowered cat) (y/n)?"
read bat
[ "$bat" = "y" ] && sudo pacman -S bat --needed --noconfirm
echo "Install Firefox (y/n)?"
read firefox
[ "$firefox" = "y" ] && sudo pacman -S firefox --needed --noconfirm
echo "Install Firacode Font (y/n)?"
read firacode
[ "$firacode" = "y" ] && sudo pacman -S ttf-firacode-nerd --needed --noconfirm
echo "Install ripgrep (line-search tool (required for telescope on nvim) (y/n)"
read ripgrep
[ "$ripgrep" = "y" ] && sudo pacman -S ripgrep --needed --noconfirm
echo "Install Rust via Rustup (y/n)"
read rustup
[ "$rustup" = "y" ] && sudo pacman -S rustup --needed --noconfirm 
echo "Install Obsidian (y/n)?"
read obsidian
[ "$obsidian" = "y" ] && sudo pacman -S obsidian --needed --noconfirm
echo "Install Discord (y/n)?"
read discord
[ "$discord" = "y" ] && sudo pacman -S discord --needed --noconfirm

# AUR and Other Stuff
echo "Install Mise (y/n)?"
read mise
if [[ "$mise" = " y" ]]; then
    curl https://mise.jdx.dev/mise-latest-linux-x64 > ~/.local/bin/mise
    chmod +x ~/.local/bin/mise
fi

echo "Install NodeJS Runtime (with mise) (y/n)?"
read misenode
if [[ "$misenode" = "y" ]]; then
    mise install nodejs
fi
echo "Install Docker (y/n)?"
read docker
[ "$docker" = "y" ] && sudo pacman -S docker docker-compose --needed --noconfirm 

# NeoVim Configuration
# Language Server installs
echo "Select Language Servers to Install"
echo "Typescript (y/n)"
read lsp_typescript
echo "Rust-Analyzer (y/n)"
read lsp_rust
[ "$lsp_typescript" = "y" ] && npm i -G typescript typescript-language-server
if [[ "$lsp_rust" = "y" ]]; then
	rustup default stable
	rustup component add rust-analyzer
    # Symlink rust-anayzer to path
    sudo ln -s $(rustup which rust-analyzer ) /usr/local/bin/rust-analyzer
    rustup update stable
fi

echo "Load dconf settings (y/n)?"
read load_dconf
[ "$load_dconf" = "y" ] && dconf load / < ~/.config/dconf.conf

# Cleanup
sudo pacman -Qtdq | sudo pacman -Rns -
