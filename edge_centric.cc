#include "pagerank.hh"
#include "Edge.hh"
#include "CL/opencl.h"
#include "AOCL_Utils.h"
// #include "custom.hh"

using namespace aocl_utils;
using namespace std;

// OpenCL runtime configuration
unsigned num_devices = 0;
scoped_array<cl_device_id> device;
cl_context context = NULL;
scoped_array<cl_command_queue> queue;
cl_program program = NULL;
scoped_array<cl_kernel> kernel;
cl_int status;

bool init_opencl();
void cleanup();

int edge_centric(vector<Edge* >edges, const int N)
{
    // Create necessary array
    int num_edges = edges.size();
    int *src_arr = new int[num_edges];
    int *dest_arr = new int[num_edges];
    int *outCount_arr = new int[N]{0};
    float *msg_arr = new float[N];
    float *msg_arr_pre = new float[N];
    float *err_arr = new float[N];

    for (int i = 0; i < edges.size(); ++i)
    {
        src_arr[i] = edges[i]->src;
        dest_arr[i] = edges[i]->dest;
        outCount_arr[edges[i]->src]++;
    }

    // Initialize message array
    for (int j = 0; j < N; ++j)
        msg_arr[j] = 1 / N;
    for (int j = 0; j < N; ++j)
        msg_arr_pre[j] = 0;

    init_opencl();
    // Allocate buffer on device and migrate data
    cl_mem srcBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,
                                      num_edges * sizeof(int), src_arr, &status);
    cl_mem destBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,
                                       num_edges * sizeof(int), dest_arr, &status);
    cl_mem outCountBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,
                                           N * sizeof(int), outCount_arr, &status);
    cl_mem msgBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,
                                      N * sizeof(float), msg_arr, &status);
    cl_mem msgBuffer_pre = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,
                                          N * sizeof(float), msg_arr, &status);
    cl_mem errBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,
				       N * sizeof(float), err_arr, &status);

    size_t global_size = 0;
    cl_mem *pMsgBuffer = &msgBuffer;
    cl_mem *pMsgBuffer_pre = &msgBuffer_pre;
    int error;
	
    do
    {
 	// Swap msgBuffer
	cl_mem *temp = pMsgBuffer;
        pMsgBuffer = pMsgBuffer_pre;
        pMsgBuffer_pre = temp;

        clSetKernelArg(kernel[0], 0, sizeof(cl_mem), (void *)&srcBuffer);
        clSetKernelArg(kernel[0], 1, sizeof(cl_mem), (void *)&destBuffer);
        clSetKernelArg(kernel[0], 2, sizeof(cl_mem), (void *)&outCountBuffer);
        clSetKernelArg(kernel[0], 3, sizeof(cl_mem), (void *)pMsgBuffer);
        clSetKernelArg(kernel[0], 4, sizeof(cl_mem), (void *)pMsgBuffer_pre);
        clSetKernelArg(kernel[0], 5, sizeof(int), (void *)&N);
        global_size = num_edges;

        clEnqueueNDRangeKernel(queue[0], kernel[0], 1, NULL,
                               &global_size, NULL, 0, NULL, NULL);
        clFinish(queue[0]);

        clSetKernelArg(kernel[1], 0, sizeof(cl_mem), (void *)pMsgBuffer);
        clSetKernelArg(kernel[1], 1, sizeof(cl_mem), (void *)pMsgBuffer_pre);
        clSetKernelArg(kernel[1], 2, sizeof(int), (void *)&errBuffer);
        clSetKernelArg(kernel[1], 3, sizeof(int), (void *)&N);
        global_size = N;

        clEnqueueNDRangeKernel(queue[0], kernel[1], 1, NULL,
                               &global_size, NULL, 0, NULL, NULL);
        clFinish(queue[0]);

	// Caculate error
        clEnqueueMapBuffer(queue[0], errBuffer, true, CL_MAP_READ, 0,
                           sizeof(float) * N, 0, NULL, NULL, &status);
	clFinish(queue[0]);

        error = 0;
        for(int i = 0; i < N; ++i)
	{
	    error += err_arr[i];
	}
    } while(error < 0.000001);

    clEnqueueMapBuffer(queue[0], msgBuffer, true, CL_MAP_READ, 0,
                       sizeof(float) * N, 0, NULL, NULL, &status);

    return 0;
}

