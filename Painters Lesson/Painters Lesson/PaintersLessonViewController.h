//
//  PaintersLessonViewController.h
//  Painters Lesson
//
//  Created by Nikhil Mehta on 13/08/2013.
//  Copyright (c) 2013 Nikhil Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <QuartzCore/QuartzCore.h>
#include "Render.h"
#include "Vertex.h"

@interface PaintersLessonViewController : UIViewController{
    
    IBOutlet GLKView *EAGLView; //Canvas View where the scene is rendered
    
    IBOutlet UISwitch *AxesSwitch;                  //Switch which controls the display of Axis
    IBOutlet UISwitch *ColorSwitch;                 //Switch which controls the color of the background (Black/White)
    IBOutlet UISwitch *SlantedTrianglesSwitch;      //Switch which controls the display of Slanted Trianlges
    IBOutlet UISwitch *ProjectedTrianglesSwitch;    //Switch which controls the display of Projected Trianlges on the Grid
    
    IBOutlet UISlider *GridSizeSlider;              //Slider which controls the size of Grid
    

    EAGLContext *context;                           //Graphical Context owned by all Graphical Applications
    
    GLuint _positionSlot;                           //UInt variable which corresponds to the vec4 position in the vertext shader
    GLuint _colorSlot;                              //UInt variable which corresponds to the vec4 color in the vertext shader
    GLuint _projectionUniform;                      //UInt variable which corresponds to the mat4 Projection in the vertext shader
    GLuint _modelViewUniform;                       //UInt variable which corresponds to the mat4 ModelView in the vertext shader
    
    Render render;                                  //Programmer Defined instance of the class Render
    }

- (IBAction)AxesSwitch:(UISwitch* )sender;                  //Event Handler for AxisSwitch event: ValueChanged
- (IBAction)BackSwitch:(UISwitch* )sender;                  //Event Handler for BackColorSwitch event: ValueChanged
- (IBAction)SlantedTrianglesSwitch:(UISwitch* )sender;      //Event Handler for SlantedTrianglesSwitch event: ValueChanged
- (IBAction)ProjectedTrianglesSwitch:(UISwitch* )sender;    //Event Handler for ProjectedTrianglesSwitch event: ValueChanged
- (IBAction)GridSizeSlider:(UISlider* )sender;              //Event Handler for GridSizeSlider event: ValueChanged

- (void)setupDisplayLink;                                   //Sets the Display Link which calls the function render periodically
- (void)setupContext;                                       //Sets the EAGLContext, RenderBuffer and FrameBuffer
- (GLuint)compileShader: (NSString*)shaderName withType:(GLenum)shaderType;         //Function to compile individual shaders by the application
- (void)compileShaders;                                     //Function to link the program with the compiled shaders
- (void)render:(CADisplayLink*)displayLink ;                //Function to render the OpenGl Painters Lesson. Calls methods from Render.c
- (GLKVector3) projectOntoSurface:(GLKVector3) touchPoint;  //Projects the touched point(x,y) onto a sphere[Used in Arc Ball]

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;   //Called when the user begins touching EAGLView 



@end
