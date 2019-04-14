#include <iostream>
#include "pagerank.hh"
#include "common.hh"
#include "CL/opencl.h"
#include "AOCL_Utils.h"

using namespace std;

int power(vector<Edge> &edges, const int N, float *output_rank)
{

	float d = 0.85;

	float **a = (float **)malloc(sizeof(float *) * N);
	int i, j, node1, node2;

	for (i = 0; i < N; i++)
	{
		a[i] = (float *)malloc(sizeof(float) * N);
	}

	for (i = 0; i < N; i++)
	{
		for (j = 0; j < N; j++)
		{
			a[i][j] = 0.0;
		}
	}

	// Update the matrix to 1.0 if there's an edge between nodes
	for (auto &edge : edges)
	{
		a[edge.src][edge.dest] = 1;
	}

	/********************** INITIALIZATION OF AT **************************/

	//     float **at = (float**)malloc(sizeof(float*) * N);

	//     // Preallocate space for the transposed matrix 'at'
	// 	for (i = 0; i < N; i++) {
	// 	    at[i] = (float*)malloc(sizeof(float) * N);
	// 	}

	// 	// Initialize all the transposed matrix to 0.0
	// 	for (i=0; i<N; i++){
	// 		for (j=0; j<N; j++){
	// 			at[i][j] = 0.0;
	// 		}
	// 	}

	//     	/************************** MATRIX IS TRANSPOSED **********************/

	// 	// Transpose the matrix
	// 	for (i=0; i<N; i++){
	// 		for (j=0; j<N; j++){
	// 			at[j][i] = a[i][j];
	// 		}
	// 	}

	/********************** INITIALIZATION OF P **************************/

	float *p = new float[N];

	// Initialize the p[] vector
	for (i = 0; i < N; i++)
	{
		p[i] = 1.0 / N;
	}

	/******************* INITIALIZATION OF OUTPUT LINK ********************/

	int *out_link = new int[N];

	// Initialize the output link vector
	for (i = 0; i < N; i++)
	{
		out_link[i] = 0;
	}

	// Manage dangling nodes
	for (i = 0; i < N; i++)
	{
		for (j = 0; j < N; j++)
		{
			if (a[i][j] != 0.0)
			{
				out_link[i] = out_link[i] + 1;
			}
		}
	}

	/*********************** MATRIX STOCHASTIC-FIED  ***********************/

	// Make the matrix stochastic
	for (i = 0; i < N; i++)
	{
		if (out_link[i] == 0)
		{
			// Deal with dangling nodes
			for (j = 0; j < N; j++)
			{
				a[i][j] = 1.0 / N;
			}
		}
		else
		{
			for (j = 0; j < N; j++)
			{
				if (a[i][j] != 0)
				{
					a[i][j] = a[i][j] / out_link[i];
				}
			}
		}
	}

	// Transpose
	float *at = new float[N * N];

	for (int i = 0; i < N; i++)
	{
		for (int j = 0; j < N; j++)
		{
			at[i + j * N] = a[i][j];
		}
	}

	/*************************** PageRank LOOP  **************************/

	// Set the looping condition and the number of iterations 'k'
	int looping = 1;

	// Initialize new p vector
	float *p_new = new float[N];
	for (i = 0; i < N; i++)
	{
		p_new[i] = 0.0;
	}

	float *error = (float *)malloc(sizeof(float) * N);
	for (i = 0; i < N; i++)
	{
		error[i] = 0.0;
	}

	string cl_name = "power.cl";
	init_opencl(cl_name);

	// Kernel.
	const char *kernel_name = "fpgasort";
	kernel[0] = clCreateKernel(program, kernel_name, &status);
	checkError(status, "Failed to create kernel");

	size_t global_work_size = N;

	//     // Allocate buffer on device and migrate data
	cl_mem matrix = clCreateBuffer(context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR,
								   N * N * sizeof(float), at, &status);
	cl_mem RVector = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR,
									N * sizeof(float), p, &status);
	cl_mem output = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR,
								   N * sizeof(float), p_new, &status);
	cl_mem errorArray = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,
									   N * sizeof(float), error, &status);
	cl_mem *P_RVector = &RVector;
	cl_mem *P_output = &output;
	while (looping)
	{

		clSetKernelArg(kernel[0], 0, sizeof(cl_mem), &matrix);
		clSetKernelArg(kernel[0], 1, sizeof(cl_mem), P_RVector);
		clSetKernelArg(kernel[0], 2, sizeof(cl_mem), P_output);
		clSetKernelArg(kernel[0], 3, sizeof(cl_mem), &errorArray);
		clSetKernelArg(kernel[0], 4, sizeof(cl_int), &N);

		clEnqueueNDRangeKernel(queue[0], kernel[0], 1, NULL, &global_work_size, NULL, 0, NULL, NULL);
		//         clFinish(queue[0]);

		float *mapErr = (float *)clEnqueueMapBuffer(queue[0], errorArray, true, CL_MAP_READ, 0,
													sizeof(float) * N, 0, NULL, NULL, &status);
		float errorSum = 0.0;
		for (i = 0; i < N; i++)
		{
			errorSum += mapErr[i];
		}
		clEnqueueUnmapMemObject(queue[0], errorArray, (void *)mapErr, 0, NULL, NULL);
		cout << "Error is " << errorSum << endl;

		//if two consecutive instances of pagerank vector are almost identical, stop
		if (errorSum < 0.000001)
		{
			clEnqueueReadBuffer(queue[0], output, CL_TRUE, 0, N * sizeof(float), p_new, 0, NULL, NULL);
			for (i = 0; i < N; i++)
			{
				output_rank[i] = p_new[i];
			}
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
