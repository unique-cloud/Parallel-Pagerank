#include <iostream>
#include "pagerank.hh"
#include "common.hh"
// #include "custom.hh"

using namespace std;

int edge_centric(vector<Edge> &edges, const int N)
{   
    // Create and initialize necessary arrays
    uint num_edges = edges.size();
    uint *outCount_arr = new uint[N]{0};
    Msg *msg_arr = new Msg[num_edges];
    float *err_arr = new float[N];
    float *rank_arr = new float[N];

    for (auto &e : edges)
        outCount_arr[e.src]++;
    for (int i = 0; i < N; ++i)
        rank_arr[i] = 1.0 / N;

    vector<int> sink_idx;
    for(int i = 0; i < N; ++i)
    {
        if(outCount_arr[i] == 0)
	    sink_idx.push_back(i);
    }

    string cl_name = "edge_centric.cl";
    init_opencl(cl_name);
    
    // Kernel.
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
    size_t global_size;
    int iter_count = 0;
    float error, sink_rank;

    clSetKernelArg(kernel[0], 0, sizeof(cl_mem), (void *)&edgeBuffer);
    clSetKernelArg(kernel[0], 1, sizeof(cl_mem), (void *)&outCountBuffer);
    clSetKernelArg(kernel[0], 2, sizeof(cl_mem), (void *)&msgBuffer);
    clSetKernelArg(kernel[0], 3, sizeof(cl_mem), (void *)&rankBuffer);
    clSetKernelArg(kernel[0], 4, sizeof(int), (void *)&N);

    clSetKernelArg(kernel[1], 0, sizeof(cl_mem), (void *)&msgBuffer);
    clSetKernelArg(kernel[1], 1, sizeof(cl_mem), (void *)&rankBuffer);
    clSetKernelArg(kernel[1], 2, sizeof(cl_mem), (void *)&errBuffer);
    clSetKernelArg(kernel[1], 3, sizeof(int), (void *)&num_edges);
    clSetKernelArg(kernel[1], 4, sizeof(int), (void *)&N);

    do
    {
        cout << "Iteration: " << ++iter_count << endl;
        
        float *mapRank = (float *)clEnqueueMapBuffer(queue[0], rankBuffer, true, CL_MAP_READ, 0,
                                                   sizeof(float) * N, 0, NULL, NULL, &status);
        sink_rank = 0; 
	for(auto &idx : sink_idx)
        {
	    sink_rank += mapRank[idx];
	}
	sink_rank /= N;
        clEnqueueUnmapMemObject(queue[0], rankBuffer, (void *)mapRank, 0, NULL, NULL);
        clSetKernelArg(kernel[1], 5, sizeof(int), (void *)&sink_rank);

        global_size = num_edges;
        clEnqueueNDRangeKernel(queue[0], kernel[0], 1, NULL,
                               &global_size, NULL, 0, NULL, NULL);
	
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

    } while (error > 0.000001);

    float *mapRank = (float *)clEnqueueMapBuffer(queue[0], rankBuffer, true, CL_MAP_READ, 0,
                                                   sizeof(float) * N, 0, NULL, NULL, &status);
    cout << "Finial rank is:" << endl;
    for(int i = 0; i < N; ++i)
    {
        cout << mapRank[i]<<", ";
    }
    cout << endl;
    clEnqueueUnmapMemObject(queue[0], rankBuffer, (void *)mapRank, 0, NULL, NULL);

    /******************************CLEAN UP******************************/
    delete (outCount_arr);
    delete (msg_arr);
    delete (rank_arr);
    delete (err_arr);

    return 0;
}