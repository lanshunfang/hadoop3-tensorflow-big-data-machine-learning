hadoop fs -mkdir -p /machine-learning-final/output
hadoop fs -put /Users/lanshunfang/Downloads/_kaggle_data/kaggle-black-friday/train.csv /machine-learning-final
hadoop fs -head /machine-learning-final/train.csv