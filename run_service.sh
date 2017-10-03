SOURCE="$0"
while [ -h "$SOURCE"  ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /*  ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"


DB_NAME="db"

while getopts ":n:" OPT;do 
    case $OPT in 
        n)
          DB_NAME=$OPTARG 
          ;;
        *)
          echo "Wrong option"
          exit 1
          ;;
    esac
done 

JENA_DIR="apache-jena"
FUSEKI_DIR="apache-jena-fuseki"

echo "# Licensed under the terms of http://www.apache.org/licenses/LICENSE-2.0
## Fuseki Server configuration file.
@prefix fuseki:  <http://jena.apache.org/fuseki#> .
@prefix rdf:     <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:    <http://www.w3.org/2000/01/rdf-schema#> .
@prefix tdb:     <http://jena.hpl.hp.com/2008/tdb#> .
@prefix ja:      <http://jena.hpl.hp.com/2005/11/Assembler#> .
@prefix :        <#> .
[] rdf:type fuseki:Server ;
	fuseki:services (  
	     <#service_${DB_NAME}>
	   ) .  
	# TDB  
[] ja:loadClass \"org.apache.jena.tdb.TDB\" .  
tdb:DatasetTDB  rdfs:subClassOf  ja:RDFDataset .  
tdb:GraphTDB    rdfs:subClassOf  ja:Model .  
  
## ---------------------------------------------------------------  
## Read-only TDB dataset (only read services enabled).  
  
<#service_${DB_NAME}> rdf:type fuseki:Service ;  
    fuseki:name                       \"${DB_NAME}\" ;       # http://host:port/${DB_NAME}
    fuseki:serviceQuery               \"sparql\" ;   # SPARQL query service
    fuseki:serviceQuery               \"query\" ;    # SPARQL query service (alt name)
    fuseki:serviceUpdate              \"update\" ;   # SPARQL update service
    fuseki:serviceUpload              \"upload\" ;   # Non-SPARQL upload service
    fuseki:serviceReadWriteGraphStore \"data\" ;     # SPARQL Graph store protocol (read and write)
    # A separate read-only graph store endpoint:
    fuseki:serviceReadGraphStore      \"get\" ;      # SPARQL Graph store protocol (read only)
    fuseki:dataset                   <#${DB_NAME}> ;
    .  
  
<#${DB_NAME}> rdf:type      tdb:DatasetTDB ;  
    tdb:location \"tdb/${DB_NAME}\" ;  
    # Query timeout on this dataset (1s, 1000 milliseconds)
    ja:context [ ja:cxtName \"arq:queryTimeout\" ;  ja:cxtValue \"1000\" ] ;
    .  " > fuseki-config.ttl
export FUSEKI_HOME="apache-jena-fuseki"
export FUSEKI_BASE="fuseki-run"
# cd ${FUSEKI_DIR}
./$FUSEKI_HOME/fuseki-server --port 9030 --config=fuseki-config.ttl