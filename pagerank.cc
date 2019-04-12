#include <string>
#include <iostream>
#include <fstream>
#include <vector>
#include <sys/time.h>
#include "pagerank.hh"

using namespace std;

int main(int argc, char **argv)
{
    // Create timers for each method
    struct timeval time_start, time_end, program_start, program_end;
    int mode = 0;
    gettimeofday(&program_start, NULL);

    if (argc != 2)
    {
        cerr << "Usage: " << argv[0] << " mode\n";
        exit(EXIT_FAILURE);
    }
    mode = atoi(argv[1]);
    
/************************************READ DATASET***********************************/
    // Open dataset
    string filename = "./hollins.dat";
    ifstream infile(filename, ios::in);
    if (!infile)
    {
        cerr << "Cannot open the file" << std::endl;
        exit(EXIT_FAILURE);
    }

    // Read the data set and get the number of nodes (n)
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
    cout << "Number of nodes = " << num_nodes << std::endl;
    cout << "Number of edges = " << num_edges << std::endl;

    // Read data
    std::vector<Edge *> edges;
    int vtx1, vtx2;
    while (!infile.eof())
    {
        getline(infile, str);
        if (str.empty())
            continue;

        sscanf(str.c_str(), "%d %d", &vtx1, &vtx2);
        Edge *e = new Edge(vtx1, vtx2);
        edges.push_back(e);
    }

    cout << "The total number of edges read in: " << edges.size() << endl;
    if(num_edges != edges.size())
    {
        cerr << "Wrong number of data size";
        exit(EXIT_FAILURE);
    }
    
    // cout<<"Now printing the edges: " <<endl;
    // for(auto &e : edges)
    // {
    //     std::cout << "edge " << e->src << " " << e->dest << std::endl;
    // }
/********************************END OF READ DATASET****************************/

    switch (mode)
    {
    case 1:
        gettimeofday(&time_start, NULL);
        power(edges, num_nodes);
        gettimeofday(&time_end, NULL);
        cout << "Using power method: ";
        break;
    case 2:
        gettimeofday(&time_start, NULL);
        edge_centric(edges, num_nodes);
        gettimeofday(&time_end, NULL);
        cout << "Using edge centric: ";
        break;
    case 3:
        gettimeofday(&time_start, NULL);
        edge_opt(edges, num_nodes);
        gettimeofday(&time_end, NULL);
        cout << "Using optimized edge centric: ";
        break;
    case 10:
        // this is for test compling
        gettimeofday(&time_start, NULL);
        deviceInfoQuery();
        gettimeofday(&time_end, NULL);
        cout << "Querying device info: ";
        break;
    default:
        gettimeofday(&time_start, NULL);
        baseline(edges, num_nodes);
        gettimeofday(&time_end, NULL);
        cout << "Using baseline: ";
        break;
    }
    
    cout << (time_end.tv_sec * 1000000 + time_end.tv_usec) - (time_start.tv_sec * 1000000 + time_start.tv_usec) << endl;

    gettimeofday(&program_end, NULL);
    
    return 0;
}
