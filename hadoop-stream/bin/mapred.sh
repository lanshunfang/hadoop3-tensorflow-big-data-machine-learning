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
# '''
# 1000004,P00184942,M,46-50,7,B,2,1,1,8,17,19215
# 1000004,P00184942,M,55+,7,B,4+,1,1,8,17,19215

# '''
python reducers/categorical-stat-0-reducer.py
# '''
# Manual enter \t
# 0__A    0
# 0__A    0
# 0__B    0
# 1__P00001   1

# '''

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
# '''
#   1000004,P00184942,M,46-50,7,B,2,1,1,8,17,19215
#   1000004,P00184942,M,55+,7,B,4+,1,1,8,17,19215
# '''

hadoop fs -rm -r /machine-learning-final/output-1
$HADOOP_HOME/bin/mapred streaming \
    -files hdfs://localhost:9000/machine-learning-final/output-0/part-00000#column_encoder_definition.txt,./mappers/categorical-stat-1-mapper.py \
    -input "/machine-learning-final/train.csv"  \
    -output "/machine-learning-final/output-1" \
    -mapper "categorical-stat-1-mapper.py"

#rm column_encoder_definition.txt
hadoop fs -head "/machine-learning-final/output-1/part-00000"
hadoop fs -getmerge /machine-learning-final/output-1/part-00000 ./target/hadoop_category_encoded.csv

python ./reducers/min-max-scale-reducer.py
0,1017,0,0,2,0,2,0,0,2,12,11769	
0,1027,0,0,2,0,2,0,18,,0,8094	
0,1088,0,0,2,0,2,0,15,15,0,8839	
0,1327,0,0,2,0,2,0,18,,0,7882	
0,1559,0,0,2,0,2,0,18,,0,10003	
0,1678,0,0,2,0,2,0,18,,0,9946	
0,1679,0,0,2,0,2,0,18,,0,7887	
0,1735,0,0,2,0,2,0,13,4,0,10872	
0,1745,0,0,2,0,2,0,0,8,8,19219	
0,1996,0,0,2,0,2,0,13,4,0,11039	

hadoop fs -rm -r /machine-learning-final/output-2
$HADOOP_HOME/bin/mapred streaming \
    -files ./reducers/min-max-scale-reducer.py \
    -input "/machine-learning-final/train.csv"  \
    -output "/machine-learning-final/output-1/part-00000" \
    -reducer "min-max-scale-reducer.py"

hadoop fs -head "/machine-learning-final/output-2/part-00000"

#echo 'User_ID,Product_ID,Gender,Age,Occupation,City_Category,Stay_In_Current_City_Years,Marital_Status,Product_Category_1,Product_Category_2,Product_Category_3,Purchase' > ./target/hadoop_encoded_head.csv
#cat ./target/hadoop_encoded.csv >> ./target/hadoop_encoded_head.csv
#head ./target/hadoop_encoded_head.csv
