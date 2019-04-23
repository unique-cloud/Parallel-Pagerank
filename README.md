Parallel Pagerank (OpenCL)
======================

## OVERVIEW
This is an OpenCL implementation of the Pagerank Algorithm. We use two ways to implement it, power method and edge-centric method.

## SOFTWARE AND SYSTEM REQUIREMENTS
You need to have an OpenCL supported environment to run this program. The table below lists the devices we used when we implement the program.

Device | Platform
-------|----------
GeForce RTX 2080 | Nvidia Cuda
DE1-SoC Board | Altera SDK for OpenCL

## COMPILATION AND EXECUTION
If you are using the OpenCL environment under a Linux OS, you can just run
```
make
```
to compile the program, then execute it by running
```
./pagerank ./dataset/hollins.txt 0
```
where "hollins.txt" is the input dataset and "0" is the mode selected.

If you are using the Altera SDK, you can run
```
make fpgapagerank
```
to compile the host program, and run
```
make edge_centric.aocx
```
or
```
make power.aocx
```
to compile the kernel you want. Then you should copy all the generated files (or simplely copy the whole directory) to the target Altera supported device (e.g. DE1-SoC Board), and program the FPGA like
```
aocl program /dev/acl0 edge_centric.aocx
```
Note: You should follow the instructions of your device to setup environment properly before this.

After you setup the environment properly, similarly run
```
./pagerank ./dataset/hollins.txt 2
```
to execute the program. 

We already provide 3 sample dataset files and the program support 3 modes:

Dataset | Description | Number of Nodes | Number of Edges
--------|-------------|-----------------|----------------
sample.txt | The smallest dataset sampled from hollins.txt | 1000 | 9951
hollins.txt | [Kenneth Massey's Information Retrieval webpage][] | 6012 | 23875
web-NotreDame.txt | [University of Notre Dame web graph from 1999][] | 325729 | 149713

<br/>

Mode | Description
-----|-------------
0 | baseline (sequential power method)
1 | power method
2 | edge-centric 

## PERFORMANCE
We test our program on both GPU (GeForce RTX 2080) and FPGA (DE1-SoC).

 Mode | GPU Runtime | Speedup | FPGA Runtime | Speedup
 -----|-------------|---------|--------------|---------
 Baseline | 2069173 | 1 | 23506637 | 1
 Power method | 249466 | ~8.29x | 65667768 | ~0.35x
 Edge-centric | 197062 | ~10.50x | 57100918 | ~0.41x



[Kenneth Massey's Information Retrieval webpage]: https://www.limfinity.com/ir/
[University of Notre Dame web graph from 1999]: https://snap.stanford.edu/data/web-NotreDame.html