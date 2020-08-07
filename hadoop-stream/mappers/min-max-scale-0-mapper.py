#!/usr/bin/python3

import sys
import re

def main(argv):
   
    line = sys.stdin.readline()
    try:
        while line and line.strip():
            line = line[:-1]
            print(line)
            # if line and ',' in line:
            #     fields = line.strip().split(",")
            #     if len(fields) >= 10:
            #         for col_idx, field_value in enumerate(fields):
            #             field_value = field_value.strip()

            line = sys.stdin.readline()
    except "end of file":
        return None

if __name__ == "__main__":
     main(sys.argv)