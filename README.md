# dotfiles
my dotfiles

## install nix
https://nixos.org/download.html

## enable flakes
add the following to `/etc/nix/nix.conf`
`experimental-features = nix-command flakes`

## install stow
`brew install stow` - other package managers are available

## stow the home-manager and nvim directories
`stow home-manager && stow nvim` 

## uninstall stow (it will be installed with nix)
`brew uninstall stow`

## build home with nix
`home-manager switch`

## (optional) install brew packages
`brew bundle`
