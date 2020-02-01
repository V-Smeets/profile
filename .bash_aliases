unalias -a

[ -n "$PROFILE_DIR" ] && alias apt-reset="sudo '$PROFILE_DIR/bin/apt-reset'"

alias dir='dir --color=auto'
alias docker-watch=$'watch \'
	docker stack ls;
	echo "";
	docker service ls;
	echo "";
	docker container ls;
	echo "";
	docker volume ls;
	echo "";
	docker images\''

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
