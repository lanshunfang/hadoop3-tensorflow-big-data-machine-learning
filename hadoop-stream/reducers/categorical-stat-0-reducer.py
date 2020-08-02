#!/usr/bin/python3

import sys
import re

columns_as_category_enforced = {
    'User_ID': True,
    'Product_ID': True,
    'Occupation': True,
    'City_Category': True,
    'Product_Category_2': True,
    'Product_Category_3': True,
}


def restore_indexing_column_cat(key_value_list):
    # 0__A  0
    # meaning: at column 0, there is a value A
    # Why 0__ prefix? It's eliminating ambiguity among columns
    return str(key_value_list[1]) + '\t' + str(key_value_list[0])


def main(argv):
    line = sys.stdin.readline()
    try:
        while line:
            line = line[:-1]
            # 0__A  0   0   0   0   0
            if not line or '\t' not in line:
                continue
            key_value_list = line.split('\t')
            print(restore_indexing_column_cat(key_value_list))
            line = sys.stdin.readline()
    except "end of file":
        return None


if __name__ == "__main__":
     main(sys.argv)
