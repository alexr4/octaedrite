void loadJsonFile(JSONArray jsonfile, String fileName, float w_, float h_)
{
  pathlist =  new ArrayList<Path>();

  if (!load)
  {
    jsonfile = loadJSONArray(fileName+".json");
    println("Number of shapes on the JSONFile : "+jsonfile.size ());


    for (int i = 0; i < jsonfile.size (); i++) {
      println("Creates shape : "+i);
      JSONArray path = jsonfile.getJSONArray(i);
      pathlist.add(new Path(path, i, 1000, 1920, 1080, w_, h_, scaleShape, 1, 2, scaleShape, 0.5));
    }
    load = true;
  }
}

void initScene00()
{
  //path JSON
  loadJsonFile(linePathFile, "linePath_RAW", octaedrite.octaWidth, octaedrite.octaHeight);
  followerlist = new ArrayList<Follower>();
  lightList = new ArrayList<PtLight>();

  for (int i = 0; i < pathlist.size(); i++)
  {
    Path p = pathlist.get(i);
    followerlist.add(new Follower(p, i, 1, 0.5, 6, 1));
    lightList.add(new PtLight(new PVector(0, 0, 50), new PVector(255, 255, 255)));
  }
}