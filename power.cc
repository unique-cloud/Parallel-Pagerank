#include "pagerank.hh"
#include "Edge.hh"
// #include "CL/opencl.h"
// #include "AOCL_Utils.h"

// using namespace aocl_utils;
// using namespace std;

// // OpenCL runtime configuration
// cl_platform_id platform = NULL;
// unsigned num_devices = 0;
// scoped_array<cl_device_id> device;
// cl_context context = NULL;
// scoped_array<cl_command_queue> queue;
// cl_program program = NULL;
// scoped_array<cl_kernel> kernel;
// cl_int status;

// bool init_opencl();
// void cleanup();

int power(vector<Edge* >edges, const int N)
{
    
}
//     float d = 0.85;

//     float **a = (float **)malloc(sizeof(float *) * N);
// 	int i, j, node1, node2;
   
// 	for (i = 0; i < N; i++) {
// 	  	a[i] = (float *)malloc(sizeof(float) * N);
// 	}

// 	for(i = 0; i < N; i++){ 
//         for(j = 0; j < N; j++){ 
//         	a[i][j] = 0.0;
//         }
//     }

// 	// Update the matrix to 1.0 if there's an edge between nodes
//     for(auto &edge : edges)
//     {
//         a[edge->src][edge->dest] = 1;
//     }

// 	/********************** INITIALIZATION OF AT **************************/

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

// 	/********************** INITIALIZATION OF P **************************/

// 	float *p = new float[N];
	
// 	// Initialize the p[] vector
// 	for(i=0; i<N; i++) {
// 		p[i] = 1.0 / N;
// 	}

// 	/******************* INITIALIZATION OF OUTPUT LINK ********************/
	
// 	int *out_link = new int[N];

// 	// Initialize the output link vector
// 	for (i=0; i<N; i++) {
// 		out_link[i] = 0;
// 	}

// 	// Manage dangling nodes   
// 	for (i=0; i<N; i++) {
// 		for (j=0; j<N; j++) {
// 			if (a[i][j] != 0.0) {
// 				out_link[i] = out_link[i] + 1;
// 			}
// 		}
// 	}

// 	/*********************** MATRIX STOCHASTIC-FIED  ***********************/

// 	// Make the matrix stochastic
// 	for (i=0; i<N; i++){
// 		if (out_link[i] == 0){
// 			// Deal with dangling nodes
// 			for (j=0; j<N; j++){
// 				a[i][j] = 1.0 / N;
// 			}
// 		} else {
// 			for (j=0; j<N; j++){
// 				if (a[i][j] != 0) {
// 					a[i][j] = a[i][j] / out_link[i];
// 				}
// 			}
// 		}
// 	}

// 	/************************** MATRIX IS TRANSPOSED **********************/

// 	// Transpose the matrix 
// 	for (i=0; i<N; i++){
// 		for (j=0; j<N; j++){
// 			at[j][i] = a[i][j];
// 		}
// 	}
	
// 	/*************************** PageRank LOOP  **************************/

// 	// Set the looping condition and the number of iterations 'k'
// 	int looping = 1;

// 	// Initialize new p vector
//     float *p_new = new float[N];
//     for (i=0; i<N; i++){
// 		p_new[i] = 0.0;
//     }

//     float *error = (float*)malloc(sizeof(float) * N);
//     for(i=0; i<N; i++) {
//         error[i] = 0.0;
//     }

//     init_opencl()；

//     size_t global_work_size[1];
//     size_t local_work_size[1];

//     global_work_size[0] = N;
//     local_work_size[0] = 1;


//     // Use FPGA
//     cl_mem matrix = clCreateBuffer(context, CL_MEM_READ_WRITE , N * N * sizeof(float), NULL, &status);
// 	cl_mem RVector = clCreateBuffer(context, CL_MEM_READ_WRITE, N * sizeof(float), NULL, &status);
//     cl_mem output = clCreateBuffer(context, CL_MEM_READ_WRITE, N * sizeof(float), NULL, &status);
//     cl_mem errorArray = clCreateBuffer(context, CL_MEM_READ_WRITE, N * sizeof(float), NULL, &status);

// 	while (looping) {

//         clEnqueueWriteBuffer(queue[0], matrix, CL_FALSE, 0, N * N * sizeof(float), at, 0, NULL, NULL);
//         clEnqueueWriteBuffer(queue[0], RVector, CL_FALSE, 0, N * sizeof(float), p, 0, NULL, NULL);
//         clEnqueueWriteBuffer(queue[0], output, CL_FALSE, 0, N * sizeof(float), p_new, 0, NULL, NULL);
//         clEnqueueWriteBuffer(queue[0], errorArray, CL_FALSE, 0, N * sizeof(float), error, 0, NULL, NULL);

