void loadJsonFile(JSONArray jsonfile, String fileName)
{
  colorList = new ArrayList<Vec4>();
  weightList = new ArrayList<Float>();
  shapeList = new ArrayList<PShape>();
  vertList = new ArrayList<ArrayList<PVector>>();

  if (!load)
  {
    jsonfile = loadJSONArray(fileName+".json");
    println("Number of shapes on the JSONFile : "+jsonfile.size ());


    for (int i = 0; i < jsonfile.size (); i++) {
      println("Creates shape : "+i);
      JSONArray path = jsonfile.getJSONArray(i);

      ArrayList<PVector> shapeVertList = new ArrayList<PVector>();
      PShape pathShape = createShape();
      pathShape.beginShape();
      pathShape.noFill();

      for (int j = 0; j < path.size (); j++) {
        JSONObject item = path.getJSONObject(j);
        if (j == 0) //get le colorList
        {
          println("\n\tshape : "+i+" — item : "+j+" : Color : "+item);
          float r = item.getFloat("stroke.r");
          float g = item.getFloat("stroke.g");
          float b = item.getFloat("stroke.b");
          float a = item.getFloat("stroke.a");

          Vec4 vertColor = new Vec4(r, g, b, a);
          colorList.add(vertColor);

          pathShape.stroke(vertColor.x, vertColor.y, vertColor.z, vertColor.w);
        } else if (j == 1) //get le weightList
        {
          println("\tshape : "+i+" — item : "+j+" : stroke weight : "+item.getInt("strokeWidth"));
          float weight = item.getInt("strokeWidth");

          pathShape.strokeWeight(weight);
        } else
        {
          float vertx = item.getFloat("line.x");
          float verty = height + item.getFloat("line.y"); //Hack : it's seems drawScript set y value from height - y
          PVector vert = new PVector(vertx, verty);
          println("\tshape : "+i+" — item : "+j+" : vertex : "+vert);
          
          shapeVertList.add(vert);
          pathShape.vertex(vert.x, vert.y);
        }
      }
      pathShape.endShape();
      shapeList.add(pathShape);
      vertList.add(shapeVertList);
    }
    load = true;
  }
}