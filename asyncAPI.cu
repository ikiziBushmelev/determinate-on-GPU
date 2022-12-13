#ifndef CUDACC
#define CUDACC
#endif
#include <cuda.h>
#include <device_functions.h>
#include <cuda_runtime_api.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <cuda.h>
#include <curand_kernel.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <random>
#include <conio.h>


//blockDim - ������ �����
//blockIdx - ������ �������� �����
//threadIdx - ������ ������� ���� � �����


__global__ void test(double* arr, int N)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    int j;
    double kof;
    for (j = 0; j < N; j++)
    {
        if (i >= j && i < N - 1)
        {
            kof = arr[(i + 1) * N + j] / arr[j * N + j];
            int g = blockIdx.y * blockDim.y + threadIdx.y;
            //printf("g = %d i = %d j = %d  kof = %.6f\n", g, i, j, kof);
            //__syncthreads();

            if (g < N)
            {
                arr[(i + 1) * N + g] -= kof * arr[j * N + g];
                //printf("g posle = %d\n", g);
                printf(".");
            }

        }
        // __syncthreads();
    }
    // arr[0] = 10;
}

__host__ int main()
{
    int N;
    printf("Enrer size of matrix N = ");
    scanf_s("%i", &N);
    int SizeMatr = N * N;//������ �������
    int SizeInByte = SizeMatr * sizeof(double);//������, ����������� ��� ������� �� GPU 
    double* pMatr = new double[SizeMatr];//�������� ������ ��� ������

    //��������� ������� ���������� ������� � ������� 
    srand(time(NULL));
    for (int i = 0; i < SizeMatr; i++)
    {
        pMatr[i] = 1 + rand() % 9;
    }
    pMatr[0] = 8;
    pMatr[1] = 6;
    pMatr[2] = 6;
    pMatr[3] = 8;
    pMatr[4] = 1;
    pMatr[5] = 9;
    pMatr[6] = 8;
    pMatr[7] = 5;
    pMatr[8] = 3;
    printf("\n");
    for (int i = 0; i < SizeMatr; i++)
    {
        printf("%0.2f ", pMatr[i]);
        if (((i + 1) % N == 0) && (i != 0)) printf("\n");
    }
    printf("\n");


    double* pMatr_GPU;

    cudaMalloc((void**)&pMatr_GPU, SizeInByte);//�������� ������ ��� ������ �� GPU
    cudaMemcpy(pMatr_GPU, pMatr, SizeInByte, cudaMemcpyHostToDevice);//�������� �������� ������� �� GPU 

    dim3 gridSize = dim3(N, N, 1);//����������� ����� ������ (dim3), ���������� ��� ��������
    dim3 blockSize = dim3(1, 1, 1);//������ ����� (dim3), ����������� ��� ��������


    test << < gridSize, blockSize >> > (pMatr_GPU, N); // ����� ������� ��� ��������� ������� 

    cudaThreadSynchronize();//�������������� ������
    cudaMemcpy(pMatr, pMatr_GPU, SizeInByte, cudaMemcpyDeviceToHost);//�������� ����� ������� � GPU ������� �� CPU
    printf("\n");
    for (int i = 0; i < SizeMatr; i++)  //������� ���������� �������
    {
        printf("%0.2f ", pMatr[i]);
        if (((i + 1) % N == 0) && (i != 0)) printf("\n");
    }
    printf("\n");

    return 0;
}
