class OutlineFollower
{
  int index;
  ArrayList<PVector> originalPathList;

  //Lead
  PVector lead;
  float speedNoise;
  float noisePosition;

  //new path
  int limitNewPath;
  ArrayList<PVector> newPath;
  float minDistForPath;
  float meanForDiviation;
  ArrayList<Float> intensityList;

  OutlineFollower(int index_, ArrayList<PVector> globalList, float begin, float end, PVector anchor)
  {
    index = index_;
    initOriginalPathList(globalList, begin, end, anchor);
    initVariables();
    updateLead();
  }

  void initVariables()
  {

    lead = new PVector();
    speedNoise = random(0.001, 0.01);
    newPath = new ArrayList<PVector>();

    minDistForPath = 1;
    meanForDiviation= 5;
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
    }
    catch(Exception e)
    {
      println(e);
    }
  }

  void updateLead()
  {
    int newLeadIndex = round(noise(noisePosition) * originalPathList.size());
    noisePosition += speedNoise;

    lead = originalPathList.get(newLeadIndex).copy();
    computeNoiseNewPath(lead);
  }

  void limitNewPath()
  {
    if (newPath.size() > limitNewPath)
    {
      newPath.remove(0);
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
      intensityList.add(gaussian * 255);
    }
  }

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
    beginShape();
    for (int i = 0; i<newPath.size(); i++)
    {
      PVector v = newPath.get(i).copy();
      float intensity = intensityList.get(i);
      stroke(255, intensity);
      vertex(v.x, v.y);
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

  void clearAllPath()
  {
    newPath.clear();
    initVariables();
    updateLead();
  }
}