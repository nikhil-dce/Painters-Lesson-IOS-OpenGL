//
//  PaintersLessonViewController.m
//  Painters Lesson
//
//  Created by Nikhil Mehta on 13/08/2013.
//  Copyright (c) 2013 Nikhil Mehta. All rights reserved.
//

#import "PaintersLessonViewController.h"


static int showAxis = TRUE;     //Initialize Switch Axis
static int showGrid = TRUE;     //Initialize Grid Slider
static int showSlantedTriangles = TRUE;     //Initialize Slanted Triangles Switch
static int showProjectedTriangles = TRUE;   //Initialize Projected Triangles Switch
static int nGridLines = 4;      //Initialize Grid Slider
static BOOL backColor = 0;      //Initialize Back Color to BLACK

static GLfloat black_color[] 	= { 0.0, 0.0, 0.0, 1.0};
static GLfloat white_color[] 	= { 1.0, 1.0, 1.0, 1.0};

@interface PaintersLessonViewController ()
{
GLKVector3 _anchor_position;        //Vector to initial touch position
GLKVector3 _current_position;       //Vector to current touch position

GLKQuaternion _quatStart;           //Initial Quaternion representing the initial rotation
GLKQuaternion _quat;                //Final Quaternion representing the final rotation
}
@end

@implementation PaintersLessonViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSLog(@"View Loaded");
          
    [self setupContext];
    [self compileShaders];
    [self setupDisplayLink];
    
    
}

- (void)setupContext{
    
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    if(!context || ![EAGLContext setCurrentContext:context]){
        
        NSLog(@"OpenGLES2 Not  Supported");
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        [EAGLContext setCurrentContext:context];
        
        
    }else
        NSLog(@"Context has been setup");
    
    GLuint framebuffer, renderbuffer, depthbuffer;
    
    glGenBuffers(1, &depthbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthbuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, EAGLView.frame.size.width, EAGLView.frame.size.height);
    
    glGenBuffers(1, &framebuffer);
    glGenBuffers(1, &renderbuffer);
    
    
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
    
    
    CAEAGLLayer *EAGLLayer = (CAEAGLLayer *) EAGLView.layer;
    EAGLLayer.opaque = YES;
    
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:EAGLLayer];

    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderbuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthbuffer);
    
    //Initializing the quaternions to (0,0,0,1)
    _quat = GLKQuaternionMake(0, 0, 0, 1);
    _quatStart = GLKQuaternionMake(0, 0, 0, 1);
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

- (void)setupDisplayLink{
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop: [NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
}

//**********************************************************************Renders Scene*****************************************************//


- (void)render:(CADisplayLink*)displayLink {
    
        
    if (backColor)
        glClearColor(white_color[0], white_color[1], white_color[2], white_color[3]);
    else
        glClearColor(black_color[0], black_color[1], black_color[2], black_color[3]);
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_NORMALIZE);
   
    //Render render(_positionSlot, _colorSlot, _projectionUniform, _modelViewUniform);
    
    glViewport(0, 0, EAGLView.frame.size.width, EAGLView.frame.size.height);
           
    if (showGrid) render.drawGrid(nGridLines);
    if (showAxis) render.drawAxis(nGridLines , backColor);
    if (showSlantedTriangles)  render.renderSlantedTriangles();
    if (showProjectedTriangles) render.renderProjectedTriangles();
    
    [context presentRenderbuffer:GL_RENDERBUFFER];
}


//**********************************************************************Shader Compilations***********************************************//

- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType{
    
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName
                                                           ofType:@"glsl"];
    
    NSError* error;
    
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
    if(!shaderString){
        NSLog(@"Error Loading Shader");
        exit(1);
    }
    
    GLuint shaderHandle = glCreateShader(shaderType);
    
    const char* shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    glCompileShader(shaderHandle);
    
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
 
    if(compileSuccess==GL_FALSE){
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@",messageString);
        exit(1);
    }
    
    NSLog([shaderName stringByAppendingString:@" Compiled"]);
    
    return shaderHandle;
}
- (void)compileShaders{
    
    NSLog(@"CompileShadersCalled");
    GLuint vertexShader = [self compileShader:@"VertexShader"
                                     withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"FragmentShader"
                                      withType:GL_FRAGMENT_SHADER];
    
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if(linkSuccess == GL_FALSE){
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    glUseProgram(programHandle);
    
    _positionSlot = glGetAttribLocation(programHandle, "Position");
    _colorSlot = glGetAttribLocation(programHandle, "SourceColor");
    _projectionUniform = glGetUniformLocation(programHandle, "Projection");
    _modelViewUniform = glGetUniformLocation(programHandle, "ModelView");
    
    render.initialize(_positionSlot, _colorSlot, _projectionUniform, _modelViewUniform);
    
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_colorSlot);
}


//*************************************************************************Event Handlers**************************************************//

- (IBAction)AxesSwitch:(UISwitch* )sender{
    
    if(sender.isOn)
        showAxis = TRUE;
    else
        showAxis = FALSE;
    
    
    
    NSLog(@"Axes Switch: %d",sender.isOn);
}
- (IBAction)BackSwitch:(UISwitch* )sender{
 
    if(sender.isOn)
        backColor = TRUE;
    else
        backColor = FALSE;
    
    

    NSLog(@"Back Switch: %d",sender.isOn);
    
}
- (IBAction)SlantedTrianglesSwitch:(UISwitch* )sender{
    
    if(sender.isOn)
        showSlantedTriangles = TRUE;
    else
        showSlantedTriangles = FALSE;
 

    
    NSLog(@"Slanted Triangles: %d",sender.enabled);
    
}
- (IBAction)ProjectedTrianglesSwitch:(UISwitch* )sender{
    if(sender.isOn)
        showProjectedTriangles = TRUE;
    else
        showProjectedTriangles = FALSE;
    
    

    
    NSLog(@"ProjectedTriangles: %d",sender.isOn);
}
- (IBAction)GridSizeSlider:(UISlider* )sender{

   nGridLines = sender.value;
    NSLog(@"Grid Size: %d",nGridLines);
    
   

}




//**********************************************************************Arc Ball Implementation********************************************//
- (void)computeIncremental  //Computes the incremented Rotation
{
    
    GLKVector3 axis = GLKVector3CrossProduct(_anchor_position, _current_position);
    float dot = GLKVector3DotProduct(_anchor_position, _current_position);
    float angle = acosf(dot);
    
    GLKQuaternion Q_rot = GLKQuaternionMakeWithAngleAndVector3Axis(angle * 2, axis);
    Q_rot = GLKQuaternionNormalize(Q_rot);
    
    _quat = GLKQuaternionMultiply(Q_rot, _quatStart);
        
    render.initialize(_positionSlot, _colorSlot, _projectionUniform, _modelViewUniform);
    render.updateRotationArc(_quat);
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    _quatStart = _quat;
    
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:EAGLView];
    
    _anchor_position = GLKVector3Make(location.x, location.y, 0);
    _anchor_position = [self projectOntoSurface:_anchor_position];
    
    _current_position = _anchor_position;
 
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
   
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:EAGLView];
    
       
    _current_position = GLKVector3Make(location.x, location.y, 0);
    _current_position = [self projectOntoSurface:_current_position];

    [self computeIncremental];
        
}

- (GLKVector3) projectOntoSurface:(GLKVector3) touchPoint
{
    float radius = EAGLView.bounds.size.width/3;
    GLKVector3 center = GLKVector3Make(EAGLView.bounds.size.width/2, EAGLView.bounds.size.height/2, 0);
    GLKVector3 P = GLKVector3Subtract(touchPoint, center);
    
    // Flip the y-axis because pixel coords increase toward the bottom.
    P = GLKVector3Make(P.x, P.y * -1, P.z);
    
    float radius2 = radius * radius;
    float length2 = P.x*P.x + P.y*P.y;
    
    if (length2 <= radius2)
        P.z = sqrt(radius2 - length2);
    else
    {
        P.z = radius2 / (2.0 * sqrt(length2));
        float length = sqrt(length2 + P.z * P.z);
        P = GLKVector3DivideScalar(P, length);
    }
    
    return GLKVector3Normalize(P);
}

@end
