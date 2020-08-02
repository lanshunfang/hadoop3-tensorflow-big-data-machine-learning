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

def revert_indexing_column_cat(col_idx, field_value):
    # 0__A  0
    # meaning: at column 0, there is a value A
    # Why 0__ prefix? It's eliminating ambiguity among columns
    return f'{col_idx}__{field_value}' + '\t' + col_idx

def main(argv):
    line = sys.stdin.readline()
    try:
        while line:
            line = line[:-1]
            if not line or ',' not in line:
                continue

            fields = line.split(",")
            for col_idx, field_value in enumerate(fields):
                if 'User_ID' in field_value or len(fields) < 10:
                    continue
                if re.match('[^0-9]', field_value) \
                    or field in columns_as_category_enforced:
                    print(revert_indexing_column_cat(col_idx, field_value))
            line = sys.stdin.readline()
    except "end of file":
        return None

if __name__ == "__main__":
     main(sys.argv)