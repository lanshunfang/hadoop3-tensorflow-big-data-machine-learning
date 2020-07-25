hadoop fs -mkdir /machine-learning-final
hadoop fs -rm /machine-learning-final/normalization.py
hadoop fs -put ./pig-python-udf/normalization.py /machine-learning-final