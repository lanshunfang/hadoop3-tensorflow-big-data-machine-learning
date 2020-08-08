#!/usr/bin/python3

import sys
import re

def convert_digit_plus_range(value):
    digit = int(re.search(r'\d+', value)[0])
    other = re.search(r'\D+', value)
    other = 1 if other else 0
    return str(digit + other)

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

extra_col_convert = {
    6: convert_digit_plus_range
}

def revert_indexing_column_cat(col_idx, field_value):
    # 0__A  0
    # meaning: at column 0, there is a value A
    # Why 0__ prefix? It's eliminating ambiguity among columns
    return f'{col_idx}__{field_value}' + '\t' + str(col_idx)

def main(argv):
    global columns_as_category_enforced
    global extra_col_convert
    line = sys.stdin.readline()
    try:
        while line and line.strip():
            line = line[:-1]
            if line and ',' in line and 'User_ID' not in line :
                fields = line.strip().split(",")
                if len(fields) >= 10:
                    for col_idx, field_value in enumerate(fields):

                        if col_idx in extra_col_convert:
                            field_value = extra_col_convert[col_idx](field_value)
                        
                        if re.match('[^0-9]', field_value) \
                            or col_idx in columns_as_category_enforced \
                                or col_idx in extra_col_convert:
                            print(revert_indexing_column_cat(col_idx, field_value))

            line = sys.stdin.readline()
    except "end of file":
        return None

if __name__ == "__main__":
     main(sys.argv)