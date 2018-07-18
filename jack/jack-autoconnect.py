#!/usr/bin/env python3

import re
import jack
import argparse

if __name__ == "__main__":
    parser = argparse.ArgumentParser("Autoconnect jack ports")
    parser.add_argument('--sclient', default=".*")
    parser.add_argument('--sport', default=".*")
    parser.add_argument('--dclient', default=".*")
    parser.add_argument('--dport', default=".*")
    parser.add_argument('--number-of-ports', '-n', default=-1, type=int)
    parser.add_argument('--sstart', default=0)
    parser.add_argument('--dstart', default=0)

    args = parser.parse_args()

    shre = re.compile(args.sclient)
    spre = re.compile(args.sport)
    dhre = re.compile(args.dclient)
    dpre = re.compile(args.dport)

    ports = jack.getPorts()
    sources = [p for p in ports if shre.match(p.client) and spre.match(p.port)]
    dests = [p for p in ports if dhre.match(p.client) and dpre.match(p.port)]

    n = min(len(sources), len(dests))
    if args.number_of_ports >= 0:
        n = min(n, args.number_of_ports)
    send = min(len(sources), args.sstart + n)
    dend = min(len(dests), args.dstart + n)
    pairs = zip(sources[args.sstart:send], dests[args.dstart:dend])
    for s, d in pairs:
        if s.isOutput() and d.isInput():
            print("{}\t-> {}".format(s,d))
            jack.connect(s, d)
