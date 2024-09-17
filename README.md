# MPI Benchmarking in Kubernetes
## Overview
This project aims to estimate the latency between one and two nodes in a Kubernetes cluster using MPI (Message Passing Interface). It includes tests for point-to-point communication and a collective operation (broadcast).

## Prerequisites
- A Kubernetes cluster with at least two nodes: Minikube
- kubectl configured to interact with your cluster.
- Calico networking plugin installed.

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
Then, for the benchmark run:
```bash
chmod +x mpi_test.sh
./mpi_test.sh
```
After collecting the data run:
```bash
kubectl delete -f pods_different_node.yaml
```

### 4. Running the MPI Benchmark on the same node
```bash
kubectl apply -f pods_same_node.yaml
```
Then, for the benchmark run:
```bash
./mpi_test.sh
```
After collecting the data run:
```bash
kubectl delete -f pods_same_node.yaml
```
