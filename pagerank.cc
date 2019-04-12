#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <float.h>
#include <sys/time.h>
#include "pagerank.hh"

int main(int argc, char **argv)
{
    // Create timers for each method
    struct timeval time_start, time_end, program_start, program_end;
    int mode = 0;
    FILE *fp;
    gettimeofday(&program_start, NULL);

    if (argc < 2)
    {
        fprintf(stderr, "Usage: %s input_file mode\n", argv[0]);
    }
    fp = fopen(argv[1], "rb");
    if (argc == 3)
        mode = atoi(argv[2]);

    if (fp == NULL)
    {
        fprintf(stderr, "Cannot open %s\n", argv[1]);
        exit(EXIT_FAILURE);
    }

    switch (mode)
    {
    case 1:
        gettimeofday(&time_start, NULL);
        power();
        gettimeofday(&time_end, NULL);
        fprintf(stderr, "Using power method: ");
        break;
    case 2:
        gettimeofday(&time_start, NULL);
        edge();
        gettimeofday(&time_end, NULL);
        fprintf(stderr, "Sorting on FPGA: ");
        break;
    case 3:
        gettimeofday(&time_start, NULL);
        edge_opt();
        gettimeofday(&time_end, NULL);
        fprintf(stderr, "Sorting using built-in quick sort: ");
        break;
    case 10:
        // this is for test compling
        gettimeofday(&time_start, NULL);
        deviceInfoQuery();
        gettimeofday(&time_end, NULL);
        fprintf(stderr, "Sorting using built-in quick sort: ");
        break;
    default:
        gettimeofday(&time_start, NULL);
        baseline();
        gettimeofday(&time_end, NULL);
        fprintf(stderr, "Sorting using built-in quick sort: ");
        break;
    }
    fprintf(stderr, "%ld\n", ((time_end.tv_sec * 1000000 + time_end.tv_usec) - (time_start.tv_sec * 1000000 + time_start.tv_usec)));

    gettimeofday(&program_end, NULL);
    
    return 0;
}