// Initializes the OpenCL objects.
bool init_opencl()
{
    // printf("Initializing OpenCL\n");

    if (!setCwdToExeDir())
    {
        return false;
    }

    cl_uint num_platforms_available;
    // Get the number of OpenCL capable platforms avaiable
    status = clGetPlatformIDs(0, NULL, &num_platforms_available);
    checkError(status, "Failed to get platform");
    if(num_platforms_available == 0)
    {
        printf("No OpenCL capable platforms found!\n");
        exit(EXIT_FAILURE);
    }
    
    cl_platform_id cl_platforms[num_platforms_available];
    status = clGetPlatformIDs(num_platforms_available, cl_platforms, NULL);
    checkError(status, "Failed to get platform");
    
    // Query the available OpenCL device.
    device.reset(getDevices(cl_platforms[0], CL_DEVICE_TYPE_ALL, &num_devices));
    printf("Platform: %s\n", getPlatformName(cl_platforms[0]).c_str());
    printf("Using %d device(s)\n", num_devices);
    for (unsigned i = 0; i < num_devices; ++i)
    {
      printf("  %s\n", getDeviceName(device[i]).c_str());
    }

    // Create the context.
    context = clCreateContext(NULL, num_devices, device, NULL, NULL, &status);
    checkError(status, "Failed to create context");
    
    //

    // Create the program for all device. Use the first device as the
    // representative device (assuming all device are of the same type).

    // Read the file in from source
    FILE *program_handle = fopen("edge_centric.cl", "r");
    if (program_handle == NULL)
    {
        perror("Couldn't find the program file");
        exit(1);
    }
    fseek(program_handle, 0, SEEK_END);
    size_t program_size = ftell(program_handle);
    rewind(program_handle);
    char *program_buffer = (char *)malloc(program_size + 1);
    program_buffer[program_size] = '\0';
    fread(program_buffer, sizeof(char), program_size, program_handle);
    fclose(program_handle);

    // Create a program from the kernel source file
    program = clCreateProgramWithSource(context, 1, (const char **)&program_buffer, &program_size, &status);
    checkError(status, "Failed to create program");

    // Build the program that was just created.
    status = clBuildProgram(program, 0, NULL, "", NULL, NULL);
    // checkError(status, "Failed to build program");
    if (status == CL_BUILD_PROGRAM_FAILURE) {
    // Determine the size of the log
    size_t log_size;
    clGetProgramBuildInfo(program, device[0], CL_PROGRAM_BUILD_LOG, 0, NULL, &log_size);

    // Allocate memory for the log
    char *log = (char *) malloc(log_size);

    // Get the log
    clGetProgramBuildInfo(program, device[0], CL_PROGRAM_BUILD_LOG, log_size, log, NULL);

    // Print the log
    printf("%s\n", log);
}
    
    // Create per-device objects.
    queue.reset(num_devices);
    kernel.reset(num_devices);
    for (unsigned i = 0; i < num_devices; ++i)
    {
        // Command queue.
        queue[i] = clCreateCommandQueue(context, device[i], CL_QUEUE_PROFILING_ENABLE, &status);
        checkError(status, "Failed to create command queue");
    }

    // Kernel.
    const char *kernel_name1 = "scatter";
    kernel[0] = clCreateKernel(program, kernel_name1, &status);
    checkError(status, "Failed to create kernel");

    const char *kernel_name2 = "gather";
    kernel[1] = clCreateKernel(program, kernel_name2, &status);

    return true;
}

void cleanup()
{
    for (unsigned i = 0; i < num_devices; ++i)
    {
        if (kernel && kernel[i])
        {
            clReleaseKernel(kernel[i]);
        }
        if (queue && queue[i])
        {
            clReleaseCommandQueue(queue[i]);
        }
    }

    if (program)
    {
        clReleaseProgram(program);
    }
    if (context)
    {
        clReleaseContext(context);
    }
}
