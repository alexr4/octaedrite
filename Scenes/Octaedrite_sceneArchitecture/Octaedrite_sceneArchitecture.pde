/*
OSC message architecture :
 This sketch show the architecture of the OSC message between Max/MSP and processing for the project Octaedrite
 It's has been establish that the visual will be guided by the soundtrack which will receive input from the visual in order to modulated the soundtrack.
 Max/Msp will sequence the visuals using the following architecture message :
 Max/MSP send : /sceneINT00_INT01_P5 as String where :
 INT00 = int index of the scene
 INT02 = int index of the shot
 _P5 = send to P5
 
 Processing send : /P5_sceneINT00_INT01 as String where :
 _P5 = send from P5
 INT00 = int index of the scene
 INT02 = int index of the shot
 
 TODO LIST :
 Implement design
 
 */
int sceneIndex;
String[] sceneList = 
  {"/scene00_00_P5", 
  "/scene01_00_P5", 
  "/scene01_01_P5", 
  "/scene02_00_P5", 
  "/scene02_01_P5", 
  "/scene02_02_P5", 
  "/scene02_03_P5"}; 

//JSON FILES
JSONArray linePathFile;
boolean load;
ArrayList<Path> pathlist;
float scaleShape = 1;

//3D World
boolean debug3DWorld;

//3D Shape
Octaedrite octaedrite;

//Scene1
ArrayList<Follower> followerlist;
ArrayList<PtLight> lightList;


//Debug
FPSTracking fpstracker;

void setup()
{
  size(1280, 720, P3D);
  //OSCCLIENT
  initOSCP5("127.0.0.1", 12000, 12000);

  //buffers
  finalBuffer = initBuffers(1920, 1080);
  finalBufferRatio = computeBufferRatio(finalBuffer.width, finalBuffer.height);
  stencilBuffer = initBuffers(1920, 1080);
  stencilBufferRatio = computeBufferRatio(stencilBuffer.width, stencilBuffer.height);

  //3 Shape
  octaedrite = new Octaedrite(); 
  
  //initScene
  initScene00();


  appParameter();
  surface.setLocation(20, 20);
  float w = 100;
  float h = 25;
  fpstracker = new FPSTracking(floor(w), 60, w, h);
  println("-----------------------------------------------\n\n");

  renderFinalBuffer();
  renderStencilBuffer();

  //activate debugs
  debug3DWorld = false;
  //octaedrite.showDebugStroke();
}

void draw()
{
  //computation
  renderFinalBuffer();

  background(20);
  image(finalBuffer, 0, 0, width, height);//, finalBuffer.width * 0.5, (finalBuffer.width * 0.5) / finalBufferRatio);
  image(stencilBuffer, 0, height-(stencilBuffer.width * 0.1) / stencilBufferRatio, stencilBuffer.width * 0.1, (stencilBuffer.width * 0.1) / stencilBufferRatio);




  showFpsOnFrameTitle();
  showDebug(true);
}