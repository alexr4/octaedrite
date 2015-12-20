import gab.opencv.*;
//OpenCV
PImage src, dst;
OpenCV opencv;
ArrayList<Contour> contours;
Contour octaPath;

//behaviors
float amt;

//Generative Shape
PImage diffuse;
PShape octa;
PVector octaCenter;
float noiseThickness, thicknessSpeed;

//Shapes Data
ArrayList<PVector> vertList;
ArrayList<PVector> normalList;
ArrayList<Float> etaList;
ArrayList<PVector> shapeVertList;

//Follower
float followerSpeed;
PVector followerLocation;
float followerAngle;
float noisePositionOffset;

PVector globalCoord;
float globalScale;
PVector center;

boolean displayOCVsource = true;
boolean displayDiffuse = true;
boolean displayShape = true;
boolean displayProgressiveShape = true;
boolean displayShapeCenter = true;
boolean displayOrientationArrow = true;
boolean displayNormals = true;
boolean displayFollower = true;
boolean updateFollowerNoisePosition = true;

//Init Methods
void initOCVOutlines(PApplet context)
{
  initOpenCV(context);
  initVariables();
  globalScale = .85;
  globalCoord = new PVector((finalBuffer.width-(src.width*globalScale))/2, (finalBuffer.height-(src.height*globalScale))/2 + 2.5);
  computeShape(8, octaPath.getPoints().size(), globalScale, 5, 50);
  center =  new PVector(octaCenter.x+globalCoord.x, octaCenter.y+globalCoord.y);
}

void initOpenCV(PApplet context)
{
  src = loadImage("ocv/shape03.jpg"); 
  opencv = new OpenCV(context, src);

  opencv.gray();
  opencv.threshold(50);
  dst = opencv.getOutput();

  contours = opencv.findContours();
  println("found " + contours.size() + " contours");
}

void initVariables()
{
  diffuse = loadImage("textures/diffuse.jpg");
  octaPath = contours.get(4);
  vertList = new ArrayList<PVector>();
  normalList = new ArrayList<PVector>();
  shapeVertList = new ArrayList<PVector>();
  etaList = new ArrayList<Float>();
  noiseThickness = random(1);
  thicknessSpeed = .1;
}

void computeShape(int step, int ray, float scale, float thick, float thin)
{
  float n = noise(noiseThickness);
  float savedSize = map(n, 0, 1, thin, thick);
  float originalSize = savedSize;
  octaCenter = getGravityCenter(octaPath.getPoints(), step, ray, scale);

  octa = createShape();
  octa.beginShape(TRIANGLES);
  octa.noFill();
  for (int i=0; i<ray; i+=step)
  {
    n = noise(noiseThickness);
    float size = map(n, 0, 1, thin, thick);
    //index next vertex
    int index01 = i;
    if (i<ray-step)
    {
      index01 = i+step;
    } else
    {
      index01 = 0;
      size = originalSize;
    }

    //first Vectors
    PVector v0 = octaPath.getPoints().get(i).get();
    PVector v1 = octaPath.getPoints().get(index01).get();

    //Scale to new area
    v0.mult(scale);
    v1.mult(scale);

    //define vertex 2 & 3
    PVector v0Togc = PVector.sub(octaCenter, v0);
    PVector v1Togc = PVector.sub(octaCenter, v1);
    v0Togc.normalize();
    v1Togc.normalize();
    v0Togc.mult(savedSize);
    v1Togc.mult(size);

    PVector v2 = PVector.add(v0, v0Togc);
    PVector v3 = PVector.add(v1, v1Togc);
    
    
    //update sized for next iteration
    savedSize = size;
    noiseThickness += thicknessSpeed;

    //compute datas add to lists
    //phi
    PVector direction = PVector.sub(v1, v0);
    direction.normalize();
    float eta = direction.heading2D();

    //normal
    PVector v0tov1 = PVector.sub(v1, v0);
    v0tov1.normalize();
    v0tov1.rotate(HALF_PI);

    vertList.add(v0);
    etaList.add(eta);
    normalList.add(v0tov1);
    shapeVertList.add(v2);
    shapeVertList.add(v0);
    shapeVertList.add(v1);
    shapeVertList.add(v2);
    shapeVertList.add(v1);
    shapeVertList.add(v3);

    //CreateShape
    octa.noStroke();
    octa.noFill();
    octa.stroke(v0tov1.x * 255, v0tov1.y * 255, 255);
    
    octa.vertex(v2.x, v2.y);
    octa.vertex(v0.x, v0.y);
    octa.vertex(v1.x, v1.y);

    octa.vertex(v2.x, v2.y);
    octa.vertex(v1.x, v1.y);
    octa.vertex(v3.x, v3.y);

  }
  octa.endShape();
}

