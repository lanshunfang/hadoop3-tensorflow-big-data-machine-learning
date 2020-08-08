#!/bin/bash
# export HADOOP_HOME=/usr/local/Cellar/hadoop/3.3.0/libexec
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR
cd ..

# JAVA_HOME_8 = /Library/Java/JavaVirtualMachines/jdk1.8.0_121.jdk/Contents/Home

export JAVA_HOME=$JAVA_HOME_8 
export PATH=${JAVA_HOME}/bin:$PATH 

# Start all Hadoop services
start-all.sh
jps

echo "### Categorical Data encoding"

echo "#### Summerize all categorical values for each column"

# Test script
cat <<-EOF | python3 mappers/categorical-stat-0-mapper.py
1000004,P00184942,M,46-50,7,B,2,1,1,8,17,19215
1000004,P00184942,M,55+,7,B,4+,1,1,8,17,19215

EOF

# Test script
TAB="$(printf '\t')"
cat <<-EOF | python3 reducers/categorical-stat-0-reducer.py
0__A${TAB}0
0__A${TAB}0
0__B${TAB}0
1__P00001${TAB}1

EOF

output=output-0
hadoop fs -rm -r /machine-learning-final/${output}
$HADOOP_HOME/bin/mapred streaming \
    -files ./mappers/categorical-stat-0-mapper.py,./reducers/categorical-stat-0-reducer.py \
    -input "/machine-learning-final/train.csv" \
    -output /machine-learning-final/${output} \
    -mapper "categorical-stat-0-mapper.py" \
    -reducer "categorical-stat-0-reducer.py"


hadoop fs -head "/machine-learning-final/${output}/part-00000"
rm column_encoder_definition.txt
hadoop fs -get "/machine-learning-final/${output}/part-00000" column_encoder_definition.txt

echo "#### Encode category with number representation (Ordinal/Integer Encoder)"

cat <<-EOF | python3 ./mappers/categorical-stat-1-mapper.py
1000004,P00184942,M,46-50,7,B,2,1,1,8,17,19215
1000004,P00184942,M,55+,7,B,4+,1,1,8,17,19215

EOF

output=output-1
hadoop fs -rm -r /machine-learning-final/${output}
$HADOOP_HOME/bin/mapred streaming \
    -files hdfs://localhost:9000/machine-learning-final/output-0/part-00000#column_encoder_definition.txt,./mappers/categorical-stat-1-mapper.py \
    -input "/machine-learning-final/train.csv"  \
    -output "/machine-learning-final/${output}" \
    -mapper "categorical-stat-1-mapper.py"

#rm column_encoder_definition.txt
hadoop fs -head "/machine-learning-final/${output}/part-00000"
hadoop fs -get /machine-learning-final/${output}/part-00000 ./target/hadoop_category_encoded.csv

echo "### Scale data into [0,1]"

# Test  data
cat <<-EOF | python3 ./mappers/identity-mapper-reducer.py
0,1017,0,0,2,0,2,0,0,2,12,11769

EOF

cat <<-EOF | python3  ./reducers/min-max-scale-reducer.py
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

EOF

echo "#### Summarize min/max values per each column"
output=output-2
hadoop fs -rm -r /machine-learning-final/${output}
$HADOOP_HOME/bin/mapred streaming \
    -files ./mappers/identity-mapper-reducer.py,./reducers/min-max-scale-reducer.py \
    -input "/machine-learning-final/output-1/part-00000"  \
    -output "/machine-learning-final/${output}" \
    -mapper "identity-mapper-reducer.py" \
    -reducer "min-max-scale-reducer.py"

hadoop fs -head "/machine-learning-final/${output}/part-00000"
rm ./min_max.json
hadoop fs -get /machine-learning-final/${output}/part-00000 ./min_max.json

echo "#### Perform scaling according to the min/max values"
cat <<-EOF | python3  ./mappers/min-max-scale-mapper.py
0,1679,0,0,2,0,2,0,18,,0,7887	
0,1735,0,0,2,0,2,0,13,4,0,10872	
0,1745,0,0,2,0,2,0,0,8,8,19219

EOF

output=output-3
hadoop fs -rm -r /machine-learning-final/${output}
$HADOOP_HOME/bin/mapred streaming \
    -files hdfs://localhost:9000/machine-learning-final/output-2/part-00000#min_max.json,./mappers/min-max-scale-mapper.py \
    -input "/machine-learning-final/output-1/part-00000"  \
    -output "/machine-learning-final/${output}" \
    -mapper "min-max-scale-mapper.py" 

hadoop fs -head "/machine-learning-final/${output}/part-00000"


echo "### Impute missing data with mean"

echo "#### Summarize mean values for each column"

