//
//  Render.cpp
//  Painters Lesson
//
//  Created by Nikhil Mehta on 18/08/2013.
//  Copyright (c) 2013 Nikhil Mehta. All rights reserved.
//

#include "Render.h"
#define PI	 3.1415926535897932384626433832795

static GLfloat red_colour[] 	= { 1.0, 0.0, 0.0 };
static GLfloat green_colour[] 	= { 0.0, 1.0, 0.0 };
static GLfloat blue_colour[] 	= { 0.0, 0.0, 1.0 };

void Render::initialize(GLuint positionSlot, GLuint colorSlot, GLuint projectionUniform, GLuint modelViewUniform){
    
    Render_PositionSlot = positionSlot;
    Render_ColorSlot = colorSlot;
    Render_ProjectionUniform = projectionUniform;
    Render_ModelViewUniform = modelViewUniform;
    
    gldLoadIdentity(projectionMatrix);
    gldLoadIdentity(modelViewMatrix);
    
    gldOrthof(projectionMatrix, -10.0, 10.0, -10.0, 10.0, 0.0001, 100000.0);
    gldTranslatef(modelViewMatrix, 0, 0, -20.0);
    
    glUniformMatrix4fv(Render_ProjectionUniform, 1, 0, projectionMatrix);
    glUniformMatrix4fv(Render_ModelViewUniform, 1, 0, modelViewMatrix);
    
}

void Render::drawCone(GLfloat radius, GLfloat height, GLint slices, float axisColor){
    
    
    Vertex coneVertices[slices+1];
    
    coneVertices[slices] = {{ 0.0, 0.0, -height}, { 1.0, 1.0, 1.0, 1.0}};
    
    for (int i = 0; i < slices; i++) {
        coneVertices[i] = {{ radius * cosf(i * 2 * PI/slices), radius * sinf(i * 2 * PI/slices), 0.0}, {axisColor, axisColor, axisColor, axisColor}};
    }
    
    GLubyte IndicesCone[slices * 3];
    
    for (int i = 0; i < slices * 3; i += 3) {
        if(i == 3 * (slices-1)){
            IndicesCone[i] = slices - 1;
            IndicesCone[i+1] = 0;
            IndicesCone[i+2] = slices;
            
        }else{
            IndicesCone[i] = i/3;
            IndicesCone[i+1] = i/3+1;
            IndicesCone[i+2] = slices;
        }
    }
    
    GLuint  vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(coneVertices), coneVertices, GL_STATIC_DRAW);
    
    GLuint indexBuffer;
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(IndicesCone), IndicesCone, GL_STATIC_DRAW);
    
    glVertexAttribPointer(Render_PositionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(Render_ColorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float)*3));
    
    glDrawElements(GL_TRIANGLES, sizeof(IndicesCone)/sizeof(IndicesCone[0]), GL_UNSIGNED_BYTE, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

void Render::drawAxis(int nGridLines, bool backColor){
    
    
    const GLubyte IndicesAxis[] = {
        0,1
    };
    
    float colorAxis = 1.0 - (float)backColor;
    
    const Vertex xAxisVertices[] = {
        {{0.0, 0.0, 0.0}, {1.0, 1.0, 1.0, 1.0}},
        {{static_cast<float>((nGridLines + 1.0)), 0.0, 0.0}, {colorAxis, colorAxis, colorAxis, colorAxis}}
    };
    
    
    const Vertex yAxisVertices[] = {
        {{0.0, 0.0, 0.0}, {1.0, 1.0, 1.0, 1.0}},
        {{0.0, static_cast<float>((nGridLines + 1.0)), 0.0}, {colorAxis, colorAxis, colorAxis, colorAxis}}
    };
    
    
    
    const Vertex zAxisVertices[] = {
        {{0.0, 0.0, 0.0}, {1.0, 1.0, 1.0, 1.0}},
        {{0.0, 0.0, static_cast<float>((nGridLines + 1.0))}, {colorAxis, colorAxis, colorAxis, colorAxis}}
    };
    
    
    GLuint  vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(xAxisVertices), xAxisVertices, GL_STATIC_DRAW);
    
    GLuint indexBuffer;
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(IndicesAxis), IndicesAxis, GL_STATIC_DRAW);
    
    glVertexAttribPointer(Render_PositionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(Render_ColorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float)*3));
    
    glDrawElements(GL_LINES, sizeof(IndicesAxis)/sizeof(IndicesAxis[0]), GL_UNSIGNED_BYTE, 0);
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(yAxisVertices), yAxisVertices, GL_STATIC_DRAW);
    glDrawElements(GL_LINES, sizeof(IndicesAxis)/sizeof(IndicesAxis[0]), GL_UNSIGNED_BYTE, 0);
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(zAxisVertices), zAxisVertices, GL_STATIC_DRAW);
    glDrawElements(GL_LINES, sizeof(IndicesAxis)/sizeof(IndicesAxis[0]), GL_UNSIGNED_BYTE, 0);
    
    
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    
    float tempMat[MAT_SIZE];
    
    //Format equivalent to OpenGl
    
    gldCopy(tempMat, modelViewMatrix);
    gldTranslatef(tempMat, nGridLines+1.0, 0.0,  0.0);
    gldRotatef(tempMat, 90, 0, 1, 0);
    glUniformMatrix4fv(Render_ModelViewUniform, 1, 0, tempMat);
    drawCone(0.02*nGridLines, 0.1*nGridLines, 10, colorAxis);
    
    gldCopy(tempMat, modelViewMatrix);
    gldTranslatef(tempMat, 0.0, nGridLines + 1, 0.0);
    gldRotatef(tempMat, -90, 1, 0, 0);
    glUniformMatrix4fv(Render_ModelViewUniform, 1, 0, tempMat);
    drawCone(0.02*nGridLines, 0.1*nGridLines, 10, colorAxis);
    
    gldCopy(tempMat, modelViewMatrix);
    gldTranslatef(tempMat, 0.0, 0.0, nGridLines + 1);
    gldRotatef(tempMat, 180, 1, 0, 0);
    glUniformMatrix4fv(Render_ModelViewUniform, 1, 0, tempMat);
    drawCone(0.02*nGridLines, 0.1*nGridLines, 10, colorAxis);
    

}

