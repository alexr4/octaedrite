JSONArray linePathFile;
boolean load;


ArrayList<Path> pathlist;
ArrayList<Follower> followerlist;

boolean debug = false;
char[] charList = {'0', '1', '2', '3', '4', '5', '6', '7', '8'};
char shapeIndex = '0';
float scaleShape = 1;

int globalIndex;

void setup() {
  size(1280, 720, P3D); //FX2D opacity not work
  smooth(8);
  //fullScreen(P3D);
  //OSCCLIENT
  initOSCP5("169.254.138.244", 1111);

  loadJsonFile(linePathFile, "linePath_RAW");
  followerlist = new ArrayList<Follower>();

  for (int i = 0; i < pathlist.size(); i++)
  {
    Path p = pathlist.get(i);
    followerlist.add(new Follower(p, i, 1, 0.5, 6, 1));
  }

  noStroke();
}

void draw()
{
  background(0);

  strokeWeight(0.5);
  noFill();
  for (Path p : pathlist)
  {
    p.displayLerpNormal(10);
    //p.displayLerpShape();
    //p.displayLerpShapeSinScale();
    // p.displayLerpShapeNoiseSinScale();
    //p.displayLerpShapeNoiseScale();
    //p.displayLerpShapeRandomScale();
    //p.displayLerpShapeRandomSinScale();
    //p.displayLerpShapeRandomGaussianScale();
    //p.displayLerpShapeRandomGaussianSinScale();
  }

  for (int i=0; i<followerlist.size(); i++)
  {
    Follower f = followerlist.get(i);
    //f.showPath();

    if (f.getFinalEndAnimation())
    {
      //followerlist.remove(i);
    } else
    {
      
      f.run();
     // f.displayFollower();
      //f.displayLineDebugger();
      f.displayTail();
     // f.setSpeed(random(1));
      //f.setWeight(random(1));
    }
  }


  surface.setTitle("FPS : "+round(frameRate));
}

void keyPressed()
{
  if (key == 'd' || key == 'D')
  {
    debug = !debug;
  }

  if (key == 'u' || key == 'U')
  {
    for (Follower f : followerlist)
    {
    }
  }
  for (int i=0; i<charList.length; i++)
  {
    char c = charList[i];
    if (key == c)
    {
      shapeIndex = key;
      for (Follower f : followerlist)
      {
        f.setShapeStyle(i);
        f.updateFollowerVariables();
      }
    }
  }
}

void mousePressed()
{
  // noLoop();
  /* if (mouseButton == LEFT) {
   followerlist.add(new Follower(pathlist.get(0), 0, 1, 1, 6, 1));
   } else if (mouseButton == RIGHT)
   {
   //println(followerlist.size());
   followerlist.get(0).onOff = 0;
   followerlist.get(0).setEndSpeed(1);
   } else
   {
   }*/
}

void mouseReleased()
{
  loop();
}