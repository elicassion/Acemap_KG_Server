#!/bin/sh
# Get pwd
SOURCE="$0"
while [ -h "$SOURCE"  ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /*  ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"


# Check Util Commands
command -v wget >/dev/null 2>&1 || { 
	echo >&2 "Require wget, installing"; 
	apt-get install wget;
}
command -v md5sum >/dev/null 2>&1 || { 
	echo >&2 "Require md5sum, installing"; 
	apt-get install md5sum;
}

# Check Java Runtime
if [[ $JAVA_HOME ]]; then  
    echo -n >&2 $(java -version)
else  
	echo "Require Java 1.8+"
	exit 1
    for i in $(rpm -qa | grep jdk | grep -v grep)  
	do  
	  echo "Deleting rpm -> "$i  
	  rpm -e --nodeps $i  
	done  
	  
	if [[ ! -z $(rpm -qa | grep jdk | grep -v grep) ]];  
	then   
	  echo "Failed to remove the defult Jdk."  
	else   
	  rpm -ivh jdk-8u111-linux-x64.rpm  
	fi  
	  
	echo "export JAVA_HOME=/usr/java/jdk1.8.0_111  
	export JAVA_BIN=/usr/java/jdk1.8.0_111/bin  
	export PATH=$JAVA_HOME/bin:$PATH  
	export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar  
	export JAVA_HOME JAVA_BIN PATH CLASSPATH" >> /etc/profile
	source /etc/profile
	echo "JDK environment has been successed set in /etc/profile."
fi

# Check Download File MD5
# Param: Filename
function checkMD5(){
	dld=`md5sum ${1} | cut -d " " -f 1`
	ori=`cat ${1}.md5`
	if [[ "${dld}" = "${ori}" ]]; then
		return 0
	else
		return 1
	fi
}



# Define Version
JENA_VERSION="3.4.0"
FUSEKI_VERSION="3.4.0"
echo "Jena version ${JENA_VERSION}"
echo "Fuseki version ${FUSEKI_VERSION}"
JENA_FILE="apache-jena-${JENA_VERSION}.tar.gz"
FUSEKI_FILE="apache-jena-fuseki-${FUSEKI_VERSION}.tar.gz"
FILE_LINK="http://mirrors.tuna.tsinghua.edu.cn/apache/jena/binaries/"
MD5_LINK="https://www.apache.org/dist/jena/binaries/"


function downloadComponent(){
	dltry=1
	while [[ dltry -le 3 ]]; do
		if [[ -f "${1}" ]]; then
			echo "Already downloaded. Checking MD5."
			if [[ ! -f "${1}.md5" ]]; then
				wget "${MD5_LINK}${1}.md5" > /dev/null 2>&1
			fi
			checkMD5 ${1}
			if [ $? ]; then
				echo "Check OK. Skip downloading."
				break
			else
				rm ${1}
			fi
		fi
		wget "${FILE_LINK}${1}"
		if [[ ! -f "${1}.md5" ]]; then
			wget "${MD5_LINK}${1}.md5" > /dev/null 2>&1
		fi
		checkMD5 ${1}
		if [ $? ]; then
			echo "Download successed and check done."
			break
		fi
		dltry=$[${dltry}+1]
		echo "Failed. Try again."
	done
	if [[ dltry = 3 ]]; then
		echo "Download failed. Please check the Internet."
		exit 1
	fi
}

# Download
downloadComponent ${JENA_FILE}
downloadComponent ${FUSEKI_FILE}

# Unzip
echo "Unziping File."
JENA_DIR=apache-jena-${JENA_VERSION}
FUSEKI_DIR=apache-jena-fuseki-${FUSEKI_VERSION}
if [[ -d ${JENA_DIR} ]]; then
	rm -r JENA_DIR > /dev/null 2>&1
fi
if [[ -d ${FUSEKI_DIR} ]]; then
	rm -r FUSEKI_DIR > /dev/null 2>&1
fi
tar -xzvf ${JENA_FILE} > /dev/null 2>&1
tar -xzvf ${FUSEKI_FILE} > /dev/null 2>&1
echo "Unziping done."



# Set
export JENA_HOME=${DIR}/${JENA_DIR}
# source /etc/profile
if [[ $JENA_HOME ]]; then
	echo "Jena environment has been successed set in /etc/profile."
else
	echo "Setting Jena environment failed. Please use sudo deploy.sh"
fi



# Clear
echo "Clearing"
rm ${JENA_FILE}
rm ${JENA_FILE}.md5
rm ${FUSEKI_FILE}
rm ${FUSEKI_FILE}.md5
echo "Clearing done."
echo "All is OK."