from concurrent.futures import ThreadPoolExecutor as Pool
import requests
import urllib
import time, os

server = "http://202.120.36.29:9030/db/query?"



def send_sparql(args):
    # f = open("m.txt", "a")
    n = args['n']
    query = args['query']
    # print ("in send")
    f_c = 0
    t_time = 0
    for i in range(n):
        try:
            st = time.time()
            r = requests.get(query, timeout=5)
            dur = time.time() - st
        # print (dur)
        # f.write(str(dur)+'\n')
        except KeyboardInterrupt:
            exit()
        except:
            f_c += 1
            t_time += 5
        else:
            t_time += dur
    return f_c, t_time

query = {"query": "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> SELECT ?s WHERE { ?s ?p ?o .}"}
# print (query)
query = server + urllib.parse.urlencode(query)
# print (query)



SEND_EACH = 20
BEGIN = 10
END = 150
STEP = 10
# for MULTI_COUNT in range(50, 1050, 50):
f = open("%d_res_%d_%d_%d.csv" % (SEND_EACH, BEGIN, END, STEP), "w")
for MULTI_COUNT in range(BEGIN, END, STEP):
    send_total = SEND_EACH * MULTI_COUNT
    fcount = 0
    sum_dur = 0
    tasks = []
    for i in range(MULTI_COUNT):
        tasks.append({'n': SEND_EACH, 'query': query})
        # tasks.append([send_num, query])
    pool = Pool(max_workers=MULTI_COUNT)
    results = pool.map(send_sparql, tasks)
    # print (results)
    for item in results:
        fcount += item[0]
        sum_dur += item[1]
    print ("Send %d concurrently, \
        Miss Rate: %.3f, Avr Return Time: %.3fms" % 
        (MULTI_COUNT, fcount/send_total, sum_dur/send_total*1000))
    f.write("%d,%.3f,%.3f\n"%(MULTI_COUNT, fcount/send_total, sum_dur/send_total*1000))
    time.sleep(60)
        
    
    
    # print ("Miss Rate: %.3f, Avr Success Return Time: %.3fs" % (fcount / SEND_COUNT, sum_dur / (SEND_COUNT - fcount)))