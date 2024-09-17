#!/bin/bash

# Ottieni i nomi dei due pod
POD1=$(kubectl get pods -l app=osu-benchmark -o jsonpath='{.items[0].metadata.name}')
POD2=$(kubectl get pods -l app=osu-benchmark -o jsonpath='{.items[1].metadata.name}')

# Ottieni gli IP dei due pod
POD1_IP=$(kubectl get pod $POD1 -o jsonpath='{.status.podIP}')
POD2_IP=$(kubectl get pod $POD2 -o jsonpath='{.status.podIP}')

# Configura SSH per ignorare la verifica delle chiavi host sui pod
kubectl exec $POD1 -- bash -c 'mkdir -p /root/.ssh && echo "Host *" > /root/.ssh/config && echo "    StrictHostKeyChecking no" >> /root/.ssh/config && echo "    UserKnownHostsFile=/dev/null" >> /root/.ssh/config'
kubectl exec $POD2 -- bash -c 'mkdir -p /root/.ssh && echo "Host *" > /root/.ssh/config && echo "    StrictHostKeyChecking no" >> /root/.ssh/config && echo "    UserKnownHostsFile=/dev/null" >> /root/.ssh/config'

# Avvia il servizio SSH nei pod
kubectl exec $POD1 -- bash -c "service ssh start"
kubectl exec $POD2 -- bash -c "service ssh start"

# Esegui mpirun usando il launcher ssh
kubectl exec $POD1 -- mpirun -np 2 --host $POD1_IP,$POD2_IP ./mpi/pt2pt/osu_latency

kubectl exec $POD1 -- mpirun -np 2 --host $POD1_IP,$POD2_IP ./mpi/collective/osu_bcast -x 100 -i 1000 -f


