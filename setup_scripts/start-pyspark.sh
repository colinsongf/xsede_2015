#!/bin/bash
### Adapted from the script provided by 
### Mahidhar Tatineni, San Diego Supercomputer Center June 2015
### which can be found at /share/apps/examples/SPARK/sparkgraphx.


### Environment setup for Hadoop and Spark
module load hadoop
module load spark
export PROJECT_DIR=`pwd`
export PATH=/opt/hadoop/2.6.0/sbin:$PATH
export HADOOP_CONF_DIR=$PROJECT_DIR/mycluster.conf
export WORKDIR=/oasis/scratch/comet/$USER/temp_project

### Workaround to load SLURM env variables when using salloc
source $PROJECT_DIR/slurm-env.sh

myhadoop-configure.sh

### Start HDFS.  Starting YARN isn't necessary since Spark will be running in
### standalone mode on our cluster.
start-dfs.sh

### This is the point in the process where data should be copied into HDFS.
### Copy the data into HDFS
### ex:
hdfs dfs -mkdir -p /user/$USER
hdfs dfs -put /oasis/scratch/comet/milroy/temp_project/xsede15/lustre_debug.out /user/$USER/
hdfs dfs -put /oasis/scratch/comet/milroy/temp_project/xsede15/lustre_timeseries.csv /user/$USER/
hdfs dfs -put /oasis/scratch/comet/milroy/temp_project/xsede15/pivoted.txt /user/$USER/

### Load in the necessary Spark environment variables
source $HADOOP_CONF_DIR/spark/spark-env.sh

### Start the Spark masters and workers.  Do NOT use the start-all.sh provided 
### by Spark, as they do not correctly honor $SPARK_CONF_DIR
myspark start

pyspark --master=spark://$SPARK_MASTER_IP:7077 --conf="spark.driver.maxResultSize=4g"
