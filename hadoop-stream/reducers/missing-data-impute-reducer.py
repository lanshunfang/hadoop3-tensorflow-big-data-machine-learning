#!/usr/bin/python3

import sys
import re
import json

means = {
}


def update_means(line):
    global means

    fields = line.split(',')
    for col_idx, col_val in enumerate(fields):

        means.setdefault(
            col_idx,
            {
                sum: 0.0,
                count: 0
            }
        )

        if col_val:
            col_val = float(col_val)
            means[col_idx].sum += col_val
            means[col_idx].count += 1


def main(argv):
    line = sys.stdin.readline()
    try:
        while line and line.strip():
            line = line[:-1]
            # 0__A  0   0   0   0   0
            if line and line.strip():
                update_means(line.strip())
            line = sys.stdin.readline()
        for col_item in means:
            col_item['mean'] = col_item['sum'] / col_item['count'] if col_item['count'] else 0
        print(json.dumps(means))
    except "end of file":
        return None

if __name__ == "__main__":
     main(sys.argv)
