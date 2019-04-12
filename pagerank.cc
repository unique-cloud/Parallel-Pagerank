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
    gettimeofday(&program_start, NULL);

    if (argc != 2)
    {
        fprintf(stderr, "Usage: %s mode\n", argv[0]);
        exit(EXIT_FAILURE);
    }
    mode = atoi(argv[1]);

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
        edge_centric();
        gettimeofday(&time_end, NULL);
        fprintf(stderr, "Using edge centric: ");
        break;
    case 3:
        gettimeofday(&time_start, NULL);
        edge_opt();
        gettimeofday(&time_end, NULL);
        fprintf(stderr, "Using optimized edge centric: ");
        break;
    case 10:
        // this is for test compling
        gettimeofday(&time_start, NULL);
        deviceInfoQuery();
        gettimeofday(&time_end, NULL);
        fprintf(stderr, "Querying device info: ");
        break;
    default:
        gettimeofday(&time_start, NULL);
        baseline();
        gettimeofday(&time_end, NULL);
        fprintf(stderr, "Using baseline: ");
        break;
    }
    fprintf(stderr, "%ld\n", ((time_end.tv_sec * 1000000 + time_end.tv_usec) - (time_start.tv_sec * 1000000 + time_start.tv_usec)));

    gettimeofday(&program_end, NULL);
    
    return 0;
}
