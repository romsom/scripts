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

    args = parser.parse_args()

    shre = re.compile(args.sclient)
    spre = re.compile(args.sport)
    dhre = re.compile(args.dclient)
    dpre = re.compile(args.dport)

    ports = jack.getPorts()
    sources = [p for p in ports if shre.match(p.client) and spre.match(p.port)]
    dests = [p for p in ports if dhre.match(p.client) and dpre.match(p.port)]
    for s in sources:
        if s.isOutput():
            print(s)
            for d in dests:
                if d.isInput():
                    print("\t-> {}".format(d))
                    jack.connect(s, d)
