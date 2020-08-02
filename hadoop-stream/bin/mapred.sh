#!/bin/bash
# export HADOOP_HOME=/usr/local/Cellar/hadoop/3.3.0/libexec
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR
cd ..

echo "## Analize Categorical Data"
rm -y ./target/distributive-files.tar.gz
tar zcf ./target/distributive-files.tar.gz ./mappers ./reducers ./target

echo "### Uniq category values for each column"
hadoop fs -rm -r /machine-learning-final/output-0
$HADOOP_HOME/bin/mapred streaming \
    -D mapred.reduce.tasks=1 \
    -input /machine-learning-final/train.csv \
    -output /machine-learning-final/output-0 \
    -mapper ./mappers/categorical-stat-0-mapper.py \
    -reducer ./mappers/categorical-stat-0-reducer.py \
    -combiner ./mappers/categorical-stat-0-reducer.py \
    -archives ./target/distributive-files.tar.gz

echo "### Encode category with number representation"
# /machine-learning-final/output/part-r-00000
hadoop fs -rm -r /machine-learning-final/output-1
$HADOOP_HOME/bin/mapred streaming \
    -D mapred.reduce.tasks=1 \
    -input /machine-learning-final/output/part-r-* \
    -output /machine-learning-final/output-1 \
    -mapper ./mappers/categorical-stat-1-mapper.py \
    -reducer ./mappers/categorical-stat-1-reducer.py \
    -combiner ./mappers/categorical-stat-1-reducer.py \
    -archives ./target/distributive-files.tar.gz

