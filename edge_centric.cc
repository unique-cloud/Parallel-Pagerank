#include <string>
#include <iostream>
#include <fstream>
#include <vector>
#include "pagerank.hh"
#include "Edge.hh"
#include "CL/opencl.h"
#include "AOCL_Utils.h"

using namespace aocl_utils;
using namespace std;

// OpenCL runtime configuration
cl_platform_id platform = NULL;
unsigned num_devices = 0;
scoped_array<cl_device_id> device;
cl_context context = NULL;
scoped_array<cl_command_queue> queue;
cl_program program = NULL;
scoped_array<cl_kernel> kernel;
cl_int status;

bool init_opencl();
void cleanup();

int edge_centric()
{
    /************************************READ DATASET***********************************/
    // Open dataset
    string filename = "./hollins.dat";
    ifstream infile(filename, ios::in);
    if (!infile)
    {
        cerr << "Cannot open the file" << std::endl;
        exit(EXIT_FAILURE);
    }

    // Read the data set and get the number of nodes (n)
    int num_nodes = 0, num_edges = 0;
    char ch;
    string str;
    ch = infile.get();
    while (ch == '#')
    {
        getline(infile, str);
        sscanf(str.c_str(), "%*s %d %*s %d", &num_nodes, &num_edges);
        ch = infile.get();
    }
    infile.putback(ch);

    // DEBUG: Print the number of nodes
    cout << "Number of nodes = " << num_nodes << std::endl;
    cout << "Number of edges = " << num_edges << std::endl;

    // Read data
    std::vector<Edge *> edges;
    int vtx1, vtx2;
    while (!infile.eof())
    {
        getline(infile, str);
        if (str.empty())
            continue;

        sscanf(str.c_str(), "%d %d", &vtx1, &vtx2);
        Edge *e = new Edge(vtx1, vtx2);
        edges.push_back(e);
    }

    cout << "The total number of edges read in:" << edges.size() << endl;
    // cout<<"Now printing the edges: " <<endl;
    // for(auto &e : edges)
    // {
    //     std::cout << "edge " << e->src << " " << e->dest << std::endl;
    // }

    /****************************************PAGERANK******************************************/
    // Create necessary array
    int *src_arr = new int[num_edges];
    int *dest_arr = new int[num_edges];
    int *outCount_arr = new int[num_nodes]{0};
    float *msg_arr = new float[num_nodes];

    for (int i = 0; i < edges.size(); ++i)
    {
        src_arr[i] = edges[i]->src;
        dest_arr[i] = edges[i]->dest;
        outCount_arr[edges[i]->src]++;
    }

    // Initialize message array
    for (int j = 0; j < num_nodes; ++j)
        msg_arr[j] = 1 / num_nodes;

    init_opencl();
    // Allocate buffer on device and migrate data
    cl_mem srcBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,
                                      num_edges * sizeof(int), src_arr, &status);
    cl_mem destBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,
                                       num_edges * sizeof(int), dest_arr, &status);
    cl_mem outCountBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,
                                           num_nodes * sizeof(int), outCount_arr, &status);
    cl_mem msgBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,
                                      num_nodes * sizeof(float), msg_arr, &status);

    // // clSetKernelArg(kernel, 0, sizeof(cl_mem), (void *)&pInputBuffer);
    // size_t global_size = num_edges;
    // //         clEnqueueNDRangeKernel(queue, kernel, 1, NULL,
    // //                                &global_size, NULL, 0, NULL, NULL);
    // clFinish(queue);
    // size_t global_size = num_nodes;
    // //         clEnqueueNDRangeKernel(queue, kernel, 1, NULL,
    // //                                &global_size, NULL, 0, NULL, NULL);
    // clFinish(queue);

    // clEnqueueMapBuffer(queue, msgBuffer, true, CL_MAP_READ, 0,
    //                    sizeof(float) * num_nodes, 0, NULL, NULL, &status);

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

    // Query the available OpenCL device.
    device.reset(getDevices(platform, CL_DEVICE_TYPE_ALL, &num_devices));
    // printf("Platform: %s\n", getPlatformName(platform).c_str());
    // printf("Using %d device(s)\n", num_devices);
    // for (unsigned i = 0; i < num_devices; ++i)
    // {
    //   printf("  %s\n", getDeviceName(device[i]).c_str());
    // }

    // Create the context.
    context = clCreateContext(NULL, num_devices, device, NULL, NULL, &status);
    checkError(status, "Failed to create context");

    // Create the program for all device. Use the first device as the
    // representative device (assuming all device are of the same type).

    // Read the file in from source
    FILE *program_handle = fopen("fpgasort.cl", "r");
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
    checkError(status, "Failed to build program");

    // Create per-device objects.
    queue.reset(num_devices);
    kernel.reset(num_devices);
    for (unsigned i = 0; i < num_devices; ++i)
    {
        // Command queue.
        queue[i] = clCreateCommandQueue(context, device[i], CL_QUEUE_PROFILING_ENABLE, &status);
        checkError(status, "Failed to create command queue");

        // Kernel.
        const char *kernel_name = "fpgasort";
        kernel[i] = clCreateKernel(program, kernel_name, &status);
        checkError(status, "Failed to create kernel");
    }

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