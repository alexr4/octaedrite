import gab.opencv.*;

PImage src, dst;
OpenCV opencv;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;

float noiseOff, noiseSpeed;
Contour c;
PShape octa;

void setup() {
  src = loadImage("shape.jpg"); 
  size(src.width, src.height/2, P2D);
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
  computeShape(15, c.getPoints().size(), 500);
}

void draw() {
  background(255);
  scale(0.5);
  image(src, 0, 0);
  image(dst, src.width, 0);
  shape(octa);
}

void computeShape(int step, int ray, float previousSizeStrip)
{
  float size =previousSizeStrip; 
  octa = createShape();
  PVector center = new PVector(src.width/2, src.height/2);
  /*noFill();
   strokeWeight(3);*/
  //c.draw();

  /*int step = floor(map(mouseY, 0, height, 1, c.getPoints().size()/10));
   int ray = constrain(floor(map(mouseX, 0, width/2, 2, c.getPoints().size())), 2, c.getPoints().size());
   float previousSizeStrip = 250;*/

  octa.beginShape(TRIANGLES);
  octa.noFill();
  for (int i=step; i<ray; i+=step)
  {
    float sizeStrip = noise(noiseOff) * size;
    PVector previous = c.getPoints().get(i-step);
    PVector vert = c.getPoints().get(i);
    PVector previousnormal = PVector.sub(previous, center);
    previousnormal.normalize();
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
  }

  octa.endShape();
}

