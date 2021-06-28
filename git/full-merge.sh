#!/bin/bash -e
#
cd "$(git rev-parse --show-toplevel)"

checkout()
{
	branch="$1"
	echo ""
	git checkout "$branch"
}

merge()
{
	parent="$1"
	branch="$2"
	checkout "$branch"
	git merge --no-edit "$parent"
}

checkout etc/skel
merge etc/skel master

merge master AtoS
merge master thuis

merge AtoS DESKTOP-UAIF1VT
merge AtoS FSC
merge FSC vmma191
merge FSC vmma192
merge FSC vmma193

merge thuis Enschede
merge thuis Oudega

merge Enschede amr-ens
merge Enschede PC-Melanie
merge Enschede PC-Vincent

merge Oudega amr-odg
merge Oudega Friesland
merge Oudega HP-EliteBook

checkout master
