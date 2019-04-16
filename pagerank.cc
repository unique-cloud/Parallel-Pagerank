#include <string>
#include <iostream>
#include <fstream>
#include <vector>
#include <sys/time.h>
#include <cmath>
#include "pagerank.hh"

using namespace std;

int main(int argc, char **argv)
{
    // Create timers for each method
    struct timeval time_start, time_end, program_start, program_end;
    int mode = 0;
    gettimeofday(&program_start, NULL);

    if (argc != 3)
    {
        cerr << "Usage: " << argv[0] << " dataset mode\n";
        exit(EXIT_FAILURE);
    }
    mode = atoi(argv[2]);

    /************************************READ DATASET***********************************/
    // Open dataset
    string filename(argv[1]);
    ifstream infile(filename.c_str(), ios::in);
    if (!infile)
    {
        cerr << "Cannot open the file" << endl;
        exit(EXIT_FAILURE);
    }

    // read the dataset and get basic info
    int num_nodes = 0, num_edges = 0;
    char ch;
    string str;
    ch = infile.get();
    while (ch == '#')
    {
        getline(infile, str);
        sscanf(str.c_str(), "%*s %d %*s %d", &num_nodes, &num_edges);
        ch = infile.get();
    }
    infile.putback(ch);

    // DEBUG: Print the number of nodes
    cout << "Number of nodes = " << num_nodes << endl;
    cout << "Number of edges = " << num_edges << endl;

    // Read data
    std::vector<Edge> edges;
    int node1, node2;
    while (!infile.eof())
    {
        getline(infile, str);
        if (str.empty())
            continue;

        sscanf(str.c_str(), "%d %d", &node1, &node2);
        Edge e = {node1 - 1, node2 - 1};
        edges.push_back(e);
    }

    cout << "The total number of edges read in: " << edges.size() << endl;
    if (num_edges != edges.size())
    {
        cerr << "Wrong number of data size";
        exit(EXIT_FAILURE);
    }

    /***************************************PAGERANK****************************************/
    float *output_rank = new float[num_nodes];
    float *base_rank = new float[num_nodes];

    switch (mode)
    {
    case 1:
        gettimeofday(&time_start, NULL);
        power(edges, num_nodes, output_rank);
        gettimeofday(&time_end, NULL);
        cout << "Using power method: ";
        break;
    case 2:
        gettimeofday(&time_start, NULL);
        edge_centric(edges, num_nodes, output_rank);
        gettimeofday(&time_end, NULL);
        cout << "Using edge centric method: ";
        break;
    case 10:
        gettimeofday(&time_start, NULL);
        deviceInfoQuery();
        gettimeofday(&time_end, NULL);
        cout << "Querying device info: ";
        return 0;
    default:
        gettimeofday(&time_start, NULL);
        baseline(edges, num_nodes, output_rank);
        gettimeofday(&time_end, NULL);
        cout << "Using baseline: ";
        break;
    }

    cout << (time_end.tv_sec * 1000000 + time_end.tv_usec) - (time_start.tv_sec * 1000000 + time_start.tv_usec) << endl;

    // Verify result
    cerr << "Verifying Result" << endl;
    baseline(edges, num_nodes, base_rank);
    int i = 0;
    for (i = 0; i < num_nodes; i++)
    {
        if (fabs(output_rank[i] - base_rank[i]) >= DIFF_ERROR)
            break;
    }
    if (i != num_nodes)
        cerr << "Failed at " << i << endl;
    else
        cerr << "Pass" << endl;

    // Cleanup
    delete (output_rank);
    delete (base_rank);

    gettimeofday(&program_end, NULL);

    return 0;
}
