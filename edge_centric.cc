#include <string>
#include <iostream>
#include <fstream>
#include <vector>
#include "pagerank.hh"
#include "Edge.hh"

using namespace std;

int edge_centric()
{
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
        //Debug: print title of the data set
        //printf("%s",str);
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
        if(str.empty())
            continue;

        sscanf(str.c_str(), "%d %d", &vtx1, &vtx2);
        Edge *e = new Edge(vtx1, vtx2);
        edges.push_back(e);
    }

    cout << "The total number of edges read in:" << edges.size() << endl;
    // cout<<"Now printing the edges: " <<endl;
    // for(auto &e : edges)
    // {
    //     std::cout << "edge " << e->src << " " << e->dest << std::endl;
    // }

    return 0;
}
