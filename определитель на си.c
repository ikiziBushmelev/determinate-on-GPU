#include <time.h>
#include <stdio.h>
#include <stdlib.h>




int main()
{
    int N;
    printf("Input size of matrix N = ");
    scanf("%i", &N);

    int time_start = clock();

    double** input_matrix = NULL;
    input_matrix = (double**)malloc(N * sizeof(double*));
    for (int i = 0; i < N; ++i)
    {
        input_matrix[i] = (double*)malloc(N * sizeof(double));
    }

    
    srand(time(NULL));
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            input_matrix[i][j] = 1 + rand() % 9;
        }
    }

    printf("\n");
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            printf("%0.2f ", input_matrix[i][j]);
            if (((j + 1) % N == 0) && (j != 0)) printf("\n");
        }
    }
    printf("\n");

   
    
}

