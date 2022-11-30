. "${XDG_CONFIG_HOME}/shell/rc"

bindkey -e

if builtin command -v git > /dev/null; then
	export ZPLUG_HOME="${ZDOTDIR}/zplug"
	export ZPLUG_CACHE_DIR="${XDG_CACHE_HOME}/zcache"

	. "${ZPLUG_HOME}/init.zsh"

	# zplug "yisizawa/zplug"
	zplug "zsh-users/zsh"
	zplug "zsh-users/zsh", use:"Completion/BSD/Command",   if:"[[ $OSTYPE == freebsd* ]]"
	zplug "zsh-users/zsh", use:"Completion/Linux/Command",  if:"[[ $OSTYPE == linux* ]]"
	zplug "zsh-users/zsh", use:"Completion/Linux/Type", if:"[[ $OSTYPE == linux* ]]"
	zplug "zsh-users/zsh-completions", use:"src"
	zplug "zsh-users/zaw"
	zplug "${ZDOTDIR}/plugins", from:local

	if [ "$(echo "${ZSH_VERSION}" | awk -F. '{printf("%d%02d%02d", $1, $2, $3)}')" -le 50500 ]; then
		zplug "zsh-users/zsh", use:"Completion/Unix/Command"
		zplug "zsh-users/zsh", use:"Completion/Unix/Type"
		zplug "zsh-users/zsh", use:"Completion/Zsh/Command"
		zplug "zsh-users/zsh", use:"Completion/Zsh/Context"
		zplug "zsh-users/zsh", use:"Completion/Zsh/Function"
		zplug "zsh-users/zsh", use:"Completion/Zsh/Type"
	fi

	if ! zplug check; then
		zplug install
	fi

	if zplug check "zsh-users/zaw"; then
		bindkey '^R'  zaw-history
	fi

	zplug load
fi

bindkey '^]'   vi-find-next-char
bindkey '^[^]' vi-find-prev-cahr

if [ -n "${SSH_TTY}" ]; then
	prompt='%? %M %F{red}%/ %#%f '
else
	prompt='%? %M %F{green}%/ %#%f '
fi

case "${TERM}" in
	xterm) export TERM=xterm-256color ;;
	kterm) export TERM=kterm-256color ;;
	screen) export TERM=screen-256color ;;
esac

mkdir -p "${XDG_CACHE_HOME}/zsh"
HISTFILE="${XDG_CACHE_HOME}/zsh/history"
HISTSIZE=10000
SAVEHIST=10000

case "${OSTYPE}" in
	freebsd*)
		[[ ! -e "${HISTFILE}" ]] && cp "${XDG_CONFIG_HOME}/history/freebsd" "${HISTFILE}"
	;;
	linux-gnu)
		case "$(uname -r)" in
			*Microsoft)
			;;
		esac

		case "$(. /etc/os-release && echo "${ID}")" in
			arch)
			;;
			almalinux)
			;;
			debian)
			;;
			rhel)
			;;
			ubuntu)
			;;
		esac
	;;
esac

alias -s py='python'
alias -s rb='ruby'
alias -s pl='perl'
alias -s xz='xz -d'
alias -s txz='tar Jxvf'
alias -s bz2='bunzip2'
alias -s gz='gzip -d'

autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both

#historyを共有
setopt share_history
#複数のzshを同時に使う際にhistoryを追記に
setopt append_history
#括弧対応等を自動補完
setopt auto_param_keys
#ディレクトリ名に/を自動付与
setopt auto_param_slash
#補完候補を自動で補完
setopt auto_menu
#直前と同じコマンドはヒストリに追加しない
setopt hist_ignore_dups
#ヒストリにhistoryコマンドを記憶しない
setopt hist_no_store
#余計なスペースを削除してヒストリに記憶する
setopt hist_reduce_blanks
#=以後でも補完する
setopt magic_equal_subst
#日本語対応
setopt print_eight_bit
#cdなしでも移動
setopt auto_cd
setopt correct
#aliasを展開してから補完
setopt complete_aliases
#先頭空白は履歴に入れない
setopt hist_ignore_space
#コマンドが重複する場合古い方を削除(uniq)
setopt hist_ignore_all_dups

#大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
#../したときカレントディレクトリを除外する
zstyle ':completion:*' ignore-parents parent pwd ..
#補完候補に色をつける
zstyle ':completion:*' list-colors ''
#C-n,C-pで動かせるようにする
zstyle ':completion:*:default' menu select=10

function cd(){
	# $!が存在するディレクトリに移動したいとき面倒なので
	if [ -e "$1" ] && [ ! -d "$1" ]; then
		builtin cd $1:h
	else
		builtin cd $@
	fi
	ls
}

fpath=(~/.config/zsh/functions/Completion ${fpath})
typeset -U fpath path PATH

if builtin command -v zprof > /dev/null; then
	zprof | less
fi

trap '. "${XDG_CONFIG_HOME}/zsh/.zshrc"; fc -R; echo reload' USR1
