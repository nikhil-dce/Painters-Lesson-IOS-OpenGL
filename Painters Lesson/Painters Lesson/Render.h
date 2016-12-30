//
//  Render.h
//  Painters Lesson
//
//  Created by Nikhil Mehta on 18/08/2013.
//  Copyright (c) 2013 Nikhil Mehta. All rights reserved.
//

#ifndef __Painters_Lesson__Render__
#define __Painters_Lesson__Render__
#define MAT_SIZE 16 //Defines the maximum size of an single Dimension Array.

#include <GLKit/GLKit.h>
#include <OpenGLES/ES2/gl.h>
#include "Vertex.h"
#include "Matrices.h"

class Render{
    
    GLuint Render_PositionSlot;                                             //Posiiton UInt from ViewController
    GLuint Render_ColorSlot;                                                //Color UInt from ViewController
    GLuint Render_ProjectionUniform;                                        //Projection UInt from ViewController
    GLuint Render_ModelViewUniform;                                         //ModelView UInt from ViewController
    
    GLfloat projectionMatrix[MAT_SIZE];                                     //ProjectionMatrix copied using Projection
    GLfloat modelViewMatrix[MAT_SIZE];                                      //ModelViewMatrix copied using ModelView
   
    
    void drawCone(GLfloat radius, GLfloat height, GLint slices, float axisColor);            //Draws a cone of given radius, height and number of slices
    void drawSlantedTriangle(GLfloat* color);                               //Draws a slanted triangle of given color
    void drawProjectedTriangle(GLfloat* color);                             //Draws a projected triangle of given color
    
    
    public :
   
        
    void initialize(GLuint positionSlot, GLuint colorSlot, GLuint projectionUniform, GLuint modelViewUniform);      //Initializes UInt Slots from ViewController
    
    void drawAxis(int nGridLines, bool baclColor);                                          //Draws Axis which has cone as an end object representing direction of that axis
    void drawGrid(int nGridLines);                                          //Draws Grid which are simple lines
    void renderSlantedTriangles();                                          //Draws Slanted Triangles after setting their modelView Matrix
    void renderProjectedTriangles();                                        //Draws projected Triangles after setting their modelViewTriangles
    void updateRotationArc(GLKQuaternion _quat);                            //Updates Rotation
};

#endif /* defined(__Painters_Lesson__Render__) */
