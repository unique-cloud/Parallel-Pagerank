#ifndef COMMON_H
#define COMMON_H

#ifdef __APPLE__
#include <OpenCL/opencl.h>
#else
#include <CL/cl.h>
#endif
#include <string>
#include "AOCL_Utils.h"

#define DIFF_ERROR (0.000001)
#define DAMPING_FACTOR (0.85)

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

bool init_opencl(std::string cl_name);
void cleanup();

#endif
