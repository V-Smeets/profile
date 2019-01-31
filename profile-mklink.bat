@echo off

set homeDir="C:\Users\S230984"
set profileDir="C:\Project\None\src\profile"

for %%F in (
	.bash_aliases,
	.bash_logout,
	.bashrc,
	.config\systemd\user,
	.forward,
	.gitconfig,
	.gnupg\dirmngr.conf,
	.gnupg\gpg-agent.conf,
	.gnupg\gpg.conf,
	.gnupg\sks-keyservers.netCA.pem,
	.gnupg\sshcontrol,
	.inputrc,
	.profile,
	.ssh\config,
	.vimrc
) do (
	echo Updating %%F
	del /q %homeDir%\%%F
	mklink %homeDir%\%%F %profileDir%\%%F
)

pause
exit
