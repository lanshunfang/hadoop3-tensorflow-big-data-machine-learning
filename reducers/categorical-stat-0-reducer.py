#!/usr/local/bin/python3

import sys
import re

col_idx = None
col_cat_dict = {}

def restore_indexing_column_cat(key_value_list):
    # 0__A  0
    # meaning: at column 0, there is a value A
    # Why 0__ prefix? It's eliminating ambiguity among columns

    global col_cat_dict
    global col_idx

    cat_in = key_value_list[0]
    col_idx_in = key_value_list[1]

    if col_idx is not None and col_idx_in != col_idx:
        cat_encoded_int = 0
        for col_cat_key in col_cat_dict:
            print(col_cat_key, '\t', cat_encoded_int)
            cat_encoded_int += 1
        col_cat_dict = {}

    col_cat_dict[cat_in] = 1
    col_idx = col_idx_in

    # return str() + '\t' + str()

def main(argv):
    line = sys.stdin.readline()
    global col_cat_dict
    global col_idx
    col_idx = None
    col_cat_dict = {}
    try:
        while line and line.strip():
            line = line[:-1]
            # 0__A  0   0   0   0   0
            if line:
                key_value_list = line.split('\t')
                restore_indexing_column_cat(key_value_list)
            line = sys.stdin.readline()
    except "end of file":
        return None

if __name__ == "__main__":
     main(sys.argv)
