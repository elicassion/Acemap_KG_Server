from concurrent.futures import ThreadPoolExecutor as Pool
import requests
import urllib
import time
import os
import random

db='test_40000'
server='http://202.120.36.29:9030/'+db+'/query?'
timeout=5

def send_sparql(args):
    n=args['n']
    query=args['query']
    f_c=0
    t_time=0
    for i in range(n):
        try:
            st=time.time()
            r=requests.get(query,timeout=timeout)
            dur=time.time()-st
        except KeyboardInterrupt:
            exit()
        except:
            f_c+=1
            t_time+=timeout
        else:
            t_time+=dur
    #return f_c,t_time,r.text
    return f_c,t_time

testpath='./queries/'
testlist=os.listdir(testpath)
s=[]
for testfile in testlist:
    f=open(testpath+testfile,'r')
    s.append(f.read())
    f.close()

#query={"query":"PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> SELECT ?s WHERE { ?s ?p ?o .}"}
#query={'query':s}
#print(query)
#query=server+urllib.parse.urlencode(query)
#print(query)

num=20
step=1
resultpath='./results/'
filename=resultpath+'results_'+time.asctime().replace(' ','_')+',num='+str(num)+'.csv'
f=open(filename,'w')
f.close()
threads=0
left=0
right=0
stop_thresh=0.5
while True:
    threads=threads+step
    if threads==0 or step==0:
        break
    total=num*threads
    print(threads)
    fcount=0
    sum_dur=0
    tasks=[]
    for i in range(threads):
        r=random.randint(0,len(s)-1)
        query={'query':s[r]}
        query=server+urllib.parse.urlencode(query)
        tasks.append({'n':num,'query':query})
    pool=Pool(max_workers=threads)
    results=pool.map(send_sparql,tasks)
    for item in results:
        fcount+=item[0]
        sum_dur+=item[1]
    miss=fcount/total
    print('Send %d concurrently, Miss Rate: %.3f, Avr Return Time: %.3fms'%
        (threads,miss,sum_dur/total*1000))
    f=open(filename,'a')
    f.write('%d,%.3f,%.3f\n'%(threads,miss,sum_dur/total*1000))
    f.close()
    if miss>=stop_thresh:
        right=threads
        threads=left
        step=int((right-left)/2)
    else:
        left=threads
    if right==left+1:
        break
    time.sleep(5+55*miss)
