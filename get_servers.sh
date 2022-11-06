#!/bin/sh
set -eu
ORIG_DIR="$(pwd)"
cd -- "$(dirname -- "$(command -v -- "$0")")"
{
cat pub/servers.list
printf 'gemini://geminispace.info/known-hosts\r\n' | openssl s_client -quiet -connect geminispace.info:1965 2>/dev/null | grep '=> gemini://' | awk '{print $2}'|sed -E 's/^gemini:\/\/|\/$//g'
} | sort | uniq >servers.list.tmp
mv servers.list.tmp pub/servers.list
cd pub
git add servers.list && git commit -m 'update servers' && git push -u origin main
cd "$ORIG_DIR"
