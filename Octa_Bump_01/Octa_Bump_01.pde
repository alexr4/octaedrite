//Sketch properties
String appName = "Octaedrite_BumpmappingTest";
String version = "Alpha";
String subVersion = "0.0.2";
String frameName;

//Buffer
PGraphics bufferScreen;

//3DScene Variables
float zoom = 0;
PVector rotation = new PVector();
PVector velocity = new PVector();
float rotationSpeed = 0.01;
PVector acceleration= new PVector();
PVector orientation;
float sens, sens2;
float amplitude;

//Lights
ArrayList<PtLight> lightPos;

//Shape
PShader octaShader;
PShape octa;
ArrayList<PVector> vertList;
ArrayList<PVector> colorList;
ArrayList<PVector> texCoord;
ArrayList<PVector> normalList;
PImage diffuse, bumpmap, mask, displacement;
ArrayList<PImage> textureList;
boolean debug;

//debug
FPSTracking fpstracker;

void setup()
{
  size(1280, 720, P3D);
  //smooth(8);
  appParameter();
  initBufferScreen();
  loadTextures();
  loadShapeShader();
  init3DShape(1920, 1128, 0.25);

  float fpsw = 250;
  float fpsh = 60;
  fpstracker = new FPSTracking(floor(fpsw), 60, fpsw, fpsh);
}

void draw()
{
  fpstracker.run(frameRate);
  computerBufferScreen();
  showFpsOnFrameTitle();

  image(bufferScreen, 0, 0);
  image(fpstracker.getImageTracker(), 20, height-fpstracker.h);
  
  fill(127);
  text("NAVIGATION :\n\nClick Left & Drag to move camera\nDouble-Click Right to center view\nPress 'd' to show activate/desactivate the debug mode", 20, height-(fpstracker.h*2) - 20);
}

//App Parameters
void appParameter()
{
  frameName = appName+"_"+version+"_"+subVersion;
  surface.setTitle(frameName);
}

void showFpsOnFrameTitle()
{
  surface.setTitle(frameName+"    FPS : "+int(frameRate));
}

void mousePressed()
{
  if (mouseButton == LEFT)  // left button
  {
    if (mouseEvent.getClickCount()==2) {  // double-click
      rotation = new PVector(0, 0);
      //println("double-click");
    } else {
      //println("left-click");
    }
  } else if (mouseButton == RIGHT) // right button
  {
    //println("right");
  }
}

void keyPressed()
{
  for (int i=0; i<textureList.size(); i++)
  {
    if (Character.getNumericValue(key)  == i)
    {
      changeTexture(i);
    }
  }
  
  if(key == 'd')
  {
    debug = !debug;
    if(debug)
    {
      showDebugStroke();
    }
    else
    {
      createOcta();
    }
  }
}