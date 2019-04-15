#include <iostream>
#include "pagerank.hh"
#include "common.hh"

using namespace std;

int edge_centric(vector<Edge> &edges, const int N, float *output_rank)
{
    // Create and initialize necessary arrays
    uint num_edges = edges.size();
    uint *outCount_arr = new uint[N]{0};
    float *err_arr = new float[N];
    float *rank_arr = new float[N];
    Msg *msg_arr = new Msg[num_edges];

    for (auto &e : edges)
        outCount_arr[e.src]++;
    for (int i = 0; i < N; ++i)
        rank_arr[i] = 1.0 / N;

    // Record sink nodes indices
    vector<int> sink_idx;
    for (int i = 0; i < N; ++i)
    {
        if (outCount_arr[i] == 0)
            sink_idx.push_back(i);
    }

    string cl_name = "edge_centric";
    init_opencl(cl_name);

    // Set kernels
    kernel[0] = clCreateKernel(program, "scatter", &status);
    checkError(status, "Failed to create kernel");
    kernel[1] = clCreateKernel(program, "gather", &status);
    checkError(status, "Failed to create kernel");

    // Allocate buffer on device and migrate data
    cl_mem edgeBuffer = clCreateBuffer(context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR,
                                       num_edges * sizeof(Edge), &edges[0], &status);
    cl_mem outCountBuffer = clCreateBuffer(context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR,
                                           N * sizeof(int), outCount_arr, &status);
    cl_mem msgBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR,
                                      num_edges * sizeof(Msg), msg_arr, &status);
    cl_mem rankBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,
                                       N * sizeof(float), rank_arr, &status);
    cl_mem errBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,
                                      N * sizeof(float), err_arr, &status);

    clSetKernelArg(kernel[0], 0, sizeof(cl_mem), (void *)&edgeBuffer);
    clSetKernelArg(kernel[0], 1, sizeof(cl_mem), (void *)&outCountBuffer);
    clSetKernelArg(kernel[0], 2, sizeof(cl_mem), (void *)&msgBuffer);
    clSetKernelArg(kernel[0], 3, sizeof(cl_mem), (void *)&rankBuffer);

    clSetKernelArg(kernel[1], 0, sizeof(cl_mem), (void *)&msgBuffer);
    clSetKernelArg(kernel[1], 1, sizeof(cl_mem), (void *)&rankBuffer);
    clSetKernelArg(kernel[1], 2, sizeof(cl_mem), (void *)&errBuffer);
    clSetKernelArg(kernel[1], 3, sizeof(int), (void *)&num_edges);
    clSetKernelArg(kernel[1], 4, sizeof(int), (void *)&N);

    size_t global_size;
    int iter_count = 0;
    float error, sink_val;

    do
    {
        cout << "Iteration: " << ++iter_count << endl;

        /* 
         * Caculate the sum of value that each node should recieve from all sink nodes.
         * In pagerank, each sink node should pass a value of rank/N to all the nodes (include itself).
         * Thus, each node should recieve values from all sink nodes. The sum of the value is
         * Sum = rank(sink_1)/N + rank(sink_2)/N + ... + rank(sink_m)/N = sum_rank(sink nodes) / N
         * where m is the total number of sink nodes. 
         */
        float *mapRank = (float *)clEnqueueMapBuffer(queue[0], rankBuffer, true, CL_MAP_READ, 0,
                                                     sizeof(float) * N, 0, NULL, NULL, &status);
        sink_val = 0;
        for (auto &idx : sink_idx)
        {
            sink_val += mapRank[idx];
        }
        sink_val /= N;
        clEnqueueUnmapMemObject(queue[0], rankBuffer, (void *)mapRank, 0, NULL, NULL);
        // The sink value will be added during the gather phase
        clSetKernelArg(kernel[1], 5, sizeof(int), (void *)&sink_val);

        // Scatter: Each thread produce a msg with an edge in the graph
        global_size = num_edges;
        clEnqueueNDRangeKernel(queue[0], kernel[0], 1, NULL,
                               &global_size, NULL, 0, NULL, NULL);

        // Gather: Each node recieve msgs whose dest is the node
        global_size = N;
        clEnqueueNDRangeKernel(queue[0], kernel[1], 1, NULL,
                               &global_size, NULL, 0, NULL, NULL);

        // Caculate error
        float *mapErr = (float *)clEnqueueMapBuffer(queue[0], errBuffer, true, CL_MAP_READ, 0,
                                                    sizeof(float) * N, 0, NULL, NULL, &status);
        error = 0;
        for (int i = 0; i < N; ++i)
        {
            error += mapErr[i];
        }
        clEnqueueUnmapMemObject(queue[0], errBuffer, (void *)mapErr, 0, NULL, NULL);
        cout << "Error is " << error << endl;

    } while (error >= DIFF_ERROR);

	clEnqueueReadBuffer(queue[0], rankBuffer, CL_TRUE, 0, N * sizeof(float), output_rank, 0, NULL, NULL);
    // cout << "Finial rank is:" << endl;
    // for (int i = 0; i < N; ++i)
    // {
    //     cout << output_rank[i] << ", ";
    // }
    // cout << endl;

    // Clean up
    delete (outCount_arr);
    delete (msg_arr);
    delete (rank_arr);
    delete (err_arr);

    cleanup();

    return 0;
}