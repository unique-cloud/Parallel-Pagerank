#define DAMPING_FACTOR (0.85)

typedef struct {
    int src;
    int dest;
} Edge;

typedef struct {
    int dest;
    float val;
} Msg;

__kernel void scatter(__global Edge *edge_arr, __global uint *outCount_arr, 
		      __global Msg *msg_arr, __global float *rank, 
                      const uint num_vtx)
{
    uint idx = get_global_id(0);

    // send messege to dest
    Edge edge = edge_arr[idx];
    uint outCount = outCount_arr[edge.src];

    if (idx == 0)
    {
        printf("Inital rank array is %.8f\n", rank[edge.src]);
    }
    
    Msg msg = {edge.dest, 0};
    if (outCount)
        msg.val = rank[edge.src] / outCount;

    msg_arr[idx] = msg;
}

__kernel void gather(__global Msg *msg_arr, __global float *rank, 
                     __global float *err_arr, const uint num_edges, 
                     const uint num_vtx, const float sink_rank)
{
    uint idx = get_global_id(0);
    float d = DAMPING_FACTOR;

    // gather message
    float rank_new = 0.0;
    for(int i = 0; i < num_edges; ++i)
    {
        if(msg_arr[i].dest == idx)
            rank_new += msg_arr[i].val;
    }

    // Multiply by damping factor
    rank_new += sink_rank;
    rank_new *= d;
    rank_new += (1 - d) / num_vtx;
    
    // Caculate error
    err_arr[idx] = fabs(rank_new - rank[idx]);

    // Set 0 for next iteration
    rank[idx] = rank_new;
}
