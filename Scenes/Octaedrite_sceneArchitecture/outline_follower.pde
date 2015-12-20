class OutlineFollower
{
  int index;
  ArrayList<PVector> originalPathList;
  PVector origin;
  PVector fin;

  //angle & radius
  float eta, gamma;
  float minRadius, maxRadius;

  //Lead
  PVector lead;
  float normalPosition;
  float speedNoise;
  float noisePosition;
  boolean finished;
  boolean kill;

  //new path
  int limitNewPath;
  ArrayList<PVector> newPath;
  float minDistForPath;
  float meanForDiviation;
  ArrayList<Float> intensityList;


  OutlineFollower(int index_, int onOff, ArrayList<PVector> globalList, float begin, float end, PVector anchor, float speed_)
  {
    index = index_;
    if (onOff == 1)
    {
      finished = false;
      kill = false;
    } else if (onOff ==0)
    {
      finished = true;
      kill = false;
    } else if (onOff ==-1)
    {
      finished = true;
      kill = true;
    }

    speedNoise = speed_;

    initOriginalPathList(globalList, begin, end, anchor);
    initVariables();
    updateLead();
  }

  void initVariables()
  {

    lead = new PVector();
    //speedNoise = random(0.001, 0.01);
    newPath = new ArrayList<PVector>();

    minDistForPath = 1;
    meanForDiviation= 5;
    limitNewPath = round(random(500, 1000));
    intensityList = new ArrayList<Float>();
  }

  void initOriginalPathList(ArrayList<PVector> globalList, float begin, float end, PVector anchor)
  {
    try {
      originalPathList = new ArrayList<PVector>();
      int beginIndex = round(begin * (globalList.size()-1));
      int endIndex = round(end * (globalList.size()-1));

      for (int i=beginIndex; i<endIndex; i++)
      {
        PVector pathVertex = globalList.get(i).copy();
        pathVertex.add(anchor);
        originalPathList.add(pathVertex);
      }

      origin = originalPathList.get(0);
      fin = originalPathList.get(originalPathList.size()-1);

      eta = getAngleFromCenter(origin);
      gamma = getAngleFromCenter(fin);

      //println(degrees(eta), degrees(gamma));
      computeMinMaxRadius();
      //println(origin, fin);
    }
    catch(Exception e)
    {
      println("Found an error at initOriginalPathList "+e);
    }
  }

  void computeMinMaxRadius()
  {
    minRadius = 1920;
    for (PVector v : originalPathList)
    {
      float d = PVector.dist(v, center);
      if (d < minRadius)
      {
        minRadius = d;
      }
    }

    maxRadius = minRadius;
    for (PVector v : originalPathList)
    {
      float d = PVector.dist(v, center);
      if (d > maxRadius)
      {
        maxRadius = d;
      }
    }

    //println(minRadius, maxRadius);
  }

  //run
  void run()
  {
    if (!kill)
    {
      //limitNewPath();
      displayNewPath();
      if (!finished)
      {
        updateLead();
        sendMessage("/P5_scene01_01", index, getNormLeadAngle(), getNormRadius(), normalPosition, intensityList.get(intensityList.size()-1));
      }
    }
  }

  void run(PGraphics buffer)
  {
    if (!kill)
    {
      //limitNewPath();
      displayNewPath(buffer);
      if (!finished)
      {
        updateLead();
        sendMessage("/P5_scene01_01", index, getNormLeadAngle(), getNormRadius(), normalPosition, intensityList.get(intensityList.size()-1));
      }
    }
  }


  void updateLead()
  {
    normalPosition = noise(noisePosition);
    int newLeadIndex = round(normalPosition * originalPathList.size());
    noisePosition += speedNoise;

    if (newLeadIndex < originalPathList.size())
    {
      lead = originalPathList.get(newLeadIndex).copy();
      computeNoiseNewPath(lead);
    }
  }

  void limitNewPath()
  {
    if (newPath.size() >= limitNewPath)
    {
      finished = true;
      //newPath.remove(0);
    }
  }

  void computeNoiseNewPath(PVector v)
  {
    float oMag = v.mag();
    float mean = meanForDiviation;
    float gaussian = noise(frameCount * 0.01);
    float newMag = (sin(frameCount * 0.01)*(gaussian * mean)) + oMag;

    v.normalize();
    v.mult(newMag);

    if (newPath.size() == 0 || PVector.dist(v, newPath.get(newPath.size()-1).copy()) > minDistForPath)
    {
      newPath.add(v);
      intensityList.add(gaussian);
    }
  }
  //---------------------------------------------------------------
  //DISPLAY
  //---------------------------------------------------------------
  void displayLead()
  {
    pushStyle();
    fill(255);
    noStroke();
    ellipse(lead.x, lead.y, 5, 5);
    popStyle();
  }

  void displayNewPath()
  {
    pushStyle();
    noFill();
    stroke(255);
    /*
    beginShape();
     for (int i = 1; i<newPath.size(); i++)
     {
     PVector v1 = newPath.get(i).copy();
     PVector v0 = newPath.get(i-1).copy();
     float distv0v1 = PVector.dist(v1, v0);
     float opacity = map(distv0v1, 0, 25, 255, 0);
     float intensity = intensityList.get(i);
     stroke(255, opacity);//intensity * 255);
     
     vertex(v1.x, v1.y);
     }
     endShape();*/
    beginShape();
    float minDist = 20;
    for (int i = 1; i<newPath.size(); i++)
    {
      PVector v1 = newPath.get(i).copy();
      PVector v0 = newPath.get(i-1).copy();
      float distv0v1 = PVector.dist(v1, v0);
      float opacity = map(distv0v1, 0, minDist, 255, 0);
      float intensity = intensityList.get(i);
      if (distv0v1 < minDist)
      {
        stroke(255, opacity);//intensity * 255);

        /*
        beginShape(LINES);
         vertex(v1.x, v1.y);
         vertex(v0.x, v0.y);
         endShape();
         */
        //line(v1.x, v1.y, v0.x, v0.y);
      } else
      {
        stroke(255, 0, 0, 0);
      }
      vertex(v0.x, v0.y);
      vertex(v1.x, v1.y);
    }
    endShape();
    popStyle();
  }

  void debugOriginalPath(float intensity)
  {
    pushStyle();
    colorMode(HSB, originalPathList.size(), 100, 100);
    noFill();
    beginShape();
    for (int i=0; i<originalPathList.size(); i++)
    {
      PVector vert = originalPathList.get(i).copy();
      stroke(i, 100, 100, 255 * intensity);
      vertex(vert.x, vert.y);
    }
    endShape();
    popStyle();
  }

  //------------------------------------------------------------
  //BUFFERS
  //------------------------------------------------------------
  void displayLead(PGraphics buffer)
  {
    buffer.pushStyle();
    buffer.fill(255);
    buffer.noStroke();
    buffer.ellipse(lead.x, lead.y, 5, 5);
    buffer.popStyle();
  }

  void displayNewPath(PGraphics buffer)
  {
    buffer.pushStyle();
    buffer.noFill();
    buffer.stroke(255);
    /*
    beginShape();
     for (int i = 1; i<newPath.size(); i++)
     {
     PVector v1 = newPath.get(i).copy();
     PVector v0 = newPath.get(i-1).copy();
     float distv0v1 = PVector.dist(v1, v0);
     float opacity = map(distv0v1, 0, 25, 255, 0);
     float intensity = intensityList.get(i);
     stroke(255, opacity);//intensity * 255);
     
     vertex(v1.x, v1.y);
     }
     endShape();*/
    buffer.beginShape();
    float minDist = 20;
    for (int i = 1; i<newPath.size(); i++)
    {
      PVector v1 = newPath.get(i).copy();
      PVector v0 = newPath.get(i-1).copy();
      float distv0v1 = PVector.dist(v1, v0);
      float opacity = map(distv0v1, 0, minDist, 255, 0);
      float intensity = intensityList.get(i);
      if (distv0v1 < minDist)
      {
        buffer.stroke(255, opacity);//intensity * 255);

        /*
        beginShape(LINES);
         vertex(v1.x, v1.y);
         vertex(v0.x, v0.y);
         endShape();
         */
        //line(v1.x, v1.y, v0.x, v0.y);
      } else
      {
        buffer.stroke(255, 0, 0, 0);
      }
      buffer.vertex(v0.x, v0.y);
      buffer.vertex(v1.x, v1.y);
    }
    buffer.endShape();
    buffer.popStyle();
  }

  void debugOriginalPath(float intensity, PGraphics buffer)
  {
    buffer.pushStyle();
    buffer.colorMode(HSB, originalPathList.size(), 100, 100);
    buffer.noFill();
    buffer.beginShape();
    for (int i=0; i<originalPathList.size(); i++)
    {
      PVector vert = originalPathList.get(i).copy();
      buffer.stroke(i, 100, 100, 255 * intensity);
      buffer.vertex(vert.x, vert.y);
    }
    buffer.endShape();
    buffer.popStyle();
  }

  void clearAllPath()
  {
    kill = true;
    //newPath.clear();
    //initVariables();
    //updateLead();
  }

  //get
  float getAngleFromCenter(PVector vert)
  {
    PVector ctov = PVector.sub(vert, center);
    ctov.normalize();
    PVector axis = new PVector(1, 0);
    float phi = PVector.angleBetween(ctov, axis);

    PVector cross = ctov.cross(axis);
    //println(cross);

    if (cross.z > 0)
    {
      phi = TWO_PI - (PI + phi) -HALF_PI;
    } else
    {
    }

    if (degrees(phi) <0)
    {
      phi = PI + abs(phi);
    }

    return phi;
  }

  float getNormLeadAngle()
  {
    float beta = getAngleFromCenter(lead);
    float e = norm(beta, eta, gamma);

    return e;
  }

  float getNormRadius()
  {
    float radius = PVector.dist(lead, center);
    float normRad = norm(radius, minRadius, maxRadius);
    normRad = constrain(normRad, 0.0, 1.0);

    return normRad;
  }
}