#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <iostream>
#include "pagerank.hh"

/* sequential implementation of the PageRank algorithm */

int baseline(vector<Edge> &edges, const int N, float *output_rank)
{

	// Set the damping factor 'd'
	float d = DAMPING_FACTOR;
    
    // Initialize a
	float **a = (float **)malloc(sizeof(float *) * N);
	int i, j, node1, node2;

	// Preallocate the adjacency matrix 'a'
	for (i = 0; i < N; i++)
	{
		a[i] = (float *)malloc(sizeof(float) * N);
	}

	// Initialize all the adjacency matrix to 0.0
	for (i = 0; i < N; i++)
	{
		for (j = 0; j < N; j++)
		{
			a[i][j] = 0.0;
		}
	}

	// Update the matrix to 1.0 if there's an edge between nodes
	for (int i = 0; i < edges.size(); ++i)
	{
		a[edges[i].src][edges[i].dest] = 1;
	}
    
	// Initialize the stochastic matrix
	float **at = (float **)malloc(sizeof(float *) * N);

	// Preallocate space for the transposed matrix 'at'
	for (i = 0; i < N; i++)
	{
		at[i] = (float *)malloc(sizeof(float) * N);
	}

	// Initialize the stochastic matrix to 0.0
	for (i = 0; i < N; i++)
	{
		for (j = 0; j < N; j++)
		{
			at[i][j] = 0.0;
		}
	}

	// Initialize the p[] vector
	float p[N];
    
	// Initialize the p[] vector
	for (i = 0; i < N; i++)
	{
		p[i] = 1.0 / N;
	}

	// Initialize the output link 
	int out_link[N];

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

	// Make the stochastic matrix 
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

	// Transpose the matrix
	for (i = 0; i < N; i++)
	{
		for (j = 0; j < N; j++)
		{
			at[j][i] = a[i][j];
		}
	}

	// Set the looping condition and the number of iterations 'k'
	int looping = 1;
	int k = 0;

	// Initialize new p vector
	float p_new[N];

	while (looping)
	{

		// Initialize p_new as a vector of n 0.0 cells
		for (i = 0; i < N; i++)
		{
			p_new[i] = 0.0;
		}

		// Update p_new (without using the damping factor)
		for (i = 0; i < N; i++)
		{
			for (j = 0; j < N; j++)
			{
				p_new[i] = p_new[i] + (at[i][j] * p[j]);
			}
		}

		// Update p_new 
		for (i = 0; i < N; i++)
		{
			p_new[i] = d * p_new[i] + (1.0 - d) / N;
		}

		float error = 0.0;
		for (i = 0; i < N; i++)
		{
			error = error + fabs(p_new[i] - p[i]);
		}

		std::cout << "Error is: " << error << endl;
		//if two consecutive instances of pagerank vector are almost identical, stop
		if (error < DIFF_ERROR)
		{
			looping = 0;
		}

		// Update p[]
		for (i = 0; i < N; i++)
		{
			p[i] = p_new[i];
		}

		// Increase the number of iterations
		k = k + 1;
	}

	for (i = 0; i < N; i++)
	{
		output_rank[i] = p[i];
	}

	/*************************** CONCLUSIONS *******************************/
	// Print results
	// printf ("\nNumber of iteration to converge: %d \n\n", k);
	// printf ("Final Pagerank values:\n\n[");
	// for (i=0; i<N; i++){
	// 	std::cout << " " << p[i];
	// 	if(i!=(N-1)){ std::cout << ", "; }
	// }
	// printf("]\n\n");
	return 0;
}
