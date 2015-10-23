class Follower
{
  int index;

  float speed;
  float eta;
  float gamma;
  float maxSpeed;
  float vd;
  float sinWave;
  float orientation;
  float vdOrientation;
  int onOff;
  float weight;
  float endSpeed;
  float opacity;


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
  boolean sendOscAtEnd;
  boolean finalEndAnimation;

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

  Follower(Path p, int index_, int onOff_, float speed_, int shapeStyle_, float weight_)
  {
    opacity = 255;
    maxSpeed = 0.01;
    index = index_;
    speed = speed_ * maxSpeed;
    shapeStyle = shapeStyle_;
    weight = weight_;
    onOff = onOff_;
    path = p;
    path.initLerpShape(weight, 0, 0, 0, weight*0.2);
    initVariables();
  }

  void initVariables()
  {
    centerPath = path.getRawLerpVertList();
    shapePath = path.getList(shapeStyle);
    tailEvenIndex = new ArrayList<Integer>();
    tailOddIndex = new ArrayList<Integer>();
    tailLimit = centerPath.size();
    vdOrientation = 1;

    actualTailLimit = 0;
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
    if (onOff == 1)
    {
      if (tailLocIndex >= tailOddIndex.size()-1)
      {
        if (!sendOscAtEnd)
        {
          println("end animation");
          sendMessage(index, 1);
          sendOscAtEnd = true;
        }
      } else
      {
        //println(eta, headLocIndex, centerPath.size()-2, tailLocIndex, tailOddIndex.size()-1);
        updateDegrees();
      }
    } else if (onOff == 0)
    {
      updateTailLimit();
      checkFinalEndAnimation();
    }


    tailLocIndex = round(eta * (tailOddIndex.size()-1));
    headLocIndex = round(eta * centerPath.size()-2);
  }

  void updateTailLimit()
  {
    if (tailLocIndex+2 >= tailLimit && !getFinalEndAnimation())
    {

      gamma += endSpeed;

      actualTailLimit = round(gamma * (tailOddIndex.size()-1));
    }
  }

  void checkFinalEndAnimation()
  {
    if (actualTailLimit >= tailLocIndex)
    {
      println("final end animation");
      finalEndAnimation = true;
      sendMessage(index, -1);
    } else
    {
      finalEndAnimation = false;
    }
  }

  void updateDegrees()
  {
    //vd = noise(frameCount*0.01) * TWO_PI;
    //println(vd);
    if (eta > 1.0)
    {
    } else
    {
      eta += speed;//vd * vdOrientation;
    }

    //eta = vd;

    /*if (eta >= TWO_PI || eta <= 0)
     {
     vdOrientation *= -1;
     orientation -= PI;
     }*/
  }

  void displayTail()
  {
    pushStyle();
    fill(255, opacity);
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
    stroke(255, 0, 255);
    noFill();
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
    fill(255);
    rectMode(CENTER);
    rect(0, 0, 5, 5);
    //ellipse(0, 0, scaleTail * 2, scaleTail * 2);
    stroke(255, 0, 255);
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
    speed = s * maxSpeed;
  }

  void setShapeStyle(int s)
  {
    shapeStyle = s;
  }

  void setWeight(float w)
  {
    path.initLerpShape(w, 0, 0, 0, w-2);
    //initShape();
  }

  void setEndSpeed(float s)
  {
    endSpeed = s * maxSpeed;
  }

  void setOpacity(float s)
  {
    opacity = s * 255;
  }

  //get
  boolean getFinalEndAnimation()
  {
    return finalEndAnimation;
  }
}