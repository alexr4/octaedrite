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
      pathlist.add(new Path(path, i, 500, 1920, 1080, w_, h_, scaleShape, 1, 2, scaleShape, 0.5));
    }
    load = true;
  }
}

void initScene00()
{
  //path JSON
  loadJsonFile(linePathFile, "linePath_RAW", octaedrite.octaWidth, octaedrite.octaHeight);
  followerlistScene00 = new ArrayList<Follower>();
  lightList = new ArrayList<PtLight>();

  //forDebugOnly
  /*for (int i = 0; i < pathlist.size(); i++)
   {
   Path p = pathlist.get(i);
   followerlist.add(new Follower(p, i, 1, 0.5, 6, 1));
   lightList.add(new PtLight(new PVector(0, 0, 50), new PVector(255, 255, 255)));
   }
   */
}

void initScene0101()
{
  ofListScene0101 = new ArrayList<OutlineFollower>();
  ofLimitScene0101 = 10;

/*
  float res = 1.0 / ofLimitScene0101;
  for (int i = 0; i< ofLimitScene0101; i++)
  {
    float begin = i * res;//random(0, 0.90);
    float end = random(begin, 1);//begin + res;//random(begin, 1);
    ofListScene0101.add(new OutlineFollower(i, 1, vertList, begin, end, globalCoord, random(0.05, 0.1)));
  }
  */
}