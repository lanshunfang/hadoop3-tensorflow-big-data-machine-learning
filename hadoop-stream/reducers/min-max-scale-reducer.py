#!/usr/bin/python3

import sys
import re
import json

min_max = {
    'min': {},
    'max': {}
}

def find_min_max(line):
    global min_max

    fields = line.split(',')
    for col_idx, col_val in enumerate(fields):

        min_max['min'].setdefault(col_idx, float(sys.maxsize))
        min_max['max'].setdefault(col_idx, -(float(sys.maxsize - 1)))

        if col_val:
            col_val = float(col_val)
            min_max['min'][col_idx] = min(min_max['min'][col_idx], col_val)
            min_max['max'][col_idx] = max(min_max['max'][col_idx], col_val)

def main(argv):
    line = sys.stdin.readline()
    try:
        while line and line.strip():
            line = line[:-1]
            # 0__A  0   0   0   0   0
            if line and line.strip():
                find_min_max(line.strip())
            line = sys.stdin.readline()
        print(json.dumps(min_max))
    except "end of file":
        return None

if __name__ == "__main__":
     main(sys.argv)