PVector getGravityCenter(ArrayList<PVector> list, int step, int ray, float scale)
{
  PVector gc = new PVector();
  for (int i=step; i<ray; i+=step)
  {
    PVector v = list.get(i).get();
    v.mult(scale);
    gc.add(v);
  }
  gc.div(ray/step);

  return gc;
}

/*-----------------------------------------------------------------------------------------
DISPLAY
-------------------------------------------------------------------------------------------*/

void displayOCVsource(boolean state, float scale, PGraphics buffer)
{
  buffer.pushStyle();
  if (state)
  {
    buffer.image(src, 0, 0, diffuse.width * scale, diffuse.height * scale);
    buffer.stroke(0, 0, 0);
    buffer.noFill();
    buffer.rect(0, 0, diffuse.width * scale, diffuse.height * scale);
  } else
  {
  }
  buffer.popStyle();
}

void displayDiffuse(boolean state, PVector coord, float scale, PGraphics buffer)
{
  if (state)
  {
    buffer.pushStyle();
    buffer.pushMatrix();
    buffer.translate(coord.x, coord.y);
    buffer.rectMode(CENTER);
    buffer.image(diffuse, 0, 0, diffuse.width * scale, diffuse.height * scale);
    buffer.popMatrix();
    buffer.popStyle();
  } else
  {
  }
}

void displayPath(boolean state, PVector coord, PGraphics buffer)
{
  if (state)
  {
    buffer.pushStyle();
    buffer.stroke(255, 255, 0);
    buffer.pushMatrix();
    buffer.translate(coord.x, coord.y);
    buffer.noFill();
    buffer.beginShape();
    for (PVector v : vertList)
    {
      buffer.vertex(v.x, v.y);
    }
    buffer.endShape(CLOSE);
    buffer.popMatrix();
    buffer.popStyle();
  }
}

void displayShape(boolean state, PVector coord, PGraphics buffer)
{
  if (state)
  {
    buffer.pushStyle();
    buffer.pushMatrix();
    buffer.translate(coord.x, coord.y);
    buffer.shape(octa);
    buffer.popMatrix();
    buffer.popStyle();
  } else
  {
  }
}

void displayShapeCenter(boolean state, PVector coord, PGraphics buffer)
{
  if (state)
  {
    buffer.pushStyle();
    buffer.pushMatrix();
    buffer.translate(coord.x, coord.y);
    buffer.fill(255, 0, 0);
    buffer.ellipse(octaCenter.x, octaCenter.y, 20, 20);
    buffer.popMatrix();
    buffer.popStyle();
  } else
  {
  }
}

void displayOrientationArrow(boolean state, PVector coord, PGraphics buffer)
{
  if (state)
  {
    buffer.pushStyle();
    buffer.pushMatrix();
    buffer.translate(coord.x, coord.y);
    //ArrowDebug
    displayOrientationArrow(20, 25, buffer);
    buffer.popMatrix();
    buffer.popStyle();
  } else
  {
  }
}

void displayNormals(boolean state, PVector coord, PGraphics buffer)
{
  if (state)
  {
    buffer.pushStyle();
    buffer.pushMatrix();
    buffer.translate(coord.x, coord.y);

    //normals
    displayNormals(10, buffer);
    buffer.popMatrix();
    buffer.popStyle();
  } else
  {
  }
}

void displayFollower(boolean state, PVector coord, boolean mode, PGraphics buffer)
{ 
  if (mode)
  {
    noisePosition(1);
  } else
  {
    followContour(8);
  }
  if (state)
  {
    buffer.pushStyle();
    buffer.pushMatrix();
    buffer.translate(coord.x, coord.y);

    displayFollower(buffer);
    buffer.popMatrix();
    buffer.popStyle();
  } else
  {
  }
}

