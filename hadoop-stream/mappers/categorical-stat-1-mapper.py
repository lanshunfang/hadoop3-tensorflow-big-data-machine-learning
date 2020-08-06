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

column_encoder_definition = {}

def prepare_col_cat_dict():
    global column_encoder_definition
    f = open("column_encoder_definition.txt", "r")
    lines = f.readlines() 
    # Strips the newline character 
    for line in lines: 
        if not line or not line.strip():
            continue
        line = line.strip()
        def_map = line.split('\t')
        column_encoder_definition[def_map[0].strip()] = def_map[1].strip()

def encode_categorical_columns(line):
    global columns_as_category_enforced
    global extra_col_convert
    fields = line.strip().split(",")
    if len(fields) < 10:
        return
    transfored_fields = []
    for col_idx, field_value in enumerate(fields):

        field_value = field_value.strip()

        if col_idx in extra_col_convert:
            field_value = extra_col_convert[col_idx](field_value)
        
        if re.match('[^0-9]', field_value) \
            or col_idx in columns_as_category_enforced \
                or col_idx in extra_col_convert:
                lookup_cat_value_key = f'{col_idx}__{field_value}'
                if lookup_cat_value_key in column_encoder_definition:

                    transfored_fields.append(
                        column_encoder_definition[lookup_cat_value_key]
                    )
                else: 
                    transfored_fields.append(field_value)
        else:
            transfored_fields.append(field_value)
    # 0__A  0
    # meaning: at column 0, there is a value A
    # Why 0__ prefix? It's eliminating ambiguity among columns
    return ','.join(transfored_fields)

def main(argv):
    prepare_col_cat_dict()
    line = sys.stdin.readline()
    try:
        while line and line.strip():
            line = line[:-1]
            if line and ',' in line:
                if 'User_ID' not in line:
                    print(encode_categorical_columns(line))

                # else:
                #     print(line)
           
            line = sys.stdin.readline()
    except "end of file":
        return None

if __name__ == "__main__":
     main(sys.argv)