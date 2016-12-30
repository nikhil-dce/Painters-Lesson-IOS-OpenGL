//
//  Matrices.h
//  Painters Lesson
//
//  Created by Nikhil Mehta on 19/08/2013.
//  Copyright (c) 2013 Nikhil Mehta. All rights reserved.
//

#ifndef __Painters_Lesson__Matrices__
#define __Painters_Lesson__Matrices__
#define MAT_SIZE 16

void gldLoadIdentity(float *m);
void gldMultMatrix(float *MatrixB,float MatrixA[MAT_SIZE]);
void gldPerspective(float *m, float fov, float aspect,float zNear, float zFar);
void gldTranslatef(float *m,float x,float y, float z);
void gldScalef(float *m,float x,float y, float z);
void gldRotatef(float *m, float a, float x,float y, float z);
void gldOrthof(float *m, float left, float right, float bottom, float top, float near, float far);
void gldCopy(float *m,float m2[MAT_SIZE]);

#endif /* defined(__Painters_Lesson__Matrices__) */
