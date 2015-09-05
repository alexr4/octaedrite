import gab.opencv.*;

PImage src, dst;
OpenCV opencv;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;

float noiseOff, noiseSpeed;
Contour c;
PShape octa;

ArrayList<PVector> vertList;
ArrayList<PVector> normalList;
ArrayList<Float> etaList;
float amt;

void setup() {
  src = loadImage("shape.jpg"); 
  size(src.width/2, src.height/2, P2D);
  smooth(8);
  opencv = new OpenCV(this, src);

  opencv.gray();
  opencv.threshold(50);
  dst = opencv.getOutput();

  contours = opencv.findContours();
  println("found " + contours.size() + " contours");

  noiseOff = random(0, 1);
  noiseSpeed = 0.01;
  c = contours.get(0);
  vertList = new ArrayList<PVector>();
  normalList = new ArrayList<PVector>();
  etaList = new ArrayList<Float>();
  computeShape(150, c.getPoints().size(), 250);
}

void draw() {
  background(255);
  image(src, 0, 0, src.width * .5, src.height * .5);
  shape(octa);

  float speed = noise(frameCount) * 0.0025;
  PVector actualLocation = vertList.get(computeNewPosition(speed)).get();
  float eta = etaList.get(computeNewPosition(speed));

  for (int i=0; i<vertList.size(); i++)
   {
    float size = 100;
    PVector n = normalList.get(i);
    PVector v = vertList.get(i);
    n.normalize();
    //n.add(v);
    n.mult(size);
    n.add(v);
    stroke(255, 0, 255);
    line(v.x, v.y, n.x, n.y);
  }

  /* for (int i=0; i<etaList.size(); i++)
   {
   PVector v = vertList.get(i).get();
   float theta = etaList.get(i);
   pushMatrix();
   translate(v.x, v.y);
   rotate(theta);
   stroke(255, 0, 0);
   line(0, 0, 50, 50);
   popMatrix();
   }*/

  pushMatrix();
  translate(actualLocation.x, actualLocation.y);
  //rotate(eta);
  fill(0, 255, 0);
  noStroke();
  rectMode(CENTER);
  ellipse(0, 0, 20, 20);
  popMatrix();
}

int computeNewPosition(float s)
{
  if (amt < 0.9999)
  {
    amt += s;
  } else
  {
    amt = 0;
  }
  return floor(lerp(0, vertList.size()-1, amt));
}

void computeShape(int step, int ray, float previousSizeStrip)
{
  float size = previousSizeStrip; 
  octa = createShape();
  PVector center = new PVector(width/2, height/2);

  octa.beginShape(TRIANGLES);
  octa.noFill();
  for (int i=step; i<ray; i+=step)
  {
    float sizeStrip = noise(noiseOff) * size;

    PVector previous = c.getPoints().get(i-step).get();
    PVector vert = c.getPoints().get(i).get();
    previous.mult(0.5);
    vert.mult(0.5);
    PVector previousnormal = PVector.sub(previous, center);
    previousnormal.normalize();
    if (i== step)
    {
      previousSizeStrip = noise(noiseOff) * size;
    } else
    {
    }
    previousnormal.mult(previousSizeStrip);
    PVector normal = PVector.sub(vert, center);
    normal.normalize();
    normal.mult(sizeStrip);
    PVector innerPrev = PVector.sub(previous, previousnormal); 
    PVector innerVert = PVector.sub(vert, normal); 

    octa.stroke(normal.x * 255, normal.y * 255, 255);

    octa.vertex(previous.x, previous.y);
    octa.vertex(vert.x, vert.y);
    octa.vertex(innerPrev.x, innerPrev.y);

    octa.vertex(innerPrev.x, innerPrev.y);
    octa.vertex(vert.x, vert.y);
    octa.vertex(innerVert.x, innerVert.y);

    previousSizeStrip = sizeStrip;

    noiseOff += noiseSpeed;

    
    PVector n = new PVector((vert.y - previous.y)*-1, (vert.x - previous.x));
    n.normalize();
    normalList.add(n);

    PVector v = PVector.sub(vert.get(), center.get());
    PVector axis = new PVector(0, 70); 
    axis.normalize();
    v.normalize();
    float eta = PVector.angleBetween(v, axis);
    etaList.add(eta);
    vertList.add(previous);
  }

  octa.endShape();
}

Float calulateAngle(PVector vertA, PVector vertB, int orientation)
{

  if (orientation == 1)
  { //X rotation
    float adjacant = vertB.x - vertA.x;
    float oppose = vertB.z - vertA.z;

    float phi = atan2(oppose, adjacant); 
    return phi;
  } else if (orientation == 2)
  {//Y rotation
    float adjacant = vertB.x - vertA.x;
    float oppose = vertB.y - vertA.y;
    float phi = atan2(oppose, adjacant); 
    return phi;
  } else if (orientation == 3)
  {//z Rotation
    float adjacant = vertB.y - vertA.y;
    float oppose = vertB.z - vertA.z;
    float phi = atan2(oppose, adjacant); 
    return phi;
  } else
  {
    return null;
  }
}

