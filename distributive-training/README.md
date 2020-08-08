
# Machine Learning in Big Data Engine
Hadoop is capable of processing big data via MapReduce YARN framework in commodity machine clusters.

In the profession of machine learning, when the data is too large, traditional data-processing may become unrealistic thus it requires the effort of big data framework.

## Keyword:
MapReduce, Hadoop, Hadoop Streaming, HDFS, YARN, Machine Learning, Deep Learning, Anaconda, Jupyter Lab, Keras, Tensorflow, Distributive Training
<!-- Apache Spark -->

## Motivation:
- The training data feeding to the Deep Neural Network (DNN) may be too big to be handled by python science tooling stack
- The data preprocessing like feature engineering, categorical encoding, missing value imputation may not be scalable in a regular single machine.

## Summary
- This project is trying to stand at the standpoint of a machine learning developer who wants to utilize Big data framework to ease their daily work
- We will use Hadoop Streaming utility to perform training data preprocessing in Hadoop MapReduce
  - We will use python scripts in Hadoop Streaming as python is the major scripting language for machine learning which has thorough data science stack support
  - Categorical data encoding
  - Data scaling
  - Missing Data imputation
  - Store Data as TFRecords files via Tensorflow TFRecordWriter
- Use Keras over Tensorflow and HDFS to train our network

## Prerequisites
- macOS Catalina as the development machine
- Homebrew
- Hadoop is setup with `Java 8` as `JAVA_HOME` and `${HADOOP_HOME}` in env variables
  - e.g. `export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_121.jdk/Contents/Home`
  - e.g. `export HADOOP_HOME=/usr/local/Cellar/hadoop/3.3.0/libexec`

## Data preprocessing with Hadoop Streaming
### Install required packages
```bash
# Upgrade python to python3
brew upgrade python
brew link python
# intall tensorflow dependency
pip3 install tensorflow

```

### Data preprocessing steps

Screenshots

## Deep Neural Network Training

## Install required packages for running Deep Neural Network
```bash
brew install bash
# Create a conda env
conda create --name big_data_machine_learning python=3.7 --channel conda-forge
conda activate big_data_machine_learning

# Install all packages in conda
conda install -c conda-forge jupyterlab nodejs pandas matplotlib seaborn numpy scipy scikit-learn tensorflow

### Configure Tensorflow
Refer to the [tutorial](https://github.com/tensorflow/examples/blob/master/community/en/docs/deploy/hadoop.md)
```bash
bash
# run the script in bash-5.0$ 
source ${HADOOP_HOME}/libexec/hadoop-config.sh
export CLASSPATH=$(${HADOOP_HOME}/bin/hadoop classpath --glob):${CLASSPATH}
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${JAVA_HOME}/jre/lib/server

### Start Jupyter Lab

```bash
conda activate big_data_machine_learning
# Assume you are in the git repo root
cd ./jupyter-notebook
jupyter lab
# Wait until the default browser opens Jupyter Lab at http://localhost:8888/lab or http://localhost:8889/lab
# Spark Master UI is running at http://localhost:8080/
```


## Main Steps

### Normalization data into [0, 1]
```pig
grunt> loaded_data = LOAD 'hdfs://localhost:9000/tmp/mock.csv' USING PigStorage(',');
```

### Load Chunk Data from HDFS into Tensorflow


# What's Next
* In addition to the solution, Tensorflow supports [distributive training](https://www.tensorflow.org/guide/distributed_training).
* We could leverage the feature and install Tensorflow module in every node of our Hadoop cluster, exposing service for tensorflow master node. It will scale the training job horizontally just like data preprocessing in Hadoop and support node failure recovery.
* [Amazon Elastic MapReduce over Hadoop (Amazon EMR)](https://aws.amazon.com/about-aws/whats-new/2018/09/support-for-tensorflow-s3-select-with-spark-on-amazon-emr-release-517/) enables the deployment of the solution over AWS.
* [Hopsworks](https://github.com/logicalclocks/hopsworks) also brings the integration between Big Data and Machine Learning frameworks which simplifies scaling data-intensive AI training, over both On-Premises and Cloud.

# Reference:

### TMP
- https://www.slideshare.net/ssuser72f42a/scaling-deep-learning-on-hadoop-at-linkedin
- https://engineering.linkedin.com/blog/2018/09/open-sourcing-tony--native-support-of-tensorflow-on-hadoop
- https://www.tensorflow.org/guide/distributed_training


### Source Data
- https://www.kaggle.com/sdolezel/black-friday
- Hadoop Streaming
  - https://hadoop.apache.org/docs/r3.3.0/hadoop-streaming/HadoopStreaming.html
  - https://nancyyanyu.github.io/posts/f53c188b/


### Hadoop streaming with Python
- Hadoop Streaming: https://hadoop.apache.org/docs/current/hadoop-streaming/HadoopStreaming.html
- Running Hadoop MapReduce with Python: https://www.michael-noll.com/tutorials/writing-an-hadoop-mapreduce-program-in-python/

### HDFS with Tensorflow
- https://stackoverflow.com/questions/54381036/which-is-better-when-reading-from-remote-hosts-like-hdfs-tfrecorddatasetnum-pa
- https://stackoverflow.com/questions/41402332/tensorflow-create-a-tfrecords-file-from-csv
- https://partners-intl.aliyun.com/help/doc-detail/53928.htm
- https://stackoverflow.com/questions/26606128/how-to-save-a-file-in-hadoop-with-python
- https://blog.csdn.net/cdj0311/article/details/105991138
- https://stackoverflow.com/questions/48698286/tensorflow-dataset-api-with-hdfs/48715720
- https://github.com/tensorflow/examples/blob/master/community/en/docs/deploy/hadoop.md
- https://medium.com/@moritzkrger/speeding-up-keras-with-tfrecord-datasets-5464f9836c36

### Amazon Elastic MapReduce over Hadoop (Amazon EMR) with S3/Spark/Tensorflow
- https://aws.amazon.com/about-aws/whats-new/2018/09/support-for-tensorflow-s3-select-with-spark-on-amazon-emr-release-517/




