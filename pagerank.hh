#ifndef PAGERANK_H
#define PAGERANK_H

#include <vector>
#include "common.hh"

using namespace std;

int deviceInfoQuery();
int power(vector<Edge> &edges, const int N);
int edge_centric(vector<Edge> &edges, const int N);
int edge_opt(vector<Edge> &edges, const int N);
int baseline(vector<Edge> &edges, const int N);
int test();

#endif
