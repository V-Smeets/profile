#!/bin/bash -e
#
cd "$(git rev-parse --show-toplevel)"

git fetch origin

git branch --list --all | \
	sed -e 's#/# #' -e 's#/# #' | \
	while read remotes remote branch tail
	do
		[ "$remotes" == "remotes" ] || continue
		[ "$branch" == "HEAD" ] && continue
		echo ""
		git checkout "$branch"
		git pull --ff-only "$remote"
	done

git checkout master
