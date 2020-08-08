#!/usr/bin/python3

import sys
import re
import json

column_scaler_definition = {}

def prepare_col_scale_dict():
    global column_scaler_definition
    with open('min_max.json') as f:
        column_scaler_definition = json.load(f)

def min_max_scale(col_idx, col_value):
    if not col_value:
        return ''
    col_value = float(col_value)
    value_range = column_scaler_definition['max'][str(col_idx)] - column_scaler_definition['min'][str(col_idx)]
    return str(col_value/value_range if value_range else col_value);

def scale_columns(line):

    global column_scaler_definition
    fields = line.strip().split(",")
    if len(fields) < 10:
        return
    transfored_fields = []
    for col_idx, field_value in enumerate(fields):

        field_value = field_value.strip()
        transfored_fields.append(
            min_max_scale(col_idx, field_value)
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