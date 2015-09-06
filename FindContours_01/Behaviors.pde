//display
void displayFollower()
{
  pushStyle();
  pushMatrix();
  translate(followerLocation.x, followerLocation.y);
  rotate(followerAngle);
  fill(0, 255, 255);
  noStroke();
  rectMode(CENTER);
  rect(0, 0, 20, 20);
  strokeWeight(3);
  stroke(255, 0, 0);
  line(0, 0, 40, 0);
  popMatrix();
  popStyle();
}

void displayOrientationArrow(float definition)
{
  pushStyle();
  for (int i=0; i<vertList.size (); i++)
  {
    float eta = etaList.get(i);
    PVector loc = vertList.get(i).get();
    PVector locTogc = PVector.sub(loc, octaCenter);
    locTogc.setMag(10);
    loc.add(locTogc);

    pushMatrix();
    translate(loc.x, loc.y);
    rotate(eta);
    stroke(255, 0, 0);
    line(0, 0, definition/2, 0);
    line(definition/2, 0, definition/2 - 4, 4 * 0.5);
    line(definition/2, 0, definition/2 - 4, -4 * 0.5);
    popMatrix();
  }
  popStyle();
}

void displayNormals(float mag)
{
  for (int i =0; i < normalList.size (); i++)
  {

    //first Vectors
    PVector norm = normalList.get(i).get();
    PVector vert0 = vertList.get(i).get();
    norm.mult(mag);
    PVector normEnd = PVector.sub(vert0, norm);

    stroke(255, 0, 255);
    line(vert0.x, vert0.y, normEnd.x, normEnd.y);
  }
}

void displayProgressiveShape(int length_)
{
  int size = round(map(amt, 0, 1, 0, shapeVertList.size ()));
  int start = round(map(amt, 0, 1, 0, shapeVertList.size () - (length_ * 6)));
  beginShape(TRIANGLE_STRIP);
  fill(255);
  noStroke();
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
    fill(norm.x*255, 255, norm.y*255, gradient * 255);
    vertex(v0.x, v0.y);
    vertex(v1.x, v1.y);
    vertex(v2.x, v2.y);

    vertex(v3.x, v3.y);
    vertex(v4.x, v4.y);
    vertex(v5.x, v5.y);
  }
  endShape();
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

