# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.
[ -n "${PS1-}" ] && echo ".profile($$): Start"

# Define and create the XDG directories
mkdir -p "${XDG_CONFIG_HOME:=$HOME/.config}"
mkdir -p "${XDG_DATA_HOME:=$HOME/.local/share}"
mkdir -p "${XDG_CACHE_HOME:=$HOME/.cache}"

# Get the directory that contains the real profile file.
if [ -h "$HOME/.profile" ]
then
	export PROFILE_DIR=$(dirname $(readlink --canonicalize-existing "$HOME/.profile"))
	echo "PROFILE_DIR=$PROFILE_DIR" >"$XDG_DATA_HOME/systemd.user.env"
	for file in \
		.bash_aliases \
		.bash_logout \
		.bashrc \
		.config/systemd/user \
		.forward \
		.gitconfig \
		.gnupg/dirmngr.conf \
		.gnupg/gpg-agent.conf \
		.gnupg/gpg.conf \
		.gnupg/sks-keyservers.netCA.pem \
		.gnupg/sshcontrol \
		.inputrc \
		.profile \
		.ssh/config \
		.vimrc
	do
		fullFile="$HOME/$file"
		fullTarget="$PROFILE_DIR/$file"
		[ -e "$fullTarget" ] || continue
		target=$(realpath --canonicalize-missing --relative-to=$(dirname "$fullFile") "$fullTarget")
		diff --brief --recursive "$fullFile" "$fullTarget" >/dev/null
		if [ "$?" -ne 0 ]
		then
			[ -n "${PS1-}" ] && echo ".profile($$): Update link $file"
			fileDir=$(dirname "$fullFile")
			suffix=$(date '+%Y%m%d-%H%M%S')
			mkdir -p "$fileDir"
			[ -e "$fullFile" ] && mv "$fullFile" "${fullFile}.${suffix}"
			ln -fs "$target" "$fullFile"
		fi
	done
	unset -v fullFile fileDir fullTarget target
fi

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# Remove $1 from the path $2
remove_path () {
	local path=$(eval echo "\$${2:-PATH}" | sed \
		-e 's#^#:#' \
		-e 's#$#:#' \
		-e 's#:'"$1"':#:#g' \
		-e 's#^:##' \
		-e 's#:$##' \
		)
	eval "${2:-PATH}"="\$path"
}
# if $1 is a directory, prepend it to path $2
prepend_path () {
	[ -d "${1:-.}" ] && remove_path "$@" && eval "${2:-PATH}"="\$1:\$${2:-PATH}"
}
# if $1 is a directory, append it to path $2
append_path () {
	[ -d "${1:-.}" ] && remove_path "$@" && eval "${2:-PATH}"="\$${2:-PATH}:\$1"
}

prepend_path "/usr/local/bin"
prepend_path "/usr/local/sbin"
prepend_path "/usr/bin"
prepend_path "/usr/sbin"
prepend_path "/bin"
prepend_path "/sbin"
prepend_path "$PROFILE_DIR/bin"
prepend_path "$HOME/.local/bin"
prepend_path "$HOME/bin"
prepend_path "/c/Project/apache-maven-3.6.3/bin"

unset -f remove_path prepend_path append_path

unset LC_ALL
export LANG=de_DE.utf8
unset LANGUAGE
unset LC_ADDRESS
unset LC_COLLATE
unset LC_CTYPE
unset LC_IDENTIFICATION
unset LC_MEASUREMENT
export LC_MESSAGES=en_US.utf8
unset LC_MONETARY
unset LC_NAME
unset LC_NUMERIC
unset LC_PAPER
unset LC_TELEPHONE
unset LC_TIME

export DEBEMAIL="Vincent.VSmeets@GMail.com"
export DEBFULLNAME="Vincent Smeets"
export MORE="-c"
export VISUAL="vi"

# Start my own anacron
[ -f $HOME/.anacron/anacrontab ] && anacron -t $HOME/.anacron/anacrontab -S $HOME/.anacron

[ -n "${PS1-}" ] && echo ".profile($$): Finish"
