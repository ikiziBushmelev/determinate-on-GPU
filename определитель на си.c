#include <time.h>
#include <stdio.h>
#include <stdlib.h>



void determinant(double** matrix, int N)
{
    for (int k = 0; k < N; k++)
    {
        for (int i = k + 1; i < N; i++)
        {
            double mu = matrix[i][k] / matrix[k][k];
            for (int j = 0; j < N; j++)
                matrix[i][j] -= matrix[k][j] * mu;
        }
    }
}
void filling_the_matrix(double** matrix,int N)
{
    srand(time(NULL));
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            matrix[i][j] = 1 + rand() % 9;
        }
    }
}

void matrix_output(double** matrix, int N)
{
    printf("\n");
    
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            printf("%0.2f ", matrix[i][j]);
            if (j==N-1) printf("\n");
        }
    }
    printf("\n");
}
int main()
{
    int N;
    printf("Input size of matrix N = ");
    scanf("%i", &N);

    

    double** input_matrix = NULL;
    input_matrix = (double**)malloc(N * sizeof(double*));
    for (int i = 0; i < N; ++i)
    {
        input_matrix[i] = (double*)malloc(N * sizeof(double));
    }
    filling_the_matrix(input_matrix,N);
    matrix_output(input_matrix,N);
    int time_start = clock();
    determinant(input_matrix, N);
    matrix_output(input_matrix,N);

   
    
}

