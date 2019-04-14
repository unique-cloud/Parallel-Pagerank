#include "common.hh"

// OpenCL runtime configuration
unsigned num_devices = 0;
scoped_array<cl_device_id> device;
cl_context context = NULL;
scoped_array<cl_command_queue> queue;
cl_program program = NULL;
scoped_array<cl_kernel> kernel;
cl_int status;

// Initializes the OpenCL objects.
bool init_opencl(std::string kernel_name)
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
    if (num_platforms_available == 0)
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

    // Create the program for all device. Use the first device as the
    // representative device (assuming all device are of the same type).

    // Read the file in from source
    FILE *program_handle = fopen(kernel_name.c_str(), "r");
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
    if (status == CL_BUILD_PROGRAM_FAILURE)
    {
        // Determine the size of the log
        size_t log_size;
        clGetProgramBuildInfo(program, device[0], CL_PROGRAM_BUILD_LOG, 0, NULL, &log_size);

        // Allocate memory for the log
        char *log = (char *)malloc(log_size);

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