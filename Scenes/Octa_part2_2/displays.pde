
void displayOCVsource(boolean state, float scale)
{
  pushStyle();
  if (state)
  {
    image(src, 0, 0, diffuse.width * scale, diffuse.height * scale);
    stroke(0, 0, 0);
    noFill();
    rect(0, 0, diffuse.width * scale, diffuse.height * scale);
  } else
  {
  }
  popStyle();
}

void displayDiffuse(boolean state, PVector coord, float scale)
{
  if (state)
  {
    pushStyle();
    pushMatrix();
    translate(coord.x, coord.y);
    rectMode(CENTER);
    image(diffuse, 0, 0, diffuse.width * scale, diffuse.height * scale);
    popMatrix();
    popStyle();
  } else
  {
  }
}

void displayPath(boolean state, PVector coord)
{
  if (state)
  {
    pushStyle();
    stroke(127, 0, 0);
    pushMatrix();
    translate(coord.x, coord.y);
    noFill();
    beginShape();
    for (PVector v : vertList)
    {
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    popMatrix();
    popStyle();
  }
}

void displayShape(boolean state, PVector coord)
{
  if (state)
  {
    pushStyle();
    pushMatrix();
    translate(coord.x, coord.y);
    shape(octa);
    popMatrix();
    popStyle();
  } else
  {
  }
}

void displayShapeCenter(boolean state, PVector coord)
{
  if (state)
  {
    pushStyle();
    pushMatrix();
    translate(coord.x, coord.y);
    fill(255, 0, 0);
    ellipse(octaCenter.x, octaCenter.y, 20, 20);
    popMatrix();
    popStyle();
  } else
  {
  }
}

void displayOrientationArrow(boolean state, PVector coord)
{
  if (state)
  {
    pushStyle();
    pushMatrix();
    translate(coord.x, coord.y);
    //ArrowDebug
    displayOrientationArrow(20, 25);
    popMatrix();
    popStyle();
  } else
  {
  }
}

void displayNormals(boolean state, PVector coord)
{
  if (state)
  {
    pushStyle();
    pushMatrix();
    translate(coord.x, coord.y);

    //normals
    displayNormals(10);
    popMatrix();
    popStyle();
  } else
  {
  }
}

void displayFollower(boolean state, PVector coord, boolean mode)
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
    pushStyle();
    pushMatrix();
    translate(coord.x, coord.y);

    displayFollower();
    popMatrix();
    popStyle();
  } else
  {
  }
}

void displayProgressiveShape(boolean state, PVector coord, int length)
{
  if (state)
  {
    pushStyle();
    pushMatrix();
    translate(coord.x, coord.y);

    displayProgressiveShape(length);
    popMatrix();
    popStyle();
  } else
  {
  }
}