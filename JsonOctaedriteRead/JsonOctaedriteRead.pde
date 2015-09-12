JSONArray linePathFile;
boolean load;

PShape linePath;
ArrayList<Vec4> colorList;
ArrayList<Float> weightList;
ArrayList<PShape> shapeList;
ArrayList<ArrayList<PVector>> vertList;

void setup() {
  size(1280, 720, P3D);
  loadJsonFile(linePathFile, "linePath_RAW");
  smooth(8);
}

void draw()
{
  background(0);
  for (PShape sh : shapeList)
  {
    shape(sh);
  }
}