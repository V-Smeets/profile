#!/bin/bash -e
#
cd "$(git rev-parse --show-toplevel)"

checkout()
{
	branch="$1"
	echo ""
	git checkout "$branch"
}

rebase()
{
	parent="$1"
	branch="$2"
	branchBase="base/$branch"
	if git rev-parse --verify --quiet "$branchBase" >/dev/null
	then
		git rebase --onto="$parent" "$branchBase" "$branch"
	else
		checkout "$branch"
		git rebase "$parent"
	fi
	git branch --force "$branchBase" "$parent"
}

checkout etc/skel
rebase etc/skel master

rebase master AtoS
rebase master thuis

rebase AtoS DESKTOP-UAIF1VT
rebase AtoS FSC
rebase FSC vmma191
rebase FSC vmma192
rebase FSC vmma193

checkout master
