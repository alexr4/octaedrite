JSONArray linePathFile;
boolean load;


ArrayList<Path> pathlist;
ArrayList<Follower> followerlist;

boolean debug;

void setup() {
  size(1280, 720, P3D); //FX2D opacity not work
  smooth(8);
  colorMode(HSB, 360, 100, 100, 100);
  loadJsonFile(linePathFile, "linePath_RAW");
  followerlist = new ArrayList<Follower>();
  for (int i = 0; i < pathlist.size(); i++)
  {
    Path p = pathlist.get(i);
    followerlist.add(new Follower(p));
  }
}

void draw()
{
  background(0);
  /*fill(0, 75);
  rect(0, 0, width, height);*/
  
  
   if (debug)
  {
    for (int i = 0; i < pathlist.size(); i++)
    {
      Path p = pathlist.get(i);
      p.enableStyle(false);
      stroke(0, 100, 100);
      noFill();
      p.displayRawPath();
      p.displayLerpStep(5);
      p.displayLerpNormal(10);
    }
  }
  
  for (Follower f : followerlist)
  {
    f.run();
    f.displayFollower();
    f.displayTail();
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
      f.updateVariable();
    }
  }
}