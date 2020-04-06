#!/usr/bin/env python3

import sys
import re

channel_re = re.compile(r'^ *; *Channels *\((\d+)/\d+\):(.*)$')


if __name__ == '__main__':
    fn1 = sys.argv[1]
    fn2 = sys.argv[2]

    f1_ch_conf = None
    f2_ch_conf = None

    f1_comments = []
    f2_comments = []

    end_reached = False
    
    with open(fn1, 'r') as f1:
        with open(fn2, 'r') as f2:
            while not end_reached:
                l1 = f1.readline()
                if len(l1) == 0:
                    break
                l2 = f2.readline()
                if len(l2) == 0:
                    break

                if l1[-1] == '\n':
                    l1 = l1[:-1]
                else:
                    end_reached = true
                if l2[-1] == '\n':
                    l2 = l2[:-1]
                else:
                    end_reached = true

                if l1.strip()[0] == ';':
                    if channel_re.match(l1):
                        f1_ch_conf = channel_re.match(l1).groups()
                        if f2_ch_conf is not None:
                            n = int(f1_ch_conf[0]) + int(f2_ch_conf[0])
                            print('; Channels: ({:d}/{:d}): {:s},{:s}'.format(n, n, f1_ch_conf[1], f2_ch_conf[1]))
                            # print line 2 before continuing
                            if l2 not in l1_comments:
                                f2_comments += [l2]
                                print(l2)
                            continue
                    elif l1 not in f2_comments:
                        f1_comments += [l2]
                        print(l1)
                    if channel_re.match(l2):
                        f2_ch_conf = channel_re.match(l2).groups()
                        if f1_ch_conf is not None:
                            n = int(f1_ch_conf[0]) + int(f2_ch_conf[0])
                            print('; Channels: ({:d}/{:d}): {:s},{:s}'.format(n, n, f1_ch_conf[1], f2_ch_conf[1]))
                            # line 1 was either printed before or matched channel_re
                            continue
                    elif l2 not in f1_comments:
                        f2_comments += [l2]
                        print(l2)
                    continue

                    
                print('{:s},{:s}'.format(l1, l2))

                
