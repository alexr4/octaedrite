import gab.opencv.*;

PVector globalCoord;
float globalScale;

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


void setup() {
  size(1280, 720, P3D);
  smooth(8);
  
  //OSCCLIENT
  initOSCP5("169.254.239.251", 1111);
  
  PApplet context = this;
  initOpenCV(context);
  initVariables();
  globalScale = 0.5;
  globalCoord = new PVector((width-(src.width*globalScale))/2, (height-(src.height*globalScale))/2);
  computeShape(6, octaPath.getPoints().size(), globalScale, 5, 50);

  ofList = new ArrayList<OutlineFollower>();
  ofLimit = 6;
  float res = 1.0 / ofLimit;
  for (int i = 0; i< ofLimit; i++)
  {
    float begin = i * res;//random(0, 0.90);
    float end = begin + res;//random(begin, 1);
    ofList.add(new OutlineFollower(i, vertList, begin, end, globalCoord));
  }

  background(0);
}

void draw() {
  background(0);
  displayDiffuse(displayDiffuse, globalCoord, globalScale);
  displayOCVsource(displayOCVsource, 0.10);
  displayShape(displayShape, globalCoord);
  displayShapeCenter(displayShapeCenter, globalCoord);
  displayOrientationArrow(displayOrientationArrow, globalCoord);
  displayNormals(displayNormals, globalCoord);
  /* displayProgressiveShape(displayProgressiveShape, globalCoord, 200);
   displayFollower(displayFollower, globalCoord, updateFollowerNoisePosition);*/
  //displayPath(true, globalCoord);

  for (OutlineFollower of : ofList)
  {
    //of.debugOriginalPath();
    of.updateLead();
    //of.displayLead();
    of.displayNewPath();
  }

  surface.setTitle( "FPS : " +round(frameRate));
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
  if(key == 'p')
  {
    for(OutlineFollower of : ofList)
    {
      of.clearAllPath();
    }
  }
}