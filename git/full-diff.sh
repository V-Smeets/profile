#!/bin/bash -e
#
set -o errexit
set -o pipefail
set +o xtrace

cd "$(git rev-parse --show-toplevel)"

git branch --list --remotes \
| sed -e 's#/# #' \
| while read remote branch tail
  do
	[ "$branch" == "HEAD" ] && continue
	echo ""
	echo "Branch: ${branch}"
	git diff "${remote}/${branch}..${branch}"
  done
