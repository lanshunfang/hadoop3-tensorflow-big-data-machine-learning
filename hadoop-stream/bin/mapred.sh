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
<<<<<<< HEAD
1000004,P00184942,M,46-50,7,B,2,1,1,8,17,19215
=======
1000001,P00069042,F,0-17,10,A,2,0,3,,,8370 
>>>>>>> 1223497cfb8ccff914d474941f2f1a1c7cb9f24c

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
hadoop fs -get "/machine-learning-final/output-0/part-00000"
rm column_encoder_definition.txt
mv part-00000 column_encoder_definition.txt
echo "### Encode category with number representation"
# /machine-learning-final/output/part-r-00000

python ./mappers/categorical-stat-1-mapper.py
'''
    1000004,P00184942,M,46-50,7,B,2,1,1,8,17,19215
'''

hadoop fs -rm -r /machine-learning-final/output-1
$HADOOP_HOME/bin/mapred streaming \
    -files hdfs://localhost:9000/machine-learning-final/output-0/part-00000#column_encoder_definition.txt,./mappers/categorical-stat-1-mapper.py \
    -input "/machine-learning-final/train.csv"  \
    -output "/machine-learning-final/output-1" \
    -mapper "categorical-stat-1-mapper.py"

rm column_encoder_definition.txt
hadoop fs -head "/machine-learning-final/output-1/part-00000"
hadoop fs -getmerge /machine-learning-final/output-1/part-00000 ./target/hadoop_encoded.csv
