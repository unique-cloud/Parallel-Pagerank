#define DAMPING_FACTOR (0.85)

typedef struct
{
    int src;
    int dest;
} Edge;

typedef struct
{
    int dest;
    float val;
} Msg;

/*
 *  Each work item takes care of an edge in the graph,
 *  produce a msg with the proper value that the src should pass to the dest.
 *  As these work items corresponding to edges, none of srcs are single nodes.
 *  We can't handle sink nodes here, thus we do it somewhere else.
 */
__kernel void scatter(__global Edge *edge_arr, __global uint *outCount_arr,
                      __global Msg *msg_arr, __global float *rank)
{
    uint idx = get_global_id(0);
    Edge edge = edge_arr[idx];
    uint outCount = outCount_arr[edge.src];

    // produce message to msg array
    msg_arr[idx].dest = edge.dest;
    msg_arr[idx].val = rank[edge.src] / outCount;
}

/*
 *  Each work item takes care of a node in the graph,
 *  recieve all msgs belongs to itself.
 *  By adding them together and do some proper extra work,
 *  we get the pagerank of the node.
 *  Note that we add a sink value to each node.   
 */
__kernel void gather(__global Msg *msg_arr, __global float *rank,
                     __global float *err_arr, const uint num_edges,
                     const uint num_nodes, const float sink_val)
{
    uint idx = get_global_id(0);
    float d = DAMPING_FACTOR;

    // gather msg from array, makes complexity O(m)
    float rank_new = 0.0;
    for (int i = 0; i < num_edges; ++i)
    {
        if (msg_arr[i].dest == idx)
            rank_new += msg_arr[i].val;
    }

    // plus values from sink nodes
    rank_new += sink_val;
    // multiply by damping factor
    rank_new *= d;
    rank_new += (1 - d) / num_nodes;

    // caculate error
    err_arr[idx] = fabs(rank_new - rank[idx]);

    // update rank
    rank[idx] = rank_new;
}
