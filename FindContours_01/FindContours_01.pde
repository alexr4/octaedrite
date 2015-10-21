import gab.opencv.*;

PVector globalCoord;
float globalScale;

boolean displayOCVsource = true;
boolean displayDiffuse = true;
boolean displayShape;
boolean displayProgressiveShape;
boolean displayShapeCenter;
boolean displayOrientationArrow;
boolean displayNormals;
boolean displayFollower = true;
boolean updateFollowerNoisePosition;


void setup() {
  size(1280, 720, P2D);
  smooth(8);
  PApplet context = this;
  initOpenCV(context);
  initVariables();
  globalScale = 0.5;
  globalCoord = new PVector((width-(src.width*globalScale))/2, (height-(src.height*globalScale))/2);
  computeShape(20, octaPath.getPoints().size(), globalScale, 5, 50);
}

void draw() {
  background(255);
  displayDiffuse(displayDiffuse, globalCoord, globalScale);
  displayOCVsource(displayOCVsource, 0.10);
  displayShape(displayShape, globalCoord);
  displayShapeCenter(displayShapeCenter, globalCoord);
  displayOrientationArrow(displayOrientationArrow, globalCoord);
  displayNormals(displayNormals, globalCoord);
  displayProgressiveShape(displayProgressiveShape, globalCoord, 200);
  displayFollower(displayFollower, globalCoord, updateFollowerNoisePosition);
}

void keyPressed()
{
  if(key == 's' || key == 'S')
  {
    displayOCVsource = !displayOCVsource;
  }
  if(key == 'd' || key == 'D')
  {
    displayDiffuse = !displayDiffuse;
  }
  if(key == 'c' || key == 'C')
  {
    displayShapeCenter = !displayShapeCenter;
  }
  if(key == 'o' || key == 'O')
  {
    displayOrientationArrow = !displayOrientationArrow;
  }
  if(key == 'n' || key == 'N')
  {
    displayNormals = !displayNormals;
  }
  if(key == '0')
  {
    displayShape = !displayShape;
  }
  if(key == '1')
  {
    displayProgressiveShape = !displayProgressiveShape;
  }
  if(key == '2')
  {
    displayFollower = !displayFollower;
  }
  if(key == '3')
  {
    updateFollowerNoisePosition = !updateFollowerNoisePosition;
  }
}
