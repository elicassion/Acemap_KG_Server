# Acemap_KG_Server

## Component
Current architecture is based on [Apache-Jena](http://jena.apache.org/).

## Environment
Ubuntu 16.04
JDK 1.8
Git

## Setup
### JDK 1.8
#### JDK Install
    sudo add-apt-repository ppa:webupd8team/java
    sudo apt-get update
    sudo apt-get install oracle-java8-installer

#### JDK Check
    java -version

### Maven
#### Maven Download
[Apache Maven Download](http://maven.apache.org/download.cgi) Either tar.gz or zip archive is ok.
#### Maven Install
[Apache Maven Install](http://maven.apache.org/install.html)
#### Maven Check
    mvn -v

### Git
    sudo apt-get install git

### Jena
Here we use Maven to install [all artifacts of Jena](http://jena.apache.org/download/maven.html).

Change directory into your target installation directory.

    cd /your/target/installation/directory
Clone the Jena project. (Command on the official website has a little mistake.)

    **git clone** git://git.apache.org/jena.git
Install

    cd jena
    mvn clean install
    
Then open a pack of chips and wait for the finish of installation. It takes about 50min on my PC. Some tests are performed along with the installation. Wish you guys good luck.

## The First Hands-on Attempt
**TBD**