void Render::drawGrid(int nGridLines){
    
    int x,y;
    
    glUniformMatrix4fv(Render_ModelViewUniform, 1, 0, modelViewMatrix);
    
    const GLubyte IndicesGridLines[] = {
        0,1
    };
    
    GLuint  vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    
    GLuint indexBuffer;
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(IndicesGridLines), IndicesGridLines, GL_STATIC_DRAW);
    
    for(x = -nGridLines; x <= nGridLines; x++){
        if(x % 5)
            glLineWidth(1.0);
        else
            glLineWidth(4.0);
        
        Vertex lineAlongX[] = {
            {{ static_cast<float>(x), static_cast<float>(-nGridLines), 0},{ 0.3, 0.3, 0.3, 1.0}},
            {{static_cast<float>(x), static_cast<float>(nGridLines), 0},{ 0.3, 0.3, 0.3, 1.0}}
        };
        
        glBufferData(GL_ARRAY_BUFFER, sizeof(lineAlongX), lineAlongX, GL_STATIC_DRAW);
        
        
        glVertexAttribPointer(Render_PositionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
        glVertexAttribPointer(Render_ColorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float)*3));
    
        glDrawElements(GL_LINES, sizeof(IndicesGridLines)/sizeof((IndicesGridLines[0])), GL_UNSIGNED_BYTE, 0);
        
    }
    
    for(y = -nGridLines; y <= nGridLines; y++){
        if(y % 5)
            glLineWidth(1.0);
        else
            glLineWidth(4.0);
        
        Vertex lineAlongY[] = {
            {{static_cast<float>(-nGridLines), static_cast<float>(y), 0},{ 0.3, 0.3, 0.3, 1.0}},
            {{static_cast<float>(nGridLines), static_cast<float>(y), 0},{ 0.3, 0.3, 0.3, 1.0}}
        };
        
        glBufferData(GL_ARRAY_BUFFER, sizeof(lineAlongY), lineAlongY, GL_STATIC_DRAW);
        
        
        glVertexAttribPointer(Render_PositionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
        glVertexAttribPointer(Render_ColorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float)*3));
        
        glDrawElements(GL_LINES, sizeof(IndicesGridLines)/sizeof((IndicesGridLines[0])), GL_UNSIGNED_BYTE, 0);
        
    }
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    
}

