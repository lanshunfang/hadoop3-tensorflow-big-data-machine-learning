
# WIP: Distributive Machine Learning with Hadoop and Tensorflow
This is a sub-project of `../README.md`
WIP

## Keyword:
MapReduce, Hadoop, HDFS, YARN, Machine Learning, Deep Learning, Anaconda, Jupyter Lab, Keras, Tensorflow, Distributive Training
<!-- Apache Spark -->

## Motivation:
- WIP 

## Summary
- WIP

## Prerequisites
- WIP

## Deep Neural Network Training

WIP

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




