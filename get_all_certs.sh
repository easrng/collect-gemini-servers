#!/bin/sh
ORIG_DIR="$(pwd)"
cd -- "$(dirname -- "$(command -v -- "$0")")" || exit 1
parallel ./check_server.sh <"${1:-./pub/servers.list}"
cd pub
git add sites && git commit -m 'update cert list' && git push -u origin main
cd "$ORIG_DIR" || exit 1
