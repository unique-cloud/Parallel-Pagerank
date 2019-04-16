#include <iostream>
#include <vector>
#include "pagerank.hh"
#include "common.hh"
#include "CL/opencl.h"
#include "AOCL_Utils.h"

using namespace std;

/* OpenCL Power Method implementation of the PageRank algorithm */

typedef struct __attribute__ ((packed)) {
	int row;
	int column;
	float value;
} Element;

int power(vector<Edge> &edges, const int N, float *output_rank)
{
    // Defind the dumping factor
	float d = 0.85;
    
    	// Initialize the output link 
	vector<int> out_link(N, 0);
    vector<int> sink_idx;
    
	// Initialize the output link vector
	for (auto &e : edges)
	{
		out_link[e.src]++;
	}
    for(int i = 0; i < out_link.size(); ++i)
    {
        if(out_link[i] == 0)
            sink_idx.push_back(i);
    }
    
    vector<Element> p_matrix; 
    for(auto &e : edges)
    {
        Element ele = {e.src, e.dest, 1 / out_link[e.src]};
        p_matrix.push_back(ele);
    }

	// Initialize new p vector
    float *p = new float[N];
	float *p_new = new float[N]{0.0};
    float *error = new float[N]{0.0};
    
    for(int i = 0; i < N; ++i)
    {
        p[i] = 1.0 / N;
    }

	string cl_name = "power";
	init_opencl(cl_name);

	// Kernel.
	const char *kernel_name = "fpgasort";
	kernel[0] = clCreateKernel(program, kernel_name, &status);
	checkError(status, "Failed to create kernel");

	// Allocate buffer on device and migrate data
	cl_mem matrixBuffer = clCreateBuffer(context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR,
								    p_matrix.size() * sizeof(Element), &p_matrix[0], &status);
	cl_mem RVectorBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR,
									N * sizeof(float), p, &status);
	cl_mem outputBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR,
								   N * sizeof(float), p_new, &status);
	cl_mem errorBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,
									   N * sizeof(float), error, &status);

	cl_mem *P_RVector = &RVectorBuffer;
	cl_mem *P_output = &outputBuffer;
    float sink_value = 0;
    size_t global_work_size = N;
    int num_edges = edges.size();

    clSetKernelArg(kernel[0], 0, sizeof(cl_mem), (void *)&matrixBuffer);
	clSetKernelArg(kernel[0], 1, sizeof(cl_mem), (void *)P_RVector);
	clSetKernelArg(kernel[0], 2, sizeof(cl_mem), (void *)P_output);
	clSetKernelArg(kernel[0], 3, sizeof(cl_mem), (void *)&errorBuffer);
	clSetKernelArg(kernel[0], 5, sizeof(cl_int), (void *)&num_edges);
    
	while (true)
	{
        float *mapRank = (float *)clEnqueueMapBuffer(queue[0], (*P_RVector), true, CL_MAP_READ, 0,
													sizeof(float) * N, 0, NULL, NULL, &status);
        // Caculate sink value
        sink_value = 0;
        for(auto &idx : sink_idx)
        {
            sink_value += mapRank[idx];
        }
        sink_value /= N;
        clEnqueueUnmapMemObject(queue[0], (*P_RVector), (void *)mapRank, 0, NULL, NULL);
        
        clSetKernelArg(kernel[0], 4, sizeof(cl_int), &sink_value);
        
		clEnqueueNDRangeKernel(queue[0], kernel[0], 1, NULL, &global_work_size, NULL, 0, NULL, NULL);
		//         clFinish(queue[0]);

		float *mapErr = (float *)clEnqueueMapBuffer(queue[0], errorBuffer, true, CL_MAP_READ, 0,
													sizeof(float) * N, 0, NULL, NULL, &status);
		float errorSum = 0.0;
		for (int i = 0; i < N; i++)
		{
			errorSum += mapErr[i];
		}
		clEnqueueUnmapMemObject(queue[0], errorBuffer, (void *)mapErr, 0, NULL, NULL);
        std::cout << "Power Error is: " << errorSum << endl;
		//if two consecutive instances of pagerank vector are almost identical, stop
		if (errorSum < DIFF_ERROR)
		{
			clEnqueueReadBuffer(queue[0], (*P_output), CL_TRUE, 0, N * sizeof(float), output_rank, 0, NULL, NULL);
			break;
		}

		cl_mem *tmp = P_RVector;
		P_RVector = P_output;
		P_output = tmp;
	}

	// printf("Final Pagerank values:\n\n[");
	// for (i = 0; i < N; i++)
	// {
	// 	std::cout << " " << p[i];
	// 	if (i != (N - 1))
	// 	{
	// 		std::cout << ", ";
	// 	}
	// }
	// printf("]\n\n");
    
	return 0;
}

