class Follower
{
  float degrees;
  float vd = 1;
  float sinWave;
  float orientation;
  int tailSize;
  float scaleTail;
  ArrayList<PVector> tail;
  Path path;
  int pos;

  Follower(Path p)
  {
    path = p;
    updateVariable();
    tail = new ArrayList<PVector>();
  }

  void run()
  {
    //vd = map(mouseX, 0, width, 0.001, 5);
    vd = noise(frameCount * 0.1) * 1;
    //println(vd);

    //checkEdge();
    updateDegrees();
    updateOrientation();
    sinWave = sin(radians(degrees));
    pos = floor(map(sinWave, -1, 1, 0, path.getLerpVertListSize()-1));
    addTail(pos);
  }

  void updateDegrees()
  {
    degrees += vd;
  }

  void updateOrientation()
  {
    if (sinWave <= -0.98)
    {
      orientation = 0;
    }
    if (sinWave >= 0.98)
    {
      orientation = PI;
    }
  }

  void addTail(int i)
  {
    tail.add(path.getLerpPosition(i).copy());

    if (tail.size() > tailSize)
    {
      tail.remove(0);
    }
  }

  void displayTail()
  {
    if (tail.size() > 0)
    {
      beginShape(TRIANGLES);
      noStroke();
      for (int i=0; i< tail.size(); i++)
      {
        int i0 = i;
        int i1 = i0;
        if (i < tail.size()-1)
        {
          i1 = i+1;
        } else
        {
          i1 = i;
        }
        
        float ns = noise(frameCount * 0.1, i * 0.2) * (scaleTail*2);
        float ts = map(i, 0, tail.size(), 0, ns);


        PVector ov0 = tail.get(i0).copy();
        PVector ov1 = tail.get(i1).copy();
        PVector v0tov1 = PVector.sub(ov1, ov0);

        PVector norm0 = v0tov1.copy();
        norm0.normalize();
        norm0.mult(ts);
        norm0.rotate(-HALF_PI);
        
        PVector norm1 = v0tov1.copy();
        norm1.normalize();
        norm1.mult(ts);
        norm1.rotate(HALF_PI);

        PVector v0 = norm1.copy().add(ov0);
        PVector v1 = norm1.copy().add(ov1);
        PVector v2 = norm0.copy().add(ov0);
        PVector v3 = norm0.copy().add(ov1);

        float opacity = map(i, 0, tail.size(), 0, 100);

        fill(0, 0, 100, opacity);
        vertex(v0.x, v0.y);
        vertex(v1.x, v1.y);
        vertex(v2.x, v2.y);

        vertex(v2.x, v2.y);
        vertex(v3.x, v3.y);
        vertex(v1.x, v1.y);
      }
      endShape();
    }
  }
  
  void displayFollower()
  {
    pushMatrix();
    translate(path.getLerpPosition(pos).x, path.getLerpPosition(pos).y);
    rotate(path.getAngleAtLerp(pos) + orientation);
    noStroke();
    fill(0, 00, 100);
    ellipse(0, 0, scaleTail * 2, scaleTail * 2);
    //stroke(220, 100, 100);
   // line(0, 0, 50, 0);
    popMatrix();
  }

  void displayDebug()
  {
    /*
    pushMatrix();
    translate(path.getLerpPosition(pos).x, path.getLerpPosition(pos).y);
    rotate(path.getAngleAtLerp(pos) + orientation);
    noStroke();
    fill(0, 00, 100);
    ellipse(0, 0, 10, 10);
    stroke(220, 100, 100);
    line(0, 0, 50, 0);
    popMatrix();*/
  }
  
  void updateVariable()
  {
    
    tailSize = round(random(20, 80));
    scaleTail = random(1, 2);
  }
}