void displayProgressiveShape(boolean state, PVector coord, int length, PGraphics buffer)
{
  if (state)
  {
    buffer.pushStyle();
    buffer.pushMatrix();
    buffer.translate(coord.x, coord.y);

    displayProgressiveShape(length, buffer);
    buffer.popMatrix();
    buffer.popStyle();
  } else
  {
  }
}

//display
void displayFollower(PGraphics buffer)
{
  buffer.pushStyle();
  buffer.pushMatrix();
  buffer.translate(followerLocation.x, followerLocation.y);
  buffer.rotate(followerAngle);
  buffer.fill(0, 255, 255);
  buffer.noStroke();
  buffer.rectMode(CENTER);
  buffer.rect(0, 0, 20, 20);
  buffer.strokeWeight(3);
  buffer.stroke(255, 0, 0);
  buffer.line(0, 0, 40, 0);
  buffer.popMatrix();
  buffer.popStyle();
}

void displayOrientationArrow(float definition, float dist, PGraphics buffer)
{
  buffer.pushStyle();
  for (int i=0; i<vertList.size (); i++)
  {
    float eta = etaList.get(i);
    PVector loc = vertList.get(i).get();
    PVector locTogc = PVector.sub(loc, octaCenter);
    locTogc.setMag(dist);
    loc.add(locTogc);

    buffer.pushMatrix();
    buffer.translate(loc.x, loc.y);
    buffer.rotate(eta);
    buffer.stroke(255, 0, 0);
    buffer.line(0, 0, definition/2, 0);
    buffer.line(definition/2, 0, definition/2 - 4, 4 * 0.5);
    buffer.line(definition/2, 0, definition/2 - 4, -4 * 0.5);
    buffer.popMatrix();
  }
  buffer.popStyle();
}

void displayNormals(float mag, PGraphics buffer)
{
  for (int i =0; i < normalList.size (); i++)
  {

    //first Vectors
    PVector norm = normalList.get(i).get();
    PVector vert0 = vertList.get(i).get();
    norm.mult(mag);
    PVector normEnd = PVector.sub(vert0, norm);

    buffer.stroke(255, 0, 255);
    buffer.line(vert0.x, vert0.y, normEnd.x, normEnd.y);
  }
}

void displayProgressiveShape(int length_, PGraphics buffer)
{
  int size = round(map(amt, 0, 1, 0, shapeVertList.size ()));
  int start = round(map(amt, 0, 1, 0, shapeVertList.size () - (length_ * 6)));
  buffer.beginShape(TRIANGLE_STRIP);
  buffer.fill(255);
  buffer.noStroke();
  for (int n=start; n<size; n+=6)
  {
    PVector v0 = shapeVertList.get(n + 0);
    PVector v1 = shapeVertList.get(n + 1);
    PVector v2 = shapeVertList.get(n + 2);
    PVector v3 = shapeVertList.get(n + 3);
    PVector v4 = shapeVertList.get(n + 4);
    PVector v5 = shapeVertList.get(n + 5);
    
    PVector norm = PVector.sub(octaCenter, v0);
    norm.normalize();

    float gradient = map(n, start, size, 0, 1);
    buffer.fill(norm.x*255, 255, norm.y*255, gradient * 255);
    buffer.vertex(v0.x, v0.y);
    buffer.vertex(v1.x, v1.y);
    buffer.vertex(v2.x, v2.y);

    buffer.vertex(v3.x, v3.y);
    buffer.vertex(v4.x, v4.y);
    buffer.vertex(v5.x, v5.y);
  }
  buffer.endShape();
}

//---Behaviors methods
void followContour(float s)
{
  followerSpeed = noise(frameCount) * (s * 0.00025);
  followerLocation = vertList.get(computeNewPosition(followerSpeed)).get();
  followerAngle = etaList.get(computeNewPosition(followerSpeed));
}

void noisePosition(float s)
{
  s = s * 0.01;
  amt = noise(noisePositionOffset);
  amt = constrain(amt, 0, 1);
  int pos = floor(lerp(0, vertList.size()-1, amt));
  
  followerLocation = vertList.get(pos).get();
  followerAngle = etaList.get(pos);
  
  noisePositionOffset += s;
}

int computeNewPosition(float s)
{

  if (amt < 0.999999)
  {
    amt += s;
  } else
  {
    amt = 0;
  }

  amt = constrain(amt, 0, 1);

  return floor(lerp(0, vertList.size()-1, amt));
}