
# Machine Learning in Big Data Engine

Hadoop is capable of processing big data via MapReduce YARN framework in cost effective machine clusters.

For machine learning, when the data is becaming too large, data-processing may become complicated and require the effort of big data framework.

<!-- Apache Spark is a distributive computation engine firstly built upon Hadoop MapReduce and aims to improve performance and ease-of-use on processing big data. Spark takes a considerable market share in companies (https://spark.apache.org/powered-by.html) like Amazon, IBM, Intel, TripAdvisor, eBay, etc. It natively embraces Python (Pyspark) which is the major programming language in Machine Learning due to its comprehensive stack of tooling in Data Science and its simplicity. Anaconda, the eminent scientific tooling manager already declares its way to work with Spark in Jupyter Notebook. -->

<!-- I will be leveraging the advantages of both two framework in the final project. -->

## Keyword:
MapReduce, Hadoop, HDFS, YARN, Pig,  Machine Learning, Deep Learning, Anaconda, Jupyter Lab, Keras, Tensorflow, Parallel Computation
<!-- Apache Spark -->

## Motivation:
- The training data feeding to the Deep Neural Network (DNN) may be very big
- The data preprocessing like data transformation, missing value imputation may not be possible in regular machines.
<!-- - Deep Neural Network (DNN) hyperparameter tuning and training may cost a lot of time, ranging from hours to days.
- The machine doing the tuning and training work may suffer from hardware failure.
- The native parallel computation, fault tolerance of BigData framework like Spark may come to ease the problems listed. -->

## Summary

- This project is trying to stand at the standpoint of a machine learning developer who wants to utilize Big data framework to ease their daily work
- We will use Apache Pig to drive a Hadoop MapReduce job to perform data preprocessing, like imputing missing values, transforming string values to numeric representations and scaling data with normalization and standardization
- We will use TonY, the open source project that integrate Hadoop to Tensorflow for distributed training.
<!-- - We will use Keras over Google Tensorflow 2 to train a neural network in the big data distributed nodes via Tensorflow distriubted worker training -->

## Steps

### Presequites
- macOS Catalina as the development machine
- Anaconda is already installed
- Homebrew, Java8, git is installed
- A global variable `JAVA_HOME_8` is pointing to Java8
- Apache Hadoop and Apache Pig is setup

### Install required packages

```bash
# Create a conda env
conda create --name big_data_machine_learning python=3.7 --channel conda-forge
conda activate big_data_machine_learning

# Install all packages in conda
conda install -c conda-forge jupyterlab nodejs pandas matplotlib seaborn numpy scipy scikit-learn tensorflow # pyspark

# # Install Spark
# brew install scala apache-spark

# # Add the following to ~/.bash_profile
# export SPARK_HOME=/usr/local/Cellar/apache-spark/3.0.0/libexec/
```

### Start Jupyter Lab

```bash
# Assume your proejct is in ~/dev/hadoop/machine-learning
conda activate big_data_machine_learning
cd ~/dev/hadoop/machine-learning
# $SPARK_HOME/sbin/start-all.sh & 
jupyter lab
# Wait until the default browser opens Jupyter Lab at http://localhost:8888/lab or http://localhost:8889/lab
# Spark Master UI is running at http://localhost:8080/
```

### Normalization data into [0, 1]
```pig
grunt> loaded_data = LOAD 'hdfs://localhost:9000/tmp/mock.csv' USING PigStorage(',');
```



## Reference:
- https://www.slideshare.net/ssuser72f42a/scaling-deep-learning-on-hadoop-at-linkedin
- https://engineering.linkedin.com/blog/2018/09/open-sourcing-tony--native-support-of-tensorflow-on-hadoop
- https://www.tensorflow.org/tutorials/distribute/multi_worker_with_keras
- https://www.tensorflow.org/guide/distributed_training
- https://blog.tensorflow.org/2020/01/hyperparameter-tuning-with-keras-tuner.html
- https://stackoverflow.com/questions/45585909/how-to-do-normalization-for-each-feature-using-hadoop-pig?newreg=07eb455db44c4d8586cc8c8beed906bc
- https://pig.apache.org/docs/r0.17.0/udf.html#python-udfs



