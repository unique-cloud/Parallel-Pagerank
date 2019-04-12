#define DUMP_FACTOR 0.85

__kernel void fpgasort(__global float **a, __global float *p,
                         __global float *output, __global float *error, int N) 
{
    // get index of the work item
    int index = get_global_id(0);

    float *temp = a[index];
    float score = 0;
    for(int i = 0; i < N; i++) {    
        score += temp[i] * p[i];
        
    }
    score *=  DUMP_FACTOR;
    score += (1 - DUMP_FACTOR) / N;
    output[index] = score;

    error[index] = fabs(score - p[index]);

}

