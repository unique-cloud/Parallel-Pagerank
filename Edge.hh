#ifndef EDGE_H
#define EDGE_H

class Edge
{
public:
    Edge(int src, int dest)
    {
        this->src = src;
        this->dest = dest;
    }

    int src;
    int dest;
};

#endif