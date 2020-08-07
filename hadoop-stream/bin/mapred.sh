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
output=output-0
hadoop fs -rm -r /machine-learning-final/${output}
$HADOOP_HOME/bin/mapred streaming \
    -files ./mappers/categorical-stat-0-mapper.py,./reducers/categorical-stat-0-reducer.py \
    -input "/machine-learning-final/train.csv" \
    -output /machine-learning-final/${output} \
    -mapper "categorical-stat-0-mapper.py" \
    -reducer "categorical-stat-0-reducer.py"

hadoop fs -head "/machine-learning-final/${output}/part-00000"
hadoop fs -get "/machine-learning-final/${output}/part-00000"
rm column_encoder_definition.txt
mv part-00000 column_encoder_definition.txt
echo "### Encode category with number representation"
# /machine-learning-final/output/part-r-00000

python ./mappers/categorical-stat-1-mapper.py
# '''
#   1000004,P00184942,M,46-50,7,B,2,1,1,8,17,19215
#   1000004,P00184942,M,55+,7,B,4+,1,1,8,17,19215
# '''

output=output-1
hadoop fs -rm -r /machine-learning-final/${output}
$HADOOP_HOME/bin/mapred streaming \
    -files hdfs://localhost:9000/machine-learning-final/output-0/part-00000#column_encoder_definition.txt,./mappers/categorical-stat-1-mapper.py \
    -input "/machine-learning-final/train.csv"  \
    -output "/machine-learning-final/${output}" \
    -mapper "categorical-stat-1-mapper.py"

#rm column_encoder_definition.txt
hadoop fs -head "/machine-learning-final/${output}/part-00000"
hadoop fs -getmerge /machine-learning-final/${output}/part-00000 ./target/hadoop_category_encoded.csv

python ./mappers/identity-mapper-reducer.py
# 0,1017,0,0,2,0,2,0,0,2,12,11769

python ./reducers/min-max-scale-reducer.py
# 0,1017,0,0,2,0,2,0,0,2,12,11769	
# 0,1027,0,0,2,0,2,0,18,,0,8094	
# 0,1088,0,0,2,0,2,0,15,15,0,8839	
# 0,1327,0,0,2,0,2,0,18,,0,7882	
# 0,1559,0,0,2,0,2,0,18,,0,10003	
# 0,1678,0,0,2,0,2,0,18,,0,9946	
# 0,1679,0,0,2,0,2,0,18,,0,7887	
# 0,1735,0,0,2,0,2,0,13,4,0,10872	
# 0,1745,0,0,2,0,2,0,0,8,8,19219	
# 0,1996,0,0,2,0,2,0,13,4,0,11039	

output=output-2
hadoop fs -rm -r /machine-learning-final/${output}
$HADOOP_HOME/bin/mapred streaming \
    -files ./mappers/identity-mapper-reducer.py,./reducers/min-max-scale-reducer.py \
    -input "/machine-learning-final/${output}/part-00000"  \
    -output "/machine-learning-final/${output}" \
    -mapper "identity-mapper-reducer.py" \
    -reducer "min-max-scale-reducer.py"

hadoop fs -head "/machine-learning-final/${output}/part-00000"
hadoop fs -get /machine-learning-final/${output}/part-00000 ./min_max.json

python ./mappers/min-max-scale-1-mapper.py
# 0,1679,0,0,2,0,2,0,18,,0,7887	
# 0,1735,0,0,2,0,2,0,13,4,0,10872	
# 0,1745,0,0,2,0,2,0,0,8,8,19219
cat target/hadoop_category_encoded.csv | python ./mappers/min-max-scale-1-mapper.py

python ./mappers/identity-mapper-reducer.py
# 0.0,0.4807162534435262,0.0,0.0,0.1,0.0,0.5,0.0,0.0,0.5,0.5333333333333333,0.8024969727337259
head target/hadoop_category_encoded.csv | python ./mappers/identity-mapper-reducer.py 

output=output-3
hadoop fs -rm -r /machine-learning-final/${output}
$HADOOP_HOME/bin/mapred streaming \
    -files hdfs://localhost:9000/machine-learning-final/output-2/part-00000#min_max.json,./mappers/min-max-scale-1-mapper.py \
    -input "/machine-learning-final/output-1/part-00000"  \
    -output "/machine-learning-final/${output}" \
    -mapper "min-max-scale-1-mapper.py" 

hadoop fs -head "/machine-learning-final/${output}/part-00000"
hadoop fs -get /machine-learning-final/${output}/part-00000 ./target/scaled.csv
echo 'User_ID,Product_ID,Gender,Age,Occupation,City_Category,Stay_In_Current_City_Years,Marital_Status,Product_Category_1,Product_Category_2,Product_Category_3,Purchase' > ./target/training_final.csv
cat ./target/scaled.csv >> ./target/training_final.csv
head ./target/training_final.csv
