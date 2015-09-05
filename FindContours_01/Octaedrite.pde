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

//Init Methods
void initOpenCV(PApplet context)
{
  src = loadImage("shape.jpg"); 
  opencv = new OpenCV(context, src);

  opencv.gray();
  opencv.threshold(50);
  dst = opencv.getOutput();

  contours = opencv.findContours();
  println("found " + contours.size() + " contours");
}

void initVariables()
{
  diffuse = loadImage("diffuse.jpg");
  octaPath = contours.get(0);
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

