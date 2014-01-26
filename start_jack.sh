#!/bin/bash
killall -9 jackd
killall -9 jackdbus
mv ~/.log/jack/jackdbus.log ~/.log/jack/jackdbus.log.old
if [ -e /dev/fw1 ]; then
  jack_control eps driver firewire
  jack_control dps rate 88200
  jack_control dps period 256
  jack_control dps nperiods 3
else
  jack_control eps realtime true
  jack_control eps driver alsa
  jack_control dps device "hw:USB"
  jack_control dps rate 88200
  #jack_control dps rate 48000
  #jack_control dps nperiods 3
  jack_control dps nperiods 2
  jack_control dps period 1024
  #jack_control dps period 128
fi

jack_control start
sleep 1
aj2midid -e &
