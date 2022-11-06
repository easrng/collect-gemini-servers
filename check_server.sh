#!/bin/sh
set -eu
SERVER="$1"
printf 'testing %s\n' "$SERVER">&2
IP_ADDR="$(dig +short A "$SERVER" |grep '[0-9]$' |head -n1)"
echo got ip>&2
ROUTE="{$(mtr -Tlnc 1 "$IP_ADDR" | grep '^h' | sed -E 's/^h\s+(\S+)\s+(.+)$/"\1":"\2"/'|tr '\n' ,|sed 's/,$//')}"
echo got route>&2
CERTS="$(openssl s_client -showcerts -servername="$SERVER" -connect="$IP_ADDR":1965 </dev/null| ex +'g/BEGIN CERTIFICATE/,/END CERTIFICATE/p' /dev/stdin  -scq | jq -cRs '.')"
echo got certs>&2
printf '%s' '{"server":'"$(printf '%s' "$SERVER"| jq -cRs '.')"',"ip":"'"$IP_ADDR"'","route":'"$ROUTE"',"certs":'"$CERTS"'}'|jq >pub/sites/"$SERVER"-"$(date '+%s')".json
