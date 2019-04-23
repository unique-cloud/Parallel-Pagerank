#ifndef COMMON_H
#define COMMON_H

#ifdef APPLE
#include <OpenCL/opencl.h>
#else
#include "CL/opencl.h"
#include "AOCL_Utils.h"

using namespace aocl_utils;
#endif
#include <string>

#define DIFF_ERROR (0.000001)
#define DAMPING_FACTOR (0.85)

// OpenCL runtime configuration
extern cl_platform_id platform;
extern unsigned num_devices;
extern scoped_array<cl_device_id> device;
extern cl_context context;
extern scoped_array<cl_command_queue> queue;
extern cl_program program;
extern scoped_array<cl_kernel> kernel;
extern cl_int status;

typedef struct __attribute__ ((packed)) {
    int dest;
    float val;
} Msg;

typedef struct __attribute__ ((packed)) {
    int src;
    int dest;
} Edge;

bool init_opencl(std::string cl_name);
void cleanup();

#endif
