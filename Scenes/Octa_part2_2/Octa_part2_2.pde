import gab.opencv.*;

PVector globalCoord;
float globalScale;
PVector center;

boolean displayOCVsource = false;
boolean displayDiffuse = false;
boolean displayShape;
boolean displayProgressiveShape;
boolean displayShapeCenter;
boolean displayOrientationArrow;
boolean displayNormals;
boolean displayFollower = true;
boolean updateFollowerNoisePosition;

ArrayList<OutlineFollower> ofList;
int ofLimit;
int globalIndex = 0;


void setup() {
  //size(1920, 1080, P3D);
  //surface.setLocation(0, 0);
  fullScreen(P3D);
  smooth(8);

  //OSCCLIENT
  initOSCP5("129.102.64.222", 1111);

  PApplet context = this;
  initOpenCV(context);
  initVariables();
  globalScale = 0.5;
  globalCoord = new PVector((width-(src.width*globalScale))/2, (height-(src.height*globalScale))/2);
  computeShape(8, octaPath.getPoints().size(), globalScale, 5, 50);
  center =  new PVector(octaCenter.x+globalCoord.x, octaCenter.y+globalCoord.y);

  ofList = new ArrayList<OutlineFollower>();
  //initTest();
  background(0);
}

void draw() {
  background(0);
  displayDiffuse(displayDiffuse, globalCoord, globalScale);
  displayOCVsource(displayOCVsource, 0.10);
  //displayShape(displayShape, globalCoord);
  displayShapeCenter(displayShapeCenter, globalCoord);
  displayOrientationArrow(displayOrientationArrow, globalCoord);
  displayNormals(displayNormals, globalCoord);
  displayPath(displayShape, globalCoord);



  try {
    if (ofList.size() > 0)
    {
      for (int i=0; i<ofList.size(); i++)
      {
        OutlineFollower of = ofList.get(i);

        //of.debugOriginalPath(0.25);
        of.displayLead();
        of.run();
      }
    }
  }
  catch(Exception e)
  {
    println(e+" ofList.size() : "+ofList.size());
  }


  surface.setTitle( "FPS : " +round(frameRate));
  fill(255);
  text(round(frameRate), 20, 20);
}

void mousePressed()
{
  noLoop();
}

void mouseReleased()
{
  loop();
}

void keyPressed()
{
  if (key == 's' || key == 'S')
  {
    displayOCVsource = !displayOCVsource;
  }
  if (key == 'd' || key == 'D')
  {
    displayDiffuse = !displayDiffuse;
  }
  if (key == 'c' || key == 'C')
  {
    displayShapeCenter = !displayShapeCenter;
  }
  if (key == 'o' || key == 'O')
  {
    displayOrientationArrow = !displayOrientationArrow;
  }
  if (key == 'n' || key == 'N')
  {
    displayNormals = !displayNormals;
  }
  if (key == '0')
  {
    displayShape = !displayShape;
  }
  if (key == '1')
  {
    displayProgressiveShape = !displayProgressiveShape;
  }
  if (key == '2')
  {
    displayFollower = !displayFollower;
  }
  if (key == '3')
  {
    updateFollowerNoisePosition = !updateFollowerNoisePosition;
  }
  if (key == 'p')
  {
    for (OutlineFollower of : ofList)
    {
      of.clearAllPath();
    }
  }
  if (key == 'f')
  {
    ofList.clear();
    initTest();
  }
}

void initTest()
{
  ofList = new ArrayList<OutlineFollower>();
  ofLimit = 10;
  float res = 1.0 / ofLimit;
  for (int i = 0; i< ofLimit; i++)
  {
    float begin = i * res;//random(0, 0.90);
    float end = random(begin, 1);//begin + res;//random(begin, 1);
    ofList.add(new OutlineFollower(i, 1, vertList, begin, end, globalCoord, random(0.05, 0.1)));
  }
}