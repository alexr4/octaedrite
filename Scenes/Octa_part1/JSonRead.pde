void loadJsonFile(JSONArray jsonfile, String fileName)
{
  pathlist =  new ArrayList<Path>();

  if (!load)
  {
    jsonfile = loadJSONArray(fileName+".json");
    println("Number of shapes on the JSONFile : "+jsonfile.size ());


    for (int i = 0; i < jsonfile.size (); i++) {
      println("Creates shape : "+i);
      JSONArray path = jsonfile.getJSONArray(i);
      pathlist.add(new Path(path, i, 1000, width, height, scaleShape, 1,  2, scaleShape, 0.5));
    }
    load = true;
  }
}