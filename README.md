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

