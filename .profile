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

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

[ -n "${PS1-}" ] && echo ".profile($$): Finish"
