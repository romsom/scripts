#!/bin/sh
jack_control eps driver net
jack_control start && ncat --recv-only "$1" 52967
