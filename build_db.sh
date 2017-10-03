#!/bin/sh

# Get pwd

TTL_DIR="data/db"
DB_NAME="db"

while getopts ":d:n:" OPT;do 
    case $OPT in 
        d)
          TTL_DIR=$OPTARG
          if [[ ! -d TTL_DIR ]]; then
          	echo "${TTL_DIR} dose not exist."
          fi
          ;;
        n)
          DB_NAME=$OPTARG 
          ;;
        *)
          echo "Wrong option"
          exit 1
          ;;
    esac
done 


SOURCE="$0"
while [ -h "$SOURCE"  ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /*  ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"

JENA_DIR="apache-jena"
FUSEKI_DIR="apache-jena-fuseki"

export JENA_HOME=${DIR}/${JENA_DIR}
PATH=$JENA_HOME/bin:$PATH
# source /etc/profile
if [[ $JENA_HOME ]]; then
	echo "Jena environment has been successed set."
else
	echo "Setting Jena environment failed. Please use sudo deploy.sh"
fi

tdbloader2 --loc tdb/${DB_NAME} ${TTL_DIR}/*
echo "Build done."