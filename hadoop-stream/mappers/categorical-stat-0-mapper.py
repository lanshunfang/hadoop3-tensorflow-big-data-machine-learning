#!/usr/bin/python3

import sys
import re

columns_as_category_enforced = {
    0: 'User_ID',
    1: 'Product_ID',
    3: 'Age',
    4: 'Occupation',
    5: 'City_Category',
    8: 'Product_Category_1',
    9: 'Product_Category_2',
    10: 'Product_Category_3',
}

def revert_indexing_column_cat(col_idx, field_value):
    # 0__A  0
    # meaning: at column 0, there is a value A
    # Why 0__ prefix? It's eliminating ambiguity among columns
    return f'{col_idx}__{field_value}' + '\t' + str(col_idx)

def main(argv):
    line = sys.stdin.readline()
    try:
        while line and line.strip():
            line = line[:-1]
            if line and ',' in line and 'User_ID' not in line :
                fields = line.strip().split(",")
                for col_idx, field_value in enumerate(fields):
                    if len(fields) < 10:
                        continue
                    if re.match('[^0-9]', field_value) \
                        or col_idx in columns_as_category_enforced:
                        print(revert_indexing_column_cat(col_idx, field_value))
            line = sys.stdin.readline()
    except "end of file":
        return None

if __name__ == "__main__":
     main(sys.argv)