void Render::drawSlantedTriangle(GLfloat color[4]){
    
    Vertex slantedTriangleVertices[] {
        {{2.0, -1.5, 2.0},{color[0],color[1],color[2],color[3]}},
        {{-1.0, 1.0, 6.0},{color[0],color[1],color[2],color[3]}},
        {{1.0, 2.0, 4.0},{color[0],color[1],color[2],color[3]}}
    };
    
    const GLubyte IndicesGridLines[] = {
        0,1,2
    };
    
    GLuint  vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(slantedTriangleVertices), slantedTriangleVertices, GL_STATIC_DRAW);
    
    GLuint indexBuffer;
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(IndicesGridLines), IndicesGridLines, GL_STATIC_DRAW);
    
    glVertexAttribPointer(Render_PositionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(Render_ColorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float)*3));
    
    glDrawElements(GL_TRIANGLES, sizeof(IndicesGridLines)/sizeof((IndicesGridLines[0])), GL_UNSIGNED_BYTE, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    
}

void Render::renderSlantedTriangles(){
    
    float tempMat[MAT_SIZE];
    
    gldCopy(tempMat, modelViewMatrix);
    glUniformMatrix4fv(Render_ModelViewUniform, 1, 0, tempMat);
    
    drawSlantedTriangle(red_colour);
    
    gldRotatef(tempMat, 120.0, 0.0, 0.0, 1.0);
    glUniformMatrix4fv(Render_ModelViewUniform, 1, 0, tempMat);
    drawSlantedTriangle(blue_colour);
    
    gldRotatef(tempMat, 120.0, 0.0, 0.0, 1.0);
    glUniformMatrix4fv(Render_ModelViewUniform, 1, 0, tempMat);
    drawSlantedTriangle(green_colour);
    
    gldRotatef(tempMat,120.0, 0.0, 0.0, 1.0);
    glUniformMatrix4fv(Render_ModelViewUniform, 1, 0, tempMat);
    
}

void Render::drawProjectedTriangle(GLfloat* color){
    
    
    Vertex slantedTriangleVertices[] {
        {{2.0, -1.5, 0.0},{color[0],color[1],color[2],color[3]}},
        {{-1.0, 1.0, 0.0},{color[0],color[1],color[2],color[3]}},
        {{1.0, 2.0, 0.0},{color[0],color[1],color[2],color[3]}}
    };
    
    const GLubyte IndicesGridLines[] = {
        0,1,2
    };
    
    GLuint  vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(slantedTriangleVertices), slantedTriangleVertices, GL_STATIC_DRAW);
    
    GLuint indexBuffer;
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(IndicesGridLines), IndicesGridLines, GL_STATIC_DRAW);
    
    glVertexAttribPointer(Render_PositionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(Render_ColorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float)*3));
    
    glDrawElements(GL_TRIANGLES, sizeof(IndicesGridLines)/sizeof((IndicesGridLines[0])), GL_UNSIGNED_BYTE, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
        
}

void Render::renderProjectedTriangles(){
    
    float tempMat[MAT_SIZE];
    
    gldCopy(tempMat, modelViewMatrix);
    glUniformMatrix4fv(Render_ModelViewUniform, 1, 0, tempMat);
    
    drawProjectedTriangle(red_colour);
    
    gldRotatef(tempMat, 120.0, 0.0, 0.0, 1.0);
    glUniformMatrix4fv(Render_ModelViewUniform, 1, 0, tempMat);
    drawProjectedTriangle(blue_colour);
    
    gldRotatef(tempMat, 120.0, 0.0, 0.0, 1.0);
    glUniformMatrix4fv(Render_ModelViewUniform, 1, 0, tempMat);
    drawProjectedTriangle(green_colour);
    
}

void Render::updateRotationArc(GLKQuaternion _quat){
    GLKMatrix4 rotation = GLKMatrix4MakeWithQuaternion(_quat);
    gldMultMatrix(modelViewMatrix, rotation.m);
    glUniformMatrix4fv(Render_ModelViewUniform, 1, 0, modelViewMatrix);

}