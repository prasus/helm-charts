#!/bin/bash
while [ 1 ];
do
    namespace=netpyne
    webhookURL=$slackurl
    cluster=$cluster
    podList=$(kubectl -n $namespace get pods -l component=singleuser-server | grep -i running | awk {'print $1'} | tee /tmp/pods.running)
    
    for pod in $(cat /tmp/pods.running)
    do
        kubectl -n $namespace exec -it $pod -- ps -eo comm | grep -Evi 'command|ps|grep' > /tmp/process.list
        process_count=$(wc -l /tmp/process.list | cut -d' ' -f1)
        if [ $process_count -gt 5 ]
        then
            postData=":red_circle: unexpected mumber of processes in $cluster, pod: $pod"
            curl -X POST -H "Content-type: application/json" --data "{\"text\": \"${postData}\"}" $webhookURL
            sleep 15m
        fi
        grep -Evi 'tini|python|bash|netpyne' /tmp/process.list
        if [ $? -eq 0 ]
        then
            postData=":red_circle: unexpected process in $cluster, pod: $pod"
	    curl -X POST -H "Content-type: application/json" --data "{\"text\": \"${postData}\"}" $webhookURL
            sleep 15m
        fi
    done
done
