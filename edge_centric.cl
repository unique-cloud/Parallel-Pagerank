#define DAMPING_FACTOR (0.85)

__kernel void scatter(__global uint *src_arr, __global uint *dest_arr,
                      __global uint *outCount_arr, __global float *msg_arr,
                      const uint total_vtx_num)
{
    uint idx = get_global_id(0);

    // send messege to dest
    uint src = src_arr[idx];
    uint dest = dest_arr[idx];
    uint outCount = outCount_arr[src];

    if (outCount)
        msg_arr[dest] += 1 / outCount;
    else
        msg_arr[dest] += 1 / total_vtx_num;
};

__kernel void gather(__global float *msg_arr, const uint total_vtx_num)
{
    uint idx = get_global_id(0);
    float d = DAMPING_FACTOR;
    // Multiply by damping factor
    msg[idx] *= d;
    msg[idx] += (1 - d) / total_vtx_num;
}
