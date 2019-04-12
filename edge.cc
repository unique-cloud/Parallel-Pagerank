#include "pagerank.hh"
#include <string>

using namespace std;

class Edge
{
    edge(int src, int dest)
    {
        this.src = src;
        this.dest = dest;
    }
    int src;
    int dest;
}

int edge()
{
    // Open dataset
    string filename = "./hollins.dat";
    FILE *p;
    if((fp = fopen(filename, "r")==NULL)
    {
        cout<<"Cannot open the file"<<endl;
	exit(1);
    }     
    
    // Read data
    vector<Edge *> edges;
    while(!feof(fp))
    {
	fscan(fp, "%d%d", &node1, &node2);
	Edge *e = new edge(node1, node2);
        edges.push_back(e);
    }
    
    cout<<"Now printing the edges:\n";
    for(auto &e : edges)
    {
        cout<<"edge "<<e->src<<" "<<e->dest<<endl;    
    }

    return 0;
}