//         clSetKernelArg(kernel[0], 0, sizeof(cl_mem), &matrix);
//         clSetKernelArg(kernel[0], 1, sizeof(cl_mem), &RVector);
//         clSetKernelArg(kernel[0], 2, sizeof(cl_mem), &output);
//         clSetKernelArg(kernel[0], 3, sizeof(cl_mem), &errorArray);
//         clSetKernelArg(kernel[0], 4, sizeof(cl_int), &N);

//         clEnqueueNDRangeKernel(queue[0], kernel[0], 1, NULL, global_work_size, local_work_size, 0, NULL, NULL);
//         clFinish(queue[0]);
        
//         clEnqueueReadBuffer(queue[0], errorArray, CL_TRUE,0, N * sizeof(float), error, 0, NULL, NULL);

// 	    float errorSum = 0.0;
// 	    for(i=0; i<N; i++){
// 	        errorSum +=  errorSum + error[i];
// 	    }

// 	    //if two consecutive instances of pagerank vector are almost identical, stop
// 	    if (errorSum < 0.000001){
// 	        looping = 0;
//             clEnqueueReadBuffer(queue[0], output, CL_TRUE,0, N * sizeof(float), p_new, 0, NULL, NULL);
//             for (i=0; i<N;i++){
// 	    	    p[i] = p_new[i];
// 		    }
//             break;
// 	    } else {
//             cl_mem tmp = RVector;
//             RVector = output;
//             output = temp;
//         }

// 	}

//     return 0;
// }

// // Initializes the OpenCL objects.
// bool init_opencl()
// {
//     // printf("Initializing OpenCL\n");

//     if (!setCwdToExeDir())
//     {
//         return false;
//     }

//     // Query the available OpenCL device.
//     device.reset(getDevices(platform, CL_DEVICE_TYPE_ALL, &num_devices));
//     // printf("Platform: %s\n", getPlatformName(platform).c_str());
//     // printf("Using %d device(s)\n", num_devices);
//     // for (unsigned i = 0; i < num_devices; ++i)
//     // {
//     //   printf("  %s\n", getDeviceName(device[i]).c_str());
//     // }

//     // Create the context.
//     context = clCreateContext(NULL, num_devices, device, NULL, NULL, &status);
//     checkError(status, "Failed to create context");

//     // Create the program for all device. Use the first device as the
//     // representative device (assuming all device are of the same type).

//     // Read the file in from source
//     FILE *program_handle = fopen("power.cl", "r");
//     if (program_handle == NULL)
//     {
//         perror("Couldn't find the program file");
//         exit(1);
//     }
//     fseek(program_handle, 0, SEEK_END);
//     size_t program_size = ftell(program_handle);
//     rewind(program_handle);
//     char *program_buffer = (char *)malloc(program_size + 1);
//     program_buffer[program_size] = '\0';
//     fread(program_buffer, sizeof(char), program_size, program_handle);
//     fclose(program_handle);

//     // Create a program from the kernel source file
//     program = clCreateProgramWithSource(context, 1, (const char **)&program_buffer, &program_size, &status);
//     checkError(status, "Failed to create program");

//     // Build the program that was just created.
//     status = clBuildProgram(program, 0, NULL, "", NULL, NULL);
//     checkError(status, "Failed to build program");

//     // Create per-device objects.
//     queue.reset(num_devices);
//     kernel.reset(num_devices);
//     for (unsigned i = 0; i < num_devices; ++i)
//     {
//         // Command queue.
//         queue[i] = clCreateCommandQueue(context, device[i], CL_QUEUE_PROFILING_ENABLE, &status);
//         checkError(status, "Failed to create command queue");

//         // Kernel.
//         const char *kernel_name = "fpgasort";
//         kernel[i] = clCreateKernel(program, kernel_name, &status);
//         checkError(status, "Failed to create kernel");
//     }

//     return true;
// }

// void cleanup()
// {
//     for (unsigned i = 0; i < num_devices; ++i)
//     {
//         if (kernel && kernel[i])
//         {
//             clReleaseKernel(kernel[i]);
//         }
//         if (queue && queue[i])
//         {
//             clReleaseCommandQueue(queue[i]);
//         }
//     }

//     if (program)
//     {
//         clReleaseProgram(program);
//     }
//     if (context)
//     {
//         clReleaseContext(context);
//     }
// }
