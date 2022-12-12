#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <cuda.h>
#include <curand_kernel.h>
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>

__global__ void test(double* arr, int N)
{
    double x = 10;
    arr[N] = x+5;
    arr[0] = x;
}

__host__ int main()
{
    int N;
    printf("Enrer size of matrix N = ");
    scanf_s("%i", &N);
    int SizeMatr = N * N;//Размер матрицы
    int SizeInByte = SizeMatr * sizeof(double);//Память, необходимая для массива на GPU 
    double* pMatr = new double[SizeMatr];//Выделяем память под массив

    //Заполняем матрицу случайными числами и выводим 
    srand(time(NULL));
    for (int i = 0; i < SizeMatr; i++)
    {
        pMatr[i] = 1 + rand() % 9;
    }
    printf("\n");
    for (int i = 0; i < SizeMatr; i++)
    {
        printf("%0.2f ", pMatr[i]);
        if (((i + 1) % N == 0) && (i != 0)) printf("\n");
    }
    printf("\n");


    double* pMatr_GPU;

    cudaMalloc((void**)&pMatr_GPU, SizeInByte);//Выделяем память под массив на GPU
    cudaMemcpy(pMatr_GPU, pMatr, SizeInByte, cudaMemcpyHostToDevice);//Копируем значения матрицы на GPU 

    dim3 gridSize = dim3(N, N, 1);//Размерность сетки блоков (dim3), выделенную для расчетов
    dim3 blockSize = dim3(1, 1, 1);//Размер блока (dim3), выделенного для расчетов

    
    test << < gridSize, blockSize >> > (pMatr_GPU, N); // тестовый вызов функции для изменения матрицы 

    cudaThreadSynchronize();//Синхронизируем потоки
    cudaMemcpy(pMatr, pMatr_GPU, SizeInByte, cudaMemcpyDeviceToHost);//Копируем новую матрицу с GPU обратно на CPU

    for (int i = 0; i < SizeMatr; i++)  //выводим измененную матрицу
    {
        printf("%0.2f ", pMatr[i]); 
        if (((i + 1) % N == 0) && (i != 0)) printf("\n");
    }
    printf("\n");
   
    return 0;
}
