#!/usr/bin/python3

import sys
import os
import re
import json
import tensorflow as tf

column_names = ["User_ID", "Product_ID", "Gender", "Age", "Occupation", "City_Category", "Stay_In_Current_City_Years",
                "Marital_Status", "Product_Category_1", "Product_Category_2", "Product_Category_3", "Purchase"]

hdfs_path = '/machine-learning-final/tfrecords'
tmp_path = '/tmp/_ml_bd_tfrecords_'

def _float_feature(value):
  """Returns a float_list from a float / double."""
  return tf.train.Feature(float_list=tf.train.FloatList(value=[value]))


def convert_line_to_tf_features(line):
    global column_names
    tf_features = {}
    fields = line.split(',')
    if len(fields) < 10:
        return
    for key,value in enumerate(fields):
        tf_features[column_names[key]] = _float_feature(float(value))
    return tf_features

def save_feature_as_tf_records(tf_features, tf_record_writer):
    tf_example = tf.train.Example(features=tf.train.Features(feature=tf_features))
    tf_record_writer.write(
        tf_example.SerializeToString()
    ) 

def main(argv):
    global tmp_path
    os.system(f"rm -rf {tmp_path} > /dev/null 2>&1")
    os.system(f"hadoop fs -rm -r {hdfs_path} > /dev/null 2>&1")
    line = sys.stdin.readline()
    try:

        tf_record_writer = tf.io.TFRecordWriter(tmp_path)
        while line and line.strip():
            line = line[:-1]
            # 0__A  0   0   0   0   0
            if line and line.strip() and ',' in line:
                tf_features = convert_line_to_tf_features(line.strip())
                save_feature_as_tf_records(tf_features, tf_record_writer)
            line = sys.stdin.readline()

        tf_record_writer.close()
        os.system(f"hadoop fs -put {tmp_path} {hdfs_path}")
        os.system(f"rm -rf {tmp_path}")
    except "end of file":
        return None

if __name__ == "__main__":
     main(sys.argv)
