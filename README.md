
# Machine Learning in Big Data Engine - Apache Spark over Hadoop YARN

Different big data frameworks could solve different problems. But for a project, we could leverage all of their benefits. 

Hadoop is capable of processing big data via MapReduce YARN framework without using a lot of RAM in cost effective machine clusters. It offers JAVA API for programmers to work.

Apache Spark is a distributive computation engine firstly built upon Hadoop MapReduce and aims to improve performance and ease-of-use on processing big data. Spark takes a considerable market share in companies (https://spark.apache.org/powered-by.html) like Amazon, IBM, Intel, TripAdvisor, eBay, etc. It natively embraces Python (Pyspark) which is the major programming language in Machine Learning due to its comprehensive stack of tooling in Data Science and its simplicity.

I will be leveraging the advantages of both two framework in the final project.

## Keyword:
MapReduce, Hadoop, HDFS, YARN, Apache Spark, Machine Learning, Deep Learning, Anaconda, Jupyter Lab, Keras, Tensorflow, Parallel Computation

## Motivation:
- The training data feeding to the Deep Neural Network (DNN) may be very big
- The data preprocessing like data transformation, missing value imputation may not be possible in regular machines.
- Deep Neural Network (DNN) hyperparameter tuning and training may cost a lot of time, ranging from hours to days.
- The machine doing the tuning and training work may suffer from hardware failure.
- The native parallel computation, fault tolerance of BigData framework like Spark may come to ease the problems listed.

## Summary

- This project is trying to stand at the standpoint of a machine learning developer who wants to utilize Big data framework to ease their daily work
- We will use Hadoop MapReduce to perform data preprocessing, imputing missing values and transforming string values to numeric representations
- We will use Jupyter Lab (Lab version of Jupyter Notebook) managed by Anaconda to develop and test the Spark script interactively
- We will use Keras over Tensorflow 2 to train a neural network in Spark worker nodes after tuning its hypyerparameters (also via the worker nodes).

## Steps

### Presequites
- macOS Catalina as the development machine
- Anaconda is already installed
- Homebrew, Java8, git is installed
- A global variable `JAVA_HOME_8` is pointing to Java8

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
# Wait until the default browser opens Jupyter Lab at http://localhost:8888/lab or http://localhost:8889/lab
# Spark Master UI is running at http://localhost:8080/
```

### Init a new Jupyter Noteboork in Jupyter Lab and link it to Spark

open http://localhost:8080/


## Reference:
- https://docs.anaconda.com/anaconda-scale/howto/spark-configuration/#scale-spark-config-cloudera
- https://medium.com/beeranddiapers/installing-apache-spark-on-mac-os-ce416007d79f
- https://www.xplenty.com/blog/apache-spark-vs-hadoop-mapreduce/


