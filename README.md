# Acemap_KG_Server

## Component
Current architecture is based on [Apache-Jena](http://jena.apache.org/).

## Environment
Ubuntu 16.04
JDK 1.8
Git

## Directory Explanation
deploy.sh -> script to check the environment, download [Apache-Jena](http://jena.apache.org/) and [Apache-Jena-Fuseki](http://jena.apache.org/documentation/fuseki2/index.html) and unzip them.

data/[database name] includes .ttl files, ready for being converted to TDB files.
We already put an example.ttl in data/db.
You can also create ANY directory as your base storing .ttl files on your machine.

build_db.sh -d \[directory of your .ttl files\] -n \[database name\]-> build your TDB from .ttl files in the directory.
-d is your directory containing .ttl files. It will be 'data/db' by default.
-n is your name for this database. It will be used in SPARQL queries. 'db' by default.
Database built form this will be put at tdb/\[database name\].

run_service.sh run the Fuseki server on your machine. The root of APIs is http://localhost:3030 by default. 
Specifically, APIs of your database are http://localhost:3030/\[database name\]/[query/update/data]

All is waiting for use!

## Setup
### JDK 1.8
#### JDK Install
    sudo add-apt-repository ppa:webupd8team/java
    sudo apt-get update
    sudo apt-get install oracle-java8-installer

#### JDK Check
    java -version

### Deploy with Script
    Run
        bash deploy.sh
    It will download requirements.

## The First Hands-on Attempt
**TBD**
