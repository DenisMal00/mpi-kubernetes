# MPI Benchmarking in Kubernetes
## Overview
This project aims to estimate the latency between one and two nodes in a Kubernetes cluster using MPI (Message Passing Interface). It includes tests for point-to-point communication and a collective operation (broadcast).

## Prerequisites
- A Kubernetes cluster with at least two nodes: Minikube
- kubectl configured to interact with your cluster.

## Steps

### 1. Setup Kubernetes Cluster
- Create a Minikube cluster with multiple nodes.
```bash
minikube start --nodes 2 -p multinode
```
Creates two nodes in the multinode cluster

- Install Calico for networking.
```bash
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

### 2. Deploying the MPI Benchmark
The provided yaml files automatically pulls the Docker image (den00/osu-benchmark-ssh), so there’s no need to build or pull the image manually. Just apply the YAML file, and it will set up the MPI benchmark pods.

### 3. Running the MPI Benchmark on Different nodes
To do the benchmark on two diffente nodes run first:
```bash
kubectl apply -f pods_different_node.yaml
```
Then, after the nodes are created, for the benchmark run:
```bash
chmod +x mpi_test.sh
./mpi_test.sh
```
After collecting the data run:
```bash
kubectl delete -f pods_different_node.yaml
```
And wait untile the nodes are deleted

## My results:
```bash
OSU MPI Latency Test v5.9
Size                Latency (us)
0                       6.69
1                       7.63
2                       6.47
4                       6.30
8                       5.93
16                      6.38
32                      6.71
64                      6.84
128                     6.48
256                     7.36
512                     6.71
1024                    7.72
2048                    8.65
4096                    8.61
8192                   13.35
16384                  10.34
32768                  12.49
65536                  20.74
131072                 42.31
262144                 59.74
524288                107.61
1048576               170.16
2097152               352.35
4194304               749.00

OSU MPI Broadcast Latency Test v5.9
  Size       Avg Latency(us)   Min Latency(us)   Max Latency(us)  Iterations
1                       7.61              6.38              8.84        1000
2                       6.63              5.55              7.71        1000
4                       6.04              5.06              7.01        1000
8                       7.38              6.12              8.64        1000
16                      7.20              6.03              8.36        1000
32                      6.87              5.78              7.97        1000
64                      6.40              5.39              7.41        1000
128                     7.97              6.60              9.33        1000
256                     9.03              7.37             10.69        1000
512                     7.95              6.84              9.07        1000
1024                    8.43              7.92              8.95        1000
2048                   10.03              9.22             10.83        1000
4096                    9.74              9.29             10.20        1000
8192                   10.70             10.07             11.34        1000
16384                  12.49             12.46             12.52        1000
32768                  20.47             16.10             24.84        1000
65536                  22.80             17.35             28.25        1000
131072                 49.53             45.81             53.25        1000
262144                 64.56             60.28             68.84        1000
524288                108.00            102.19            113.81        1000
1048576               179.68            175.04            184.31        1000
```
### 4. Running the MPI Benchmark on the same node
```bash
kubectl apply -f pods_same_node.yaml
```
Then,after the nodes are created, for the benchmark run:
```bash
./mpi_test.sh
```
After collecting the data run:
```bash
kubectl delete -f pods_same_node.yaml
```
And wait untile the nodes are deleted

## My results:
```bash
OSU MPI Latency Test v5.9
 Size          Latency (us)
0                       4.03
1                       4.50
2                       3.75
4                       4.04
8                       4.26
16                      3.28
32                      4.08
64                      3.65
128                     3.36
256                     4.18
512                     4.30
1024                    5.57
2048                    6.92
4096                    6.03
8192                    6.18
16384                   7.44
32768                   7.09
65536                  11.60
131072                 26.56
262144                 34.89
524288                 63.02
1048576               154.80
2097152               283.84
4194304               683.72

OSU MPI Broadcast Latency Test v5.9
  Size       Avg Latency(us)   Min Latency(us)   Max Latency(us)  Iterations
1                       3.35              3.00              3.71        1000
2                       3.00              2.66              3.34        1000
4                       2.79              2.48              3.11        1000
8                       2.73              2.42              3.03        1000
16                      2.69              2.39              2.99        1000
32                      2.59              2.33              2.84        1000
64                      4.47              4.01              4.92        1000
128                     3.55              3.13              3.97        1000
256                     2.73              2.41              3.05        1000
512                     3.50              3.49              3.52        1000
1024                    3.20              2.41              3.99        1000
2048                    5.24              4.29              6.19        1000
4096                    5.62              4.59              6.65        1000
8192                    3.95              3.06              4.85        1000
16384                   6.50              5.11              7.88        1000
32768                   7.47              5.79              9.14        1000
65536                   9.63              8.92             10.34        1000
131072                 23.59             23.57             23.62        1000
262144                 38.73             37.82             39.64        1000
524288                 61.97             61.60             62.34        1000
1048576               118.39            117.42            119.35        1000
```
Latencies between pods located on the same node are noticeably lower than those between pods on different nodes. 