cat  <<- EOF  | python ./reducers/missing-data-impute-reducer.py 
0.0,0.0,0.0,0.0,0.1,0.0,0.5,0.0,0.6842105263157895,0.25,0.8,0.5699611674808969	
0.0,0.012947658402203856,0.0,0.0,0.1,0.0,0.5,0.0,0.6842105263157895,0.25,0.2,0.5697523904964716	
0.0,0.06859504132231405,0.0,0.0,0.1,0.0,0.5,0.0,0.0,0.125,1.0,0.6437011983798906	
0.0,0.13911845730027547,0.0,0.0,0.1,0.0,0.5,0.0,0.9473684210526315,1.0625,0.0,0.414965134243601	
0.0,0.14022038567493114,0.0,0.0,0.1,0.0,0.5,0.0,0.7368421052631579,0.5,0.0,0.11896112572550002

EOF 

output=output-4
hadoop fs -rm -r /machine-learning-final/${output}
$HADOOP_HOME/bin/mapred streaming \
    -files ./mappers/identity-mapper-reducer.py,./reducers/missing-data-impute-reducer.py \
    -input "/machine-learning-final/output-3/part-00000"  \
    -output "/machine-learning-final/${output}" \
    -mapper "identity-mapper-reducer.py" \
    -reducer "missing-data-impute-reducer.py"

hadoop fs -head "/machine-learning-final/${output}/part-00000"
rm ./means.json
hadoop fs -get /machine-learning-final/${output}/part-00000 ./means.json

echo "#### Impute missing data with mean value for each column"

cat  <<- EOF  | python ./mappers/missing-data-impute-mapper.py
,,0.18512396694214875,0.0,0.0,0.1,0.0,0.5,0.0,0.6842105263157895,,0.0,0.34949267192784667	
0.0,0.19889807162534434,0.0,0.0,0.1,0.0,0.5,0.0,0.6842105263157895,0.25,0.2,0.44143805586872104	
0.0,,0.0,,,0.0,0.5,,,0.875,0.0,	
0.0,0.22947658402203858,0.0,0.0,0.1,0.0,0.5,0.0,0.5789473684210527,0.25,0.9333333333333333,0.5362228067977786	
0.0,0.23471074380165288,0.0,0.0,0.1,0.0,0.5,0.0,0.15789473684210525,,0.0,0.05937617437053739	
0.0,0.2581267217630854,0.0,0.0,0.1,0.0,0.5,0.0,0.7368421052631579,0.5,1.0,0.11537016159338595	
0.0,0.2801652892561983,0.0,0.0,0.1,0.0,0.5,0.0,0.0,0.125,0.8,0.49141926594012275	
0.0,0.28292011019283747,0.0,0.0,0.1,0.0,0.5,0.0,0.9473684210526315,,0.0,0.3379681823875736

EOF 

output=output-5
hadoop fs -rm -r /machine-learning-final/${output}
$HADOOP_HOME/bin/mapred streaming \
    -files hdfs://localhost:9000/machine-learning-final/output-4/part-00000#means.json,./mappers/missing-data-impute-mapper.py \
    -input "/machine-learning-final/output-3/part-00000"  \
    -output "/machine-learning-final/${output}" \
    -mapper "missing-data-impute-mapper.py" 

hadoop fs -head "/machine-learning-final/${output}/part-00000"
rm ./target/imputed.csv
hadoop fs -get /machine-learning-final/${output}/part-00000 ./target/imputed.csv
echo 'User_ID,Product_ID,Gender,Age,Occupation,City_Category,Stay_In_Current_City_Years,Marital_Status,Product_Category_1,Product_Category_2,Product_Category_3,Purchase' > ./target/training_final.csv
cat ./target/imputed.csv >> ./target/training_final.csv
head ./target/training_final.csv

echo "### Save CSV data into Tensorflow TfRecords"

cat  <<- EOF  | python ./reducers/tf-records-reducer.py
0.0,0.0,0.0,0.0,0.1,0.0,0.5,0.0,0.6842105263157895,0.25,0.8,0.5699611674808969	
0.0,0.012947658402203856,0.0,0.0,0.1,0.0,0.5,0.0,0.6842105263157895,0.25,0.2,0.5697523904964716	
0.0,0.06859504132231405,0.0,0.0,0.1,0.0,0.5,0.0,0.0,0.125,1.0,0.6437011983798906	

EOF

output=output-final
hadoop fs -rm -r /machine-learning-final/${output}
$HADOOP_HOME/bin/mapred streaming \
    -files ./mappers/identity-mapper-reducer.py,./reducers/tf-records-reducer.py \
    -input "/machine-learning-final/output-5/part-00000"  \
    -output "/machine-learning-final/${output}" \
    -mapper "python3 identity-mapper-reducer.py" \
    -reducer "python3 tf-records-reducer.py"

hadoop fs -du -s -h /machine-learning-final/tfrecords
