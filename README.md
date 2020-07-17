# Machine Learning in Big Data Engine - Apache Spark over Hadoop YARN

## Why I choose Spark as the Big Data platform for Machine Learning?

Apache Spark is a distributive computation engine firstly built upon Hadoop MapReduce and aims to improve performance and ease-of-use on processing big data. Spark takes a considerable market share in companies (https://spark.apache.org/powered-by.html) like Amazon, IBM, Intel, TripAdvisor, eBay, etc. It natively embraces Python (pyspark) which is the major programming language in Machine Learning due to its comprehensive stack of tooling in Data Science and its simplicity. 

As a data science student, it may be of great value to master the knowledge of Spark, as well as integration  between main stream Machine Learning framework and Spark while working on the final project.

I switched my big data framework in my final project from Hadoop to Spark for the benefits listed.  

## Keyword:
Apache Spark, HDFS, Hadoop YARN, Machine Learning, Deep Learning, Anaconda, Jupyter Lab, Keres, Tensorflow, Parallel Computation

## Motivation:
- The training data feeding to the Deep Neural Network (DNN) may be very big
- Deep Neural Network (DNN) hyperparameter tuning and training may cost a lot of time, ranging from hours to days.
- The machine doing the tuning and training work may suffer from hardware failure.
- The native parallel computation, fault tolerance of BigData framework like Spark may come to ease the problems listed.

## Summary

- This project is trying to stand at the stand point of a machine learning developer who want to utilize Big data framework to ease their daily work
- We will use Jupyter Lab (Lab version of Jupyter Notebook) managed by Anaconda to develop and test the Spark script interactively
- We will use Keras over Tensorflow 2 to train a neural network in Spark worker nodes.

## Steps

### Presequites
- macOS Catalina as the development machine
- Anaconda is already installed
- Homebrew, Java8, git is installed

### Install required packages

```bash
# Create a conda env
conda create --name spark python=3.7 --channel conda-forge
conda activate spark

# Install all packages in conda
conda install -c conda-forge jupyterlab nodejs pandas matplotlib seaborn numpy scipy scikit-learn tensorflow pyspark

# Install Spark
brew install scala apache-spark

# Add the following to ~/.bash_profile
export SPARK_HOME=/usr/local/Cellar/apache-spark/3.0.0/libexec/
```

### Start Spark and Jupyter Lab

```bash
# Assume your proejct is in ~/dev/spark-jupyter
conda activate spark
cd ~/dev/spark-jupyter
$SPARK_HOME/sbin/start-all.sh & 
jupyter lab
```

>>> sc.master
'local[*]'
>>> sc.version
'3.0.0'
>>> 

open http://localhost:8080/


Reference:
https://docs.anaconda.com/anaconda-scale/howto/spark-configuration/#scale-spark-config-cloudera
https://medium.com/beeranddiapers/installing-apache-spark-on-mac-os-ce416007d79f
https://www.xplenty.com/blog/apache-spark-vs-hadoop-mapreduce/


