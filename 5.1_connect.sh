#!/bin/sh
## 5.1 connect [source] [destination]

jack_connect $1:out_1 $2:playback_1
jack_connect $1:out_2 $2:playback_2

jack_connect $1:out_3 $2:playback_1
jack_connect $1:out_4 $2:playback_2

jack_connect $1:out_5 $2:playback_1
jack_connect $1:out_5 $2:playback_2

jack_connect $1:out_6 $2:playback_1
jack_connect $1:out_6 $2:playback_2

