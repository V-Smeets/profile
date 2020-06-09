unalias -a

[ -n "$PROFILE_DIR" ] && alias apt-reset="sudo '$PROFILE_DIR/bin/apt-reset'"

alias dir='dir --color=auto'
alias docker-watch=$'watch \'
	echo "Stacks:";
	docker stack ls;
	echo "";
	echo "Services:";
	docker service ls;
	echo "";
	echo "Containers:";
	docker container ls;
	echo "";
	echo "Volumes:";
	docker volume ls;
	echo "";
	echo "Images:";
	docker images\''
alias egrep='egrep --color=auto --exclude-dir=.svn'
alias fgrep='fgrep --color=auto --exclude-dir=.svn'
alias grep='grep --color=auto --exclude-dir=.svn'
alias h='history'
alias l='ls --color=auto --escape -l'
alias ls='ls --color=auto'
alias man='man -a'
alias rm='rm --one-file-system --preserve-root'
alias sudo='sudo VISUAL="$VISUAL" XAUTHORITY="${XAUTHORITY:-$HOME/.Xauthority}"'
alias vdir='vdir --color=auto'

cd() {
	builtin cd "$@" >/dev/null && dirs
}

dirs() {
	builtin dirs -v "$@"
}

popd() {
	builtin popd "$@" >/dev/null && dirs
}

pushd() {
	case "$1" in
	[+-][0-9]*)
		local pushdNewDir=$(builtin dirs "$1" | sed -e "s#^~#$HOME#")
		builtin popd "$1" >/dev/null
		builtin pushd "$pushdNewDir" >/dev/null
		;;
	*)
		builtin pushd "$@" >/dev/null
		;;
	esac
	dirs
}
