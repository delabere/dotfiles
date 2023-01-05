# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to your oh-my-zsh installation.
export ZSH="/Users/jackrickards/.oh-my-zsh"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"
# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"
# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"
# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"
# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13
# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"
# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"
# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"
# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"
# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"
# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"
# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)
# source $ZSH/oh-my-zsh.sh
# User configuration
# export MANPATH="/usr/local/man:$MANPATH"
# You may need to manually set your language environment
# export LANG=en_US.UTF-8
# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
# Compilation flags
# export ARCHFLAGS="-arch x86_64"
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# =============================================================================
#
# Utility functions for zoxide.
#
# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd() {
    \builtin pwd -L
}
# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd() {
    # shellcheck disable=SC2164
    \builtin cd "$@"
}
# =============================================================================
#
# Hook configuration for zoxide.
#
# Hook to add new entries to the database.
function __zoxide_hook() {
    zoxide add -- "$(__zoxide_pwd)"
}
# Initialize hook.
if [ "${__zoxide_hooked}" != '1' ]; then
    __zoxide_hooked='1'
    precmd_functions+=(__zoxide_hook)
fi
# =============================================================================
#
# When using zoxide with --no-aliases, alias these internal functions as
# desired.
#
# Jump to a directory using only keywords.
function __zoxide_z() {
    if [ "$#" -eq 0 ]; then
        __zoxide_cd ~
    elif [ "$#" -eq 1 ] && [ "$1" = '-' ]; then
        if [ -n "${OLDPWD}" ]; then
            __zoxide_cd "${OLDPWD}"
        else
            # shellcheck disable=SC2016
            \builtin printf 'zoxide: $OLDPWD is not set'
            return 1
        fi
    elif [ "$#" -eq 1 ] &&  [ -d "$1" ]; then
        __zoxide_cd "$1"
    else
        \builtin local __zoxide_result
        __zoxide_result="$(zoxide query --exclude "$(__zoxide_pwd)" -- "$@")" \
            && __zoxide_cd "${__zoxide_result}"
    fi
}
# Jump to a directory using interactive search.
function __zoxide_zi() {
    \builtin local __zoxide_result
    __zoxide_result="$(zoxide query -i -- "$@")" && __zoxide_cd "${__zoxide_result}"
}
# =============================================================================
#
# Convenient aliases for zoxide. Disable these using --no-aliases.
#
# Remove definitions.
function __zoxide_unset() {
    \builtin unalias "$@" &>/dev/null
    \builtin unfunction "$@" &>/dev/null
    \builtin unset "$@" &>/dev/null
}
__zoxide_unset 'z'
function z() {
    __zoxide_z "$@"
}
__zoxide_unset 'zi'
function zi() {
    __zoxide_zi "$@"
}
# =============================================================================
#
# To initialize zoxide, add this to your configuration (usually ~/.zshrc):
#
eval "$(zoxide init zsh)"
# https://monzo.slack.com/archives/C014ACS073P/p1628526104000800
function pot-cash {
  £exec go run ~/src/github.com/monzo/wearedev/scripts/cmd/savings/pot-cashflow/*.go $1 $2
}
# Monzo Starter Pack 
[ -f $HOME/src/github.com/monzo/starter-pack/zshrc ] && source $HOME/src/github.com/monzo/starter-pack/zshrc
#
# NVM settings
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh"  # This loads nvm
[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && . "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

source /Users/jackrickards/src/github.com/monzo/analytics/dbt/misc/shell/source.sh
export PATH="${CURRENT_USER}/.poetry/bin:$PATH"
# source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
# source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
export OVO_API_KEY="a10dc0d034dca7c7c0da347792fbe7bc06e5d59a5de46e14127da9d4d47e8907"
export OCTOPUS_API_KEY="sk_live_c2DwWuvlwVVNnrn2myIIBw1i"
function ship2prod() {
    shipper deploy $1 --s101 --skip-confirm-rollout && shipper deploy $1 --prod --skip-confirm-rollout
}
export VISUAL=nvim
export EDITOR=nvim
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# allows me to create draft and new prs with ease
newpr () {
	gh pr create --title="$1" --body="$2" -w
}
draftpr () {
	gh pr create --title="$1" --body="$2" -d
}
alias config='/usr/bin/git --git-dir=/Users/jackrickards/.cfg/.git/ --work-tree=/Users/jackrickards'
alias lg='lazygit'
alias v='nvim'
alias gcm='git checkout master && git pull'
source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme
export PATH="/opt/homebrew/opt/node@16/bin:$PATH"
export PYENV_ROOT=$(brew --prefix)/var/pyenv
export PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
if command -v pyenv 1>/dev/null 2>&1; then eval "$(pyenv init -)"; fi
export PATH="${CURRENT_USER}/.poetry/bin:$PATH"
source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
export CLOUDSDK_PYTHON=
export OAUTHLIB_RELAX_TOKEN_SCOPE=1
export PATH="${CURRENT_USER}/.poetry/bin:$PATH"
export PATH="${CURRENT_USER}/.poetry/bin:$PATH"
export PATH="${CURRENT_USER}/.local/bin:$PATH"
export PATH="${CURRENT_USER}/.local/bin:$PATH"
export PATH="${CURRENT_USER}/.local/bin:$PATH"
export PATH="${CURRENT_USER}/.local/bin:$PATH"
export PATH="${CURRENT_USER}/.local/bin:$PATH"
export PATH="${CURRENT_USER}/.local/bin:$PATH"
