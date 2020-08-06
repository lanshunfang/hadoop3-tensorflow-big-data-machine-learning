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
python mappers/categorical-stat-0-mapper.py
'''
1000001,P00069042,F,0-17,10,A,2,0,3,,,8370 

'''
python reducers/categorical-stat-0-reducer.py
'''
Manual enter \t
0__A    0
0__A    0
0__B    0
1__P00001   1

'''

# hadoop fs -rm -r /machine-learning-final/archives
# hadoop fs -mkdir -p /machine-learning-final/archives
# hadoop fs -put ./target/distributive-files.tar /machine-learning-final/archives
#     -archives hdfs://localhost:9000/machine-learning-final/archives/distributive-files.tar \
hadoop fs -rm -r /machine-learning-final/output-0
$HADOOP_HOME/bin/mapred streaming \
    -files ./mappers/categorical-stat-0-mapper.py,./reducers/categorical-stat-0-reducer.py \
    -input "/machine-learning-final/train.csv" \
    -output "/machine-learning-final/output-0" \
    -mapper "categorical-stat-0-mapper.py" \
    -reducer "categorical-stat-0-reducer.py"

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
