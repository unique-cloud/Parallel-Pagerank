#ifndef PAGERANK_H
#define PAGERANK_H

#include <vector>
#include "common.h"

using namespace std;

int deviceInfoQuery();
int power(vector<Edge> &edges, const int N, float *output_rank);
int edge_centric(vector<Edge> &edges, const int N, float *output_rank);
int baseline(vector<Edge> &edges, const int N, float *output_rank);

#endif
