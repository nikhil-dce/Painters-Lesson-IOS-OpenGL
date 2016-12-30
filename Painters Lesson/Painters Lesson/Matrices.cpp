//
//  Matrices.cpp
//  Painters Lesson
//
//  Created by Nikhil Mehta on 19/08/2013.
//  Copyright (c) 2013 Nikhil Mehta. All rights reserved.
//

#include "Matrices.h"

#define PI	 3.1415926535897932384626433832795
#define PI_OVER_180	 0.017453292519943295769236907684886
#define PI_OVER_360	 0.0087266462599716478846184538424431
#define MAT_SIZE 16

void gldMultMatrix(float *MatrixB,float MatrixA[MAT_SIZE])
{
    float NewMatrix[MAT_SIZE];
    int i;
    for(i = 0; i < 4; i++){ //Cycle through each vector of first matrix.
        NewMatrix[i*4] = MatrixA[i*4] * MatrixB[0] + MatrixA[i*4+1] * MatrixB[4] + MatrixA[i*4+2] * MatrixB[8] + MatrixA[i*4+3] * MatrixB[12];
        NewMatrix[i*4+1] = MatrixA[i*4] * MatrixB[1] + MatrixA[i*4+1] * MatrixB[5] + MatrixA[i*4+2] * MatrixB[9] + MatrixA[i*4+3] * MatrixB[13];
        NewMatrix[i*4+2] = MatrixA[i*4] * MatrixB[2] + MatrixA[i*4+1] * MatrixB[6] + MatrixA[i*4+2] * MatrixB[10] + MatrixA[i*4+3] * MatrixB[14];
        NewMatrix[i*4+3] = MatrixA[i*4] * MatrixB[3] + MatrixA[i*4+1] * MatrixB[7] + MatrixA[i*4+2] * MatrixB[11] + MatrixA[i*4+3] * MatrixB[15];
    }
    /*this should combine the matrixes*/
    
    memcpy(MatrixB,NewMatrix,64);
}

void gldLoadIdentity(float *m)
{
    m[0] = 1;
    m[1] = 0;
    m[2] = 0;
    m[3] = 0;
    
    m[4] = 0;
    m[5] = 1;
    m[6] = 0;
    m[7] = 0;
    
    m[8] = 0;
    m[9] = 0;
    m[10] = 1;
    m[11] = 0;
    
    m[12] = 0;
    m[13] = 0;
    m[14] = 0;
    m[15] = 1;
}

void gldPerspective(float *m, float fov, float aspect,float zNear, float zFar)
{
    const float h = 1.0f/tan(fov*PI_OVER_360);
    float neg_depth = zNear-zFar;
    
    float m2[MAT_SIZE] = {0};
    
    m2[0] = h / aspect;
    m2[1] = 0;
    m2[2] = 0;
    m2[3] = 0;
    
    m2[4] = 0;
    m2[5] = h;
    m2[6] = 0;
    m2[7] = 0;
    
    m2[8] = 0;
    m2[9] = 0;
    m2[10] = (zFar + zNear)/neg_depth;
    m2[11] = -1;
    
    m2[12] = 0;
    m2[13] = 0;
    m2[14] = 2.0f*(zNear*zFar)/neg_depth;
    m2[15] = 0;
    
    gldMultMatrix(m,m2);
}

void gldTranslatef(float *m,float x,float y, float z)
{
    float m2[MAT_SIZE] = {0};
    
    m2[0] = 1;
    m2[1] = 0;
    m2[2] = 0;
    m2[3] = 0;
    
    m2[4] = 0;
    m2[5] = 1;
    m2[6] = 0;
    m2[7] = 0;
    
    m2[8] = 0;
    m2[9] = 0;
    m2[10] = 1;
    m2[11] = 0;
    
    m2[12] = x;
    m2[13] = y;
    m2[14] = z;
    m2[15] = 1;
    
    gldMultMatrix(m,m2);
}

void gldScalef(float *m,float x,float y, float z)
{
    float m2[MAT_SIZE] = {0};
    
    m2[0] = x;
    m2[1] = 0;
    m2[2] = 0;
    m2[3] = 0;
    
    m2[4] = 0;
    m2[5] = y;
    m2[6] = 0;
    m2[7] = 0;
    
    m2[8] = 0;
    m2[9] = 0;
    m2[10] = z;
    m2[11] = 0;
    
    m2[12] = 0;
    m2[13] = 0;
    m2[14] = 0;
    m2[15] = 1;
    
    gldMultMatrix(m,m2);
}

void gldRotatef(float *m, float a, float x,float y, float z)
{
    float angle = a * PI_OVER_180;
    float m2[MAT_SIZE] = {0};
    
    m2[0] = 1+(1-cos(angle))*(x*x-1);
    m2[1] = -z*sin(angle)+(1-cos(angle))*x*y;
    m2[2] = y*sin(angle)+(1-cos(angle))*x*z;
    m2[3] = 0;
    
    m2[4] = z*sin(angle)+(1-cos(angle))*x*y;
    m2[5] = 1+(1-cos(angle))*(y*y-1);
    m2[6] = -x*sin(angle)+(1-cos(angle))*y*z;
    m2[7] = 0;
    
    m2[8] = -y*sin(angle)+(1-cos(angle))*x*z;
    m2[9] = x*sin(angle)+(1-cos(angle))*y*z;
    m2[10] = 1+(1-cos(angle))*(z*z-1);
    m2[11] = 0;
    
    m2[12] = 0;
    m2[13] = 0;
    m2[14] = 0;
    m2[15] = 1;
    
    gldMultMatrix(m,m2);
}

void gldOrthof(float *m, float left, float right, float bottom, float top, float near, float far){
    
    float m2[MAT_SIZE] = {0};
    
    m2[0] = 2.0/(right-left);
    m2[1] = 0;
    m2[2] = 0;
    m2[3] = 0;
    
    m2[4] = 0;
    m2[5] = 2.0/(top-bottom);
    m2[6] = 0;
    m2[7] = 0;
    
    m2[8] = 0;
    m2[9] = 0;
    m2[10] = -2.0/(far-near);
    m2[11] = 0;
    
    m2[12] = -(right+left)/(right-left);
    m2[13] = -(top+bottom)/(top-bottom);
    m2[14] = -(far+near)/(far-near);
    m2[15] = 1;
    
    gldMultMatrix(m,m2);
        
        
}

void gldCopy(float *m2,float m[MAT_SIZE]){
   
    
    m2[0] = m[0];
    m2[1] = m[1];
    m2[2] = m[2];
    m2[3] = m[3];
    
    m2[4] = m[4];
    m2[5] = m[5];
    m2[6] = m[6];
    m2[7] = m[7];
    
    m2[8] = m[8];
    m2[9] = m[9];
    m2[10] = m[10];
    m2[11] = m[11];
    
    m2[12] = m[12];
    m2[13] = m[13];
    m2[14] = m[14];
    m2[15] = m[15];
    
}