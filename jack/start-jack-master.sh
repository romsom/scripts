#!/bin/bash
PATH="${HOME}/Repo/scripts/jack:$PATH"
jack_control start
jack_load netmanager

while true; do
    # wait for signal from remote client
    ncat --send-only -l -p 52967 < <(echo success)
    # connect all clients from $@
    for client in "$@"; do
	echo "connecting client: $client"
	jack-autoconnect.py --sclient system --dclient "$client"
	jack-autoconnect.py --dclient system --sclient "$client"
    done
done
