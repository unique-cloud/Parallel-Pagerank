#ifndef COMMON_H
#define COMMON_H

#include <string>

#ifdef __APPLE__
#include <OpenCL/opencl.h>
#else
#include <CL/cl.h>
#endif

#include "AOCL_Utils.h"

using namespace aocl_utils;

// OpenCL runtime configuration
extern unsigned num_devices;
extern scoped_array<cl_device_id> device;
extern cl_context context;
extern scoped_array<cl_command_queue> queue;
extern cl_program program;
extern scoped_array<cl_kernel> kernel;
extern cl_int status;

typedef struct {
    int dest;
    float val;
} Msg;

typedef struct {
    int src;
    int dest;
} Edge;


bool init_opencl(std::string kernel_name);
void cleanup();

#endif
