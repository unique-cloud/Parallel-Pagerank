#define DUMP_FACTOR 0.85

__kernel void fpgasort(__global float *a, __global float *p,
                         __global float *output, __global float *error, int N) 
{
    
    // get index of the work item
    int index = get_global_id(0);
    
    int offset = index * N;

    float score = 0.0;
    for(int i = offset; i < offset + N; i++) {    
        score += a[i] * p[i - offset];
        
    }
    score *=  DUMP_FACTOR;
    score += (1 - DUMP_FACTOR) / N;
    output[index] = score;

    error[index] = fabs(score - p[index]);
    

}

