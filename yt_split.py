#!/usr/bin/env python3

import re
import sys
import os
import subprocess

line_pat = re.compile(r'(?P<tracknumber>\d?\d) *[ .-] *(?P<artist>[^-]*[^ ]) *- *(?P<title>.*?[^ ])(?:  +(?:(?P<hours>\d?\d):)?(?P<minutes>\d?\d):(?P<seconds>\d?\d)|$)')

def usage():
    print('{}: split audio file using ffmpeg and track information like usually used in Youtube comments.\n'.format(sys.argv[0]), file=sys.stderr)
    print('Usage: {} <input file>'.format(sys.argv[0]), file=sys.stderr)
    print('Provide track information via a .txt file that has the same name as the source file except the extension.', file=sys.stderr)
    print('E.g., copy and paste in terminal (usually Ctrl-Shift-v) and then press Ctrl-d.', file=sys.stderr)

def format_num(num: str) -> str:
    num_val = int(num)
    return '{:02d}'.format(num_val)


if __name__ == '__main__':
    if len(sys.argv) != 2:
        usage()
        exit(1)
    source_filename = sys.argv[1]
    file_base, file_ext = os.path.splitext(source_filename)
    try:
        source_file = open('{}.txt'.format(file_base), mode='r')
    except OSError as e:
        print(e, file=sys.stderr)
        usage()
        exit(1)

    # elms = [line_pat.match(l).groupdict(default=0) for l in sys.stdin.read().split('\n')]
    # lines = sys.stdin.read().split('\n')
    lines = source_file.read().split('\n')
    source_file.close()
    elms = []
    for n, line in enumerate(lines):
        match = line_pat.match(line)
        if match is not None:
            elms += [match.groupdict(default=0)]
            # print(match.groupdict(default=0), file=sys.stderr)
        elif len(line) > 0:
            print('No match found in line {}:\n{}'.format(n, line), file=sys.stderr)
    # create dir for split files
    try:
        os.mkdir(file_base)
    except Exception as e:
        print(e, file=sys.stderr)
        exit(1)
    # call ffmpeg
    # ffmpeg_args = ['ffmpeg']
    for i, elm in enumerate(elms[:-1]):
        next_elm = elms[i + 1]
        # ffmpeg_args += ['-ss {}:{}:{}'.format(format_num(elm['hours']), elm['minutes'], elm['seconds']),
        ffmpeg_args = ['ffmpeg',
                       '-ss', '{}:{}:{}'.format(format_num(elm['hours']), format_num(elm['minutes']), format_num(elm['seconds'])),
                       '-to', '{}:{}:{}'.format(format_num(next_elm['hours']), format_num(next_elm['minutes']), format_num(next_elm['seconds'])),
                       '-i', '{}'.format(source_filename),
                       '-c', 'copy',
                       '-metadata', 'artist={}'.format(elm['artist']),
                       '-metadata', 'title={}'.format(elm['title']),
                       os.path.join(file_base, '{}-{} - {}{}'.format(elm['tracknumber'], elm['artist'], elm['title'], file_ext))]
        print('Splitting track "{}"'.format(ffmpeg_args[-1]))
        for arg in ffmpeg_args[:-1]:
            print("'{}'".format(arg), end=' ')
        for arg in ffmpeg_args[-1:]:
            print("'{}'\n".format(arg))
        subprocess.run(ffmpeg_args, capture_output=True)

    # last element (if any)
    if len(elms[-1:]) > 0:
        elm = elms[-1]
        ffmpeg_args = ['ffmpeg',
                       '-ss', '{}:{}:{}'.format(format_num(elm['hours']), format_num(elm['minutes']), format_num(elm['seconds'])),
                       '-i', '{}'.format(source_filename),
                       '-c', 'copy',
                       '-metadata', 'artist={}'.format(elm['artist']),
                       '-metadata', 'title={}'.format(elm['title']),
                       os.path.join(file_base, '{}-{} - {}{}'.format(elm['tracknumber'], elm['artist'], elm['title'], file_ext))]
        print('Splitting track "{}"'.format(ffmpeg_args[-1]))
        for arg in ffmpeg_args[:-1]:
            print("'{}'".format(arg), end=' ')
        for arg in ffmpeg_args[-1:]:
            print("'{}'\n".format(arg))
        subprocess.run(ffmpeg_args, capture_output=True)

    exit(0)

# for elm in [line_pat.findall(l) for l in input2.split('\n')]: print(elm)
# for elm in [line_pat.match(l).groupdict(default=0) for l in input2.split('\n')]: print(elm)
