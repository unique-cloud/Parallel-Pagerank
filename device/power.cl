#define DUMP_FACTOR (0.85)

typedef struct __attribute__ ((packed)) {
	int row;
	int column;
	float value;
} Element;

__kernel void fpgasort(__global Element *p_matrix, __global float *rank,
                       __global float *output, __global float *error, 
                       float sink_value, int num_edges) 
{
    
    // get index of the work item
    int idx = get_global_id(0);
    int N = get_global_size(0);

    float score = 0.0;
    for(int i = 0; i < num_edges; ++i) 
    {
        Element ele = p_matrix[i];
        if(ele.column == idx)
            score += (ele.value * rank[ele.row]);  
    }

    score += sink_value;
    score *= DUMP_FACTOR;
    score += (1 - DUMP_FACTOR) / N;
    
    error[idx] = fabs(score - rank[idx]);
    output[idx] = score;
}
