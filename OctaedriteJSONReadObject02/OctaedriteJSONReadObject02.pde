JSONArray linePathFile;
boolean load;


ArrayList<Path> pathlist;

boolean debug = false;
char[] charList = {'0', '1', '2', '3', '4', '5', '6', '7', '8'};
char shapeIndex = '0';
float scaleShape = 10;

void setup() {
  size(1280, 720, P3D); //FX2D opacity not work
  smooth(8);
  colorMode(HSB, 360, 100, 100, 100);
  loadJsonFile(linePathFile, "linePath_RAW");


  noStroke();
}

void draw()
{
  background(0);

  //stroke(0, 0, 100);
  noStroke();
  fill(0, 0, 100);
  //noFill();
  for (int i = 0; i < pathlist.size()-1; i++)
  {
    Path p = pathlist.get(i);
    p.enableStyle(false);

    if (shapeIndex == '0')
    {
      p.displayLerpShape();
    } else if (shapeIndex == '1')
    {
      p.displayLerpShapeSinScale();
    } else if (shapeIndex == '2')
    {
      p.displayLerpShapeNoiseSinScale();
    } else if (shapeIndex == '3')
    {
      p.displayLerpShapeNoiseScale();
    } else if (shapeIndex == '4')
    {
      p.displayLerpShapeRandomScale();
    } else if (shapeIndex == '5')
    {
      p.displayLerpShapeRandomSinScale();
    } else if (shapeIndex == '6')
    {
      p.displayLerpShapeRandomGaussianScale();
    } else if (shapeIndex == '7')
    {
      p.displayLerpShapeRandomGaussianSinScale();
    } else if (shapeIndex == '8')
    {
    }

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
  
  surface.setTitle("FPS : "+round(frameRate));
}

void keyPressed()
{
  if (key == 'd' || key == 'D')
  {
    debug = !debug;
  }

  for (char c : charList)
  {
    if (key == c)
    {
      shapeIndex = key;
    }
  }
}