JSONArray linePathFile;
boolean load;


ArrayList<Path> pathlist;
ArrayList<Follower> followerlist;

boolean debug = false;
char[] charList = {'0', '1', '2', '3', '4', '5', '6', '7', '8'};
char shapeIndex = '0';
float scaleShape = 15;

void setup() {
  size(1280, 720, P2D); //FX2D opacity not work
  smooth(8);
  colorMode(HSB, 360, 100, 100, 100);
  loadJsonFile(linePathFile, "linePath_RAW");
  followerlist = new ArrayList<Follower>();
  for (int i = 0; i < pathlist.size(); i++)
  {
    Path p = pathlist.get(i);
    followerlist.add(new Follower(p));
  }

  noStroke();
}

void draw()
{
  background(0);
  /*fill(0, 75);
   rect(0, 0, width, height);*/

  for (int i = 0; i < pathlist.size(); i++)
  {
    Path p = pathlist.get(i);
    p.enableStyle(false);
    stroke(0, 0, 100);
    /* if (shapeIndex == '0')
     {
     p.displayLerpShape(scaleShape);
     } else if (shapeIndex == '1')
     {
     p.displayLerpShapeSinScale(scaleShape);
     } else if (shapeIndex == '2')
     {
     p.displayLerpShapeNoiseSinScale(scaleShape, 1);
     } else if (shapeIndex == '3')
     {
     p.displayLerpShapeNoiseScale(scaleShape, 1);
     } else if (shapeIndex == '4')
     {
     p.displayLerpShapeRandomScale(2, scaleShape);
     } else if (shapeIndex == '5')
     {
     p.displayLerpShapeRandomSinScale(2, scaleShape);
     } else if (shapeIndex == '6')
     {
     p.displayLerpShapeRandomGaussianScale(0.5, scaleShape);
     } else if (shapeIndex == '7')
     {
     p.displayLerpShapeRandomGaussianSinScale(0.5, scaleShape);
     } else if (shapeIndex == '8')
     {
     }
     */
    if (debug)
    {
      stroke(0, 100, 100);
      noFill();
      p.displayRawPath();
      p.displayLerpStep(5);
      p.displayLerpNormal(10);
    } else
    {
    }
  }

  for (Follower f : followerlist)
  {
    f.run();
    f.displayFollower();
    f.displayTail();
  }

  //noLoop();
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
    /*for (Follower f : followerlist)
     {
     f.updateVariable();
     }*/
  }
  for (char c : charList)
  {
    if (key == c)
    {
      shapeIndex = key;
    }
  }
  loop();
}