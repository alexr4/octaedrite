import gab.opencv.*;

PImage src, dst;
OpenCV opencv;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;

void setup() {
  src = loadImage("shape.jpg"); 
  size(src.width, src.height/2);
  opencv = new OpenCV(this, src);

  opencv.gray();
  opencv.threshold(50);
  dst = opencv.getOutput();

  contours = opencv.findContours();
  println("found " + contours.size() + " contours");
}

void draw() {
  background(255);
  scale(0.5);
  //image(src, 0, 0);
  image(dst, src.width, 0);
  PVector center = new PVector(src.width/2, src.height/2);
  noFill();
  strokeWeight(3);
  Contour c = contours.get(0);
  //c.draw();
  
  int step = floor(map(mouseY, 0, height, 1, c.getPoints().size()/10));
  int ray = constrain(floor(map(mouseX, 0, width/2, 2, c.getPoints().size())), 2, c.getPoints().size());
  float sizeStrip = 250;
  
  beginShape(TRIANGLES);
  for (int i=step; i<ray; i+=step)
  {
    PVector previous = c.getPoints().get(i-step);
    PVector vert = c.getPoints().get(i);
    PVector previousnormal = PVector.sub(previous, center);
    previousnormal.normalize();
    previousnormal.mult(sizeStrip);
    PVector normal = PVector.sub(vert, center);
    normal.normalize();
    normal.mult(sizeStrip);
    PVector innerPrev = PVector.sub(previous, previousnormal); 
    PVector innerVert = PVector.sub(vert, normal); 
    
    stroke(normal.x * 255, normal.y * 255, 0);
    
    vertex(previous.x, previous.y);
    vertex(vert.x, vert.y);
    vertex(innerPrev.x, innerPrev.y);
    
    vertex(innerPrev.x, innerPrev.y);
    vertex(vert.x, vert.y);
    vertex(innerVert.x, innerVert.y);
  }
  vertex(c.getPoints().get(c.getPoints().size()-1).x, c.getPoints().get(c.getPoints().size()-1).y);
  endShape(CLOSE);
}

