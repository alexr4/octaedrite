class Follower
{
  float speed;
  float eta;
  float vd;
  float sinWave;
  float orientation;
  float vdOrientation;


  Path path;
  int shapeStyle;
  int headLocIndex;
  int tailLocIndex;
  int tailLimit;
  int actualTailLimit;
  int middleTailLimit;
  int tailFade;
  ArrayList<PVector> centerPath;
  ArrayList<PVector> shapePath;  
  ArrayList<Integer> tailEvenIndex;
  ArrayList<Integer> tailOddIndex;

  //motion

  Follower(Path p, float speed_)
  {
    speed = speed_;
    path = p;
    shapeStyle = 0;
    initVariables();
  }

  Follower(Path p, float speed_, int shapeStyle_)
  {
    speed = speed_;
    shapeStyle = shapeStyle_;
    path = p;
    initVariables();
  }

  void initVariables()
  {
    vdOrientation = 1;
    centerPath = path.getRawLerpVertList();
    shapePath = path.getList(shapeStyle);
    tailEvenIndex = new ArrayList<Integer>();
    tailOddIndex = new ArrayList<Integer>();
    
    
    actualTailLimit = 0;
    tailLimit = centerPath.size();
    tailFade = 3;
    middleTailLimit = tailLimit/2;

    for (int i=0; i<shapePath.size(); i++)
    {
      if (i%2 == 0)
      {
        tailEvenIndex.add(i);
      } else
      {
        tailOddIndex.add(i);
      }
    }

    vd = TWO_PI / speed;
  }

  void run()
  {
    updateDegrees();
    headLocIndex = round(norm(eta, 0, TWO_PI) * (centerPath.size()-2));
    tailLocIndex = round(norm(eta, 0, TWO_PI) * (tailOddIndex.size()-1));
    updateTailLimit();
  }

  void updateTailLimit()
  {

    if (tailLocIndex > tailLimit)
    {
      actualTailLimit = tailLocIndex - tailLimit;
      // middleTailLimit = actualTailLimit+(tailLocIndex-actualTailLimit)/2;
    }
  }

  void updateDegrees()
  {
    //vd = noise(frameCount*0.01) * TWO_PI;
    //println(vd);
    
    eta += vd * vdOrientation;
    
    //eta = vd;

    if (eta >= TWO_PI || eta <= 0)
    {
      vdOrientation *= -1;
      orientation -= PI;
    }
  }

  void displayTail()
  {
    pushStyle();
    fill(0, 0, 100);
    beginShape(TRIANGLE_STRIP);
    for (int i=tailLocIndex; i>=actualTailLimit; i--)
    {
      if (i<tailOddIndex.size()-1 && i<centerPath.size()-1)
      {

        float lerpLevel = 1;
        if (i > tailLocIndex-tailFade)
        {
          lerpLevel = map(i, tailLocIndex-tailFade, tailLocIndex, 0, 1);
        } else if (i < actualTailLimit+tailFade)
        {
          lerpLevel = map(i, actualTailLimit, actualTailLimit+tailFade, 1, 0);
        } else
        {
          lerpLevel = 0;
        }

        int odd = tailOddIndex.get(i);
        int even = tailEvenIndex.get(i);

        PVector v0 = shapePath.get(odd).copy().lerp(centerPath.get(i).copy(), lerpLevel);
        PVector v1 = shapePath.get(even).copy().lerp(centerPath.get(i).copy(), lerpLevel);

        vertex(v0.x, v0.y);
        vertex(v1.x, v1.y);
      }
    }
    endShape();
    popStyle();
  }

  void displayLineDebugger()
  {
    pushStyle();
    stroke(160, 100, 100);
    beginShape();
    for (int i=tailLocIndex; i>= actualTailLimit; i--)
    {
      if (i<centerPath.size()-1)
      {
        PVector v0 = centerPath.get(i);
        vertex(v0.x, v0.y);
      }
    }
    endShape();
    popStyle();
  }

  void displayFollower()
  {
    pushMatrix();
    pushStyle();
    translate(centerPath.get(headLocIndex).x, centerPath.get(headLocIndex).y);
    rotate(path.getAngleAtLerp(centerPath, headLocIndex) + orientation);
    noStroke();
    fill(0, 00, 100);
    rectMode(CENTER);
    rect(0, 0, 5, 5);
    //ellipse(0, 0, scaleTail * 2, scaleTail * 2);
    stroke(220, 100, 100);
    line(0, 0, 20, 0);
    popStyle();
    popMatrix();
  }

  void updateFollowerVariables()
  {
    initVariables();
  }

  //Set
  void setSpeed(float s)
  {
    speed = s;
    vd = TWO_PI/speed;
  }

  void setShapeStyle(int s)
  {
    shapeStyle = s;
  }
}