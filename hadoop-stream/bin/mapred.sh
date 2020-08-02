#!/bin/bash
# export HADOOP_HOME=/usr/local/Cellar/hadoop/3.3.0/libexec
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR
cd ..

export JAVA_HOME=$JAVA_HOME_8 
export PATH=${JAVA_HOME}/bin:$PATH 
start-all.sh
#mr-jobhistory-daemon.sh start historyserver
jps
# kill `jps | cut -d " " -f 1`


echo "## Analize Categorical Data"
#rm ./target/distributive-files.tar.gz
rm ./target/distributive-files.tar
#tar zcf ./target/distributive-files.tar.gz ./mappers ./reducers
tar cf ./target/distributive-files.tar ./mappers/* ./reducers/*

echo "### Uniq category values for each column"
hadoop fs -rm -r /machine-learning-final/output-0
# hadoop fs -rm -r /machine-learning-final/archives
# hadoop fs -mkdir -p /machine-learning-final/archives
# hadoop fs -put ./target/distributive-files.tar /machine-learning-final/archives
#     -archives hdfs://localhost:9000/machine-learning-final/archives/distributive-files.tar \
$HADOOP_HOME/bin/mapred streaming \
    -files ./mappers/categorical-stat-0-mapper.py,./reducers/categorical-stat-0-reducer.py \
    -D mapreduce.job.reduces=1 \
    -input "/machine-learning-final/train.csv" \
    -output "/machine-learning-final/output-0" \
    -mapper "categorical-stat-0-mapper.py" \
    -reducer "categorical-stat-0-reducer.py" \
    -combiner "categorical-stat-0-reducer.py" 

hadoop fs -head "/machine-learning-final/output-0/part-00000"
echo "### Encode category with number representation"
# /machine-learning-final/output/part-r-00000

hadoop fs -rm -r /machine-learning-final/output-1
$HADOOP_HOME/bin/mapred streaming \
    -D mapred.reduce.tasks=1 \
    -input /machine-learning-final/output-0/part-r-* \
    -output /machine-learning-final/output-1 \
    -mapper ./mappers/categorical-stat-1-mapper.py \
    -reducer ./mappers/categorical-stat-1-reducer.py \
    -combiner ./mappers/categorical-stat-1-reducer.py \
    -archives ./target/distributive-files.tar.gz

hadoop fs -getmerge /machine-learning-final/output-1/part-r-* ./cache/column-cat-code.txt
rm ./target/distributive-files.tar.gz
tar zcf ./target/distributive-files.tar.gz ./mappers ./reducers ./cache
