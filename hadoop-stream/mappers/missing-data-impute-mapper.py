#!/usr/bin/python3

import sys
import re
import json

means_definition = {}

def prepare_col_scale_dict():
    global means_definition
    with open('means.json') as f:
        means_definition = json.load(f)

def mean_impute(col_idx, col_value):
    return col_value if col_value else str(means_definition[col_idx].mean)

def scale_columns(line):

    global means_definition
    fields = line.strip().split(",")
    if len(fields) < 10:
        return
    transfored_fields = []
    for col_idx, field_value in enumerate(fields):

        field_value = field_value.strip()
        transfored_fields.append(
            mean_impute(col_idx, field_value)
        )

    # 0__A  0
    # meaning: at column 0, there is a value A
    # Why 0__ prefix? It's eliminating ambiguity among columns
    return ','.join(transfored_fields)

def main(argv):
    prepare_col_scale_dict()
    line = sys.stdin.readline()
    try:
        while line and line.strip():
            line = line[:-1]
            if line and ',' in line:
                print(scale_columns(line))
           
            line = sys.stdin.readline()
    except "end of file":
        return None

if __name__ == "__main__":
     main(sys.argv)