class Path
{
  //Raw Data
  int indexPath;
  PShape linePath;
  ArrayList<Vec4> colorList;
  ArrayList<Float> weightList;
  ArrayList<PShape> shapeList;
  ArrayList<ArrayList<PVector>> vertList; 
  ArrayList<PVector> shapeVertList;
  PShape pathShape;

  //lerpData
  float resolution;
  ArrayList<Float> resolutionPerLine;
  ArrayList<PVector> lerpVertList;

  Path(JSONArray jsa, int indexPath_, float resolution_)
  {
    indexPath = indexPath_;
    initVariables(resolution_);
    initPath(jsa, indexPath);
    unwarpPath(1.0);
  }

  void initVariables(float resolution_)
  {

    colorList = new ArrayList<Vec4>();
    weightList = new ArrayList<Float>();
    shapeList = new ArrayList<PShape>();
    vertList = new ArrayList<ArrayList<PVector>>();

    shapeVertList = new ArrayList<PVector>();
    pathShape = createShape();

    resolution = resolution_;
    resolutionPerLine = new ArrayList<Float>();
    lerpVertList = new ArrayList<PVector>();
  }

  void initPath(JSONArray jsa, int indexPath)
  {
    pathShape.beginShape();
    pathShape.noFill();

    for (int j = 0; j < jsa.size (); j++) {
      JSONObject item = jsa.getJSONObject(j);
      if (j == 0) //get le colorList
      {
        println("\n\tshape : "+indexPath+" — item : "+j+" : Color : "+item);
        float r = item.getFloat("stroke.r");
        float g = item.getFloat("stroke.g");
        float b = item.getFloat("stroke.b");
        float a = item.getFloat("stroke.a");

        Vec4 vertColor = new Vec4(r, g, b, a);
        colorList.add(vertColor);

        pathShape.stroke(vertColor.x, vertColor.y, vertColor.z, vertColor.w);
      } else if (j == 1) //get le weightList
      {
        println("\tshape : "+indexPath+" — item : "+j+" : stroke weight : "+item.getInt("strokeWidth"));
        float weight = item.getInt("strokeWidth");

        pathShape.strokeWeight(weight);
      } else
      {
        float vertx = item.getFloat("line.x");
        float verty = height + item.getFloat("line.y"); //Hack : it's seems drawScript set y value from height - y
        PVector vert = new PVector(vertx, verty);
        println("\tshape : "+indexPath+" — item : "+j+" : vertex : "+vert);

        shapeVertList.add(vert);
        pathShape.vertex(vert.x, vert.y);
      }
    }
    pathShape.endShape();
    shapeList.add(pathShape);
    vertList.add(shapeVertList);
  }

  //display
  void displayRawPath()
  {
    for (PShape sh : shapeList)
    {
      shape(sh);
    }
  }

  void displayLerpStep(float scale)
  {
    for (int i=0; i< lerpVertList.size(); i++)
    {
      PVector v = lerpVertList.get(i);
      float hue = map(i, 0, lerpVertList.size(), i, 360);
      noStroke();
      fill(hue, 100, 100);
      ellipse(v.x, v.y, scale, scale);
    }
  }

  void displayLerpNormal(float scale)
  {
    PVector ov0 = lerpVertList.get(0);
    PVector ov1 = lerpVertList.get(1);
    PVector ov0toov1 = PVector.sub(ov1, ov0);
    for (int i=0; i< lerpVertList.size()-1; i++)
    {
      PVector v0 = lerpVertList.get(i);
      PVector v1 = lerpVertList.get(i+1);
      PVector v0tov1 = PVector.sub(v1, v0);
      float eta = -HALF_PI;
      float phi = HALF_PI;
      float ns = scale;

      if ( i > 0)
      {
        PVector n0 = ov0toov1.copy().normalize();//.mult(20).add(new PVector(width/2, height/2));
        PVector n1 = v0tov1.copy().normalize();//.mult(20).add(new PVector(width/2, height/2));

        if ((int)PVector.angleBetween(n0, n1) !=  0)
        {
          PVector cross = n0.cross(n1);
          //println(i, PVector.angleBetween(n0, n1), cross);
          ns = v0tov1.mag() * sqrt(2);
          if (cross.z > 0) //left
          {
            eta = PI+HALF_PI/2;
            phi = PI/2 - HALF_PI/2;
          } else //Right
          {
            eta = -HALF_PI/2;
            phi = PI/2 + HALF_PI/2;
          }
        } else
        {
          eta = -HALF_PI;
          phi = HALF_PI;
          ns = v0tov1.mag();
        }

        ov0toov1 = v0tov1.copy();
      }

      PVector norm0 = v0tov1.copy();
      norm0.normalize();
      norm0.mult(ns);
      norm0.rotate(eta);
      norm0.add(v0);

      PVector norm1 = v0tov1.copy();
      norm1.normalize();
      norm1.mult(ns);
      norm1.rotate(phi);
      norm1.add(v0);

      float hue = map(i, 0, lerpVertList.size(), i, 360);
      stroke(hue, 100, 100);
      line(v0.x, v0.y, norm0.x, norm0.y);
      line(v0.x, v0.y, norm1.x, norm1.y);
    }
  }

  void displayLerpShape(float scale)
  {
    PVector ov0 = lerpVertList.get(0);
    PVector ov1 = lerpVertList.get(1);
    PVector ov0toov1 = PVector.sub(ov1, ov0);
    beginShape(TRIANGLE_STRIP);
    for (int i=0; i< lerpVertList.size()-1; i++)
    {
      PVector v0 = lerpVertList.get(i);
      PVector v1 = lerpVertList.get(i+1);
      PVector v0tov1 = PVector.sub(v1, v0);

      float eta = -HALF_PI;
      float phi = HALF_PI;
      float ns = scale;//v0tov1.mag();

      if ( i > 0)
      {
        PVector n0 = ov0toov1.copy().normalize();//.mult(20).add(new PVector(width/2, height/2));
        PVector n1 = v0tov1.copy().normalize();//.mult(20).add(new PVector(width/2, height/2));

        if ((int)PVector.angleBetween(n0, n1) !=  0)
        {
          PVector cross = n0.cross(n1);
          //println(i, PVector.angleBetween(n0, n1), cross);
          // ns = v0tov1.mag() * sqrt(2);
          if (cross.z > 0) //left
          {
            eta = PI+HALF_PI/2;
            phi = PI/2 - HALF_PI/2;
          } else //Right
          {
            eta = -HALF_PI/2;
            phi = PI/2 + HALF_PI/2;
          }
        } else
        {
          eta = -HALF_PI;
          phi = HALF_PI;
          // ns =  v0tov1.mag();
        }

        ov0toov1 = v0tov1.copy();
      }

      PVector norm0 = v0tov1.copy();
      norm0.normalize();
      norm0.mult(ns);
      norm0.rotate(eta);
      norm0.add(v0);

      PVector norm1 = v0tov1.copy();
      norm1.normalize();
      norm1.mult(ns);
      norm1.rotate(phi);
      norm1.add(v0);

      float hue = map(i, 0, lerpVertList.size(), i, 360);
      fill(hue, 100, 100);

      vertex(norm0.x, norm0.y);
      vertex(norm1.x, norm1.y);
    }
    endShape();
  }

  void displayLerpShapeSinScale(float scale)
  {
    PVector ov0 = lerpVertList.get(0);
    PVector ov1 = lerpVertList.get(1);
    PVector ov0toov1 = PVector.sub(ov1, ov0);
    float period = (lerpVertList.size()-1)*2;
    float dx = (TWO_PI / period);
    float s = 0;
    beginShape(TRIANGLE_STRIP);
    for (int i=0; i< lerpVertList.size()-1; i++)
    {
      PVector v0 = lerpVertList.get(i);
      PVector v1 = lerpVertList.get(i+1);
      PVector v0tov1 = PVector.sub(v1, v0);

      float ns = sin(s) * scale;

      float eta = -HALF_PI;
      float phi = HALF_PI;
      if ( i > 0)
      {
        PVector n0 = ov0toov1.copy().normalize();//.mult(20).add(new PVector(width/2, height/2));
        PVector n1 = v0tov1.copy().normalize();//.mult(20).add(new PVector(width/2, height/2));

        if ((int)PVector.angleBetween(n0, n1) !=  0)
        {
          PVector cross = n0.cross(n1);
          //println(i, PVector.angleBetween(n0, n1), cross);
          // ns = v0tov1.mag() * sqrt(2);
          if (cross.z > 0) //left
          {
            eta = PI+HALF_PI/2;
            phi = PI/2 - HALF_PI/2;
          } else //Right
          {
            eta = -HALF_PI/2;
            phi = PI/2 + HALF_PI/2;
          }
        } else
        {
          eta = -HALF_PI;
          phi = HALF_PI;
          // ns =  v0tov1.mag();
        }

        ov0toov1 = v0tov1.copy();
      }

      PVector norm0 = v0tov1.copy();
      norm0.normalize();
      norm0.mult(ns);
      norm0.rotate(eta);
      norm0.add(v0);

      PVector norm1 = v0tov1.copy();
      norm1.normalize();
      norm1.mult(ns);
      norm1.rotate(phi);
      norm1.add(v0);

      float hue = map(i, 0, lerpVertList.size(), i, 360);
      fill(hue, 100, 100);

      vertex(norm0.x, norm0.y);
      vertex(norm1.x, norm1.y);

      s += dx;
    }
    endShape();
  }

  void displayLerpShapeNoiseSinScale(float scale, float noisePower)
  {
    PVector ov0 = lerpVertList.get(0);
    PVector ov1 = lerpVertList.get(1);
    PVector ov0toov1 = PVector.sub(ov1, ov0);
    float period = (lerpVertList.size()-1)*2;
    float dx = (TWO_PI / period);
    float s = 0;
    beginShape(TRIANGLE_STRIP);
    for (int i=0; i< lerpVertList.size()-1; i++)
    {
      PVector v0 = lerpVertList.get(i);
      PVector v1 = lerpVertList.get(i+1);
      PVector v0tov1 = PVector.sub(v1, v0);

      float ns = sin(s) * (noise(i * (noisePower * 0.1), s) * scale);

      float eta = -HALF_PI;
      float phi = HALF_PI;
      if ( i > 0)
      {
        PVector n0 = ov0toov1.copy().normalize();//.mult(20).add(new PVector(width/2, height/2));
        PVector n1 = v0tov1.copy().normalize();//.mult(20).add(new PVector(width/2, height/2));

        if ((int)PVector.angleBetween(n0, n1) !=  0)
        {
          PVector cross = n0.cross(n1);
          //println(i, PVector.angleBetween(n0, n1), cross);
          // ns = v0tov1.mag() * sqrt(2);
          if (cross.z > 0) //left
          {
            eta = PI+HALF_PI/2;
            phi = PI/2 - HALF_PI/2;
          } else //Right
          {
            eta = -HALF_PI/2;
            phi = PI/2 + HALF_PI/2;
          }
        } else
        {
          eta = -HALF_PI;
          phi = HALF_PI;
          // ns =  v0tov1.mag();
        }

        ov0toov1 = v0tov1.copy();
      }

      PVector norm0 = v0tov1.copy();
      norm0.normalize();
      norm0.mult(ns);
      norm0.rotate(eta);
      norm0.add(v0);

      PVector norm1 = v0tov1.copy();
      norm1.normalize();
      norm1.mult(ns);
      norm1.rotate(phi);
      norm1.add(v0);

      float hue = map(i, 0, lerpVertList.size(), i, 360);
      fill(hue, 100, 100);

      vertex(norm0.x, norm0.y);
      vertex(norm1.x, norm1.y);

      s += dx;
    }
    endShape();
  }

  void displayLerpShapeNoiseScale(float scale, float noisePower)
  { 
    PVector ov0 = lerpVertList.get(0);
    PVector ov1 = lerpVertList.get(1);
    PVector ov0toov1 = PVector.sub(ov1, ov0);
    beginShape(TRIANGLE_STRIP);
    for (int i=0; i< lerpVertList.size()-1; i++)
    {
      PVector v0 = lerpVertList.get(i);
      PVector v1 = lerpVertList.get(i+1);
      PVector v0tov1 = PVector.sub(v1, v0);

      float ns = (noise(i * (noisePower * 0.1)) * scale);

      float eta = -HALF_PI;
      float phi = HALF_PI;
      if ( i > 0)
      {
        PVector n0 = ov0toov1.copy().normalize();//.mult(20).add(new PVector(width/2, height/2));
        PVector n1 = v0tov1.copy().normalize();//.mult(20).add(new PVector(width/2, height/2));

        if ((int)PVector.angleBetween(n0, n1) !=  0)
        {
          PVector cross = n0.cross(n1);
         // println(i, PVector.angleBetween(n0, n1), cross);
          // ns = v0tov1.mag() * sqrt(2);
          if (cross.z > 0) //left
          {
            eta = PI+HALF_PI/2;
            phi = PI/2 - HALF_PI/2;
          } else //Right
          {
            eta = -HALF_PI/2;
            phi = PI/2 + HALF_PI/2;
          }
        } else
        {
          eta = -HALF_PI;
          phi = HALF_PI;
          // ns =  v0tov1.mag();
        }

        ov0toov1 = v0tov1.copy();
      }

      PVector norm0 = v0tov1.copy();
      norm0.normalize();
      norm0.mult(ns);
      norm0.rotate(eta);
      norm0.add(v0);

      PVector norm1 = v0tov1.copy();
      norm1.normalize();
      norm1.mult(ns);
      norm1.rotate(phi);
      norm1.add(v0);

      float hue = map(i, 0, lerpVertList.size(), i, 360);
      fill(hue, 100, 100);

      vertex(norm0.x, norm0.y);
      vertex(norm1.x, norm1.y);
    }
    endShape();
  }

  void displayLerpShapeRandomScale(float minScale, float maxScale)
  {
    PVector ov0 = lerpVertList.get(0);
    PVector ov1 = lerpVertList.get(1);
    PVector ov0toov1 = PVector.sub(ov1, ov0);
    beginShape(TRIANGLE_STRIP);
    for (int i=0; i< lerpVertList.size()-1; i++)
    {
      PVector v0 = lerpVertList.get(i);
      PVector v1 = lerpVertList.get(i+1);
      PVector v0tov1 = PVector.sub(v1, v0);

      float ns = random(minScale, maxScale);

      float eta = -HALF_PI;
      float phi = HALF_PI;
      if ( i > 0)
      {
        PVector n0 = ov0toov1.copy().normalize();//.mult(20).add(new PVector(width/2, height/2));
        PVector n1 = v0tov1.copy().normalize();//.mult(20).add(new PVector(width/2, height/2));

        if ((int)PVector.angleBetween(n0, n1) !=  0)
        {
          PVector cross = n0.cross(n1);
          //println(i, PVector.angleBetween(n0, n1), cross);
          // ns = v0tov1.mag() * sqrt(2);
          if (cross.z > 0) //left
          {
            eta = PI+HALF_PI/2;
            phi = PI/2 - HALF_PI/2;
          } else //Right
          {
            eta = -HALF_PI/2;
            phi = PI/2 + HALF_PI/2;
          }
        } else
        {
          eta = -HALF_PI;
          phi = HALF_PI;
          // ns =  v0tov1.mag();
        }

        ov0toov1 = v0tov1.copy();
      }

      PVector norm0 = v0tov1.copy();
      norm0.normalize();
      norm0.mult(ns);
      norm0.rotate(eta);
      norm0.add(v0);

      PVector norm1 = v0tov1.copy();
      norm1.normalize();
      norm1.mult(ns);
      norm1.rotate(phi);
      norm1.add(v0);

      float hue = map(i, 0, lerpVertList.size(), i, 360);
      fill(hue, 100, 100);

      vertex(norm0.x, norm0.y);
      vertex(norm1.x, norm1.y);
    }
    endShape();
  }

  void displayLerpShapeRandomSinScale(float minScale, float maxScale)
  {
    PVector ov0 = lerpVertList.get(0);
    PVector ov1 = lerpVertList.get(1);
    PVector ov0toov1 = PVector.sub(ov1, ov0);
    float period = (lerpVertList.size()-1)*2;
    float dx = (TWO_PI / period);
    float s = 0;
    beginShape(TRIANGLE_STRIP);
    for (int i=0; i< lerpVertList.size()-1; i++)
    {
      PVector v0 = lerpVertList.get(i);
      PVector v1 = lerpVertList.get(i+1);
      PVector v0tov1 = PVector.sub(v1, v0);

      float ns = sin(s) * random(minScale, maxScale);

      float eta = -HALF_PI;
      float phi = HALF_PI;
      if ( i > 0)
      {
        PVector n0 = ov0toov1.copy().normalize();//.mult(20).add(new PVector(width/2, height/2));
        PVector n1 = v0tov1.copy().normalize();//.mult(20).add(new PVector(width/2, height/2));

        if ((int)PVector.angleBetween(n0, n1) !=  0)
        {
          PVector cross = n0.cross(n1);
          //println(i, PVector.angleBetween(n0, n1), cross);
          // ns = v0tov1.mag() * sqrt(2);
          if (cross.z > 0) //left
          {
            eta = PI+HALF_PI/2;
            phi = PI/2 - HALF_PI/2;
          } else //Right
          {
            eta = -HALF_PI/2;
            phi = PI/2 + HALF_PI/2;
          }
        } else
        {
          eta = -HALF_PI;
          phi = HALF_PI;
          // ns =  v0tov1.mag();
        }

        ov0toov1 = v0tov1.copy();
      }

      PVector norm0 = v0tov1.copy();
      norm0.normalize();
      norm0.mult(ns);
      norm0.rotate(eta);
      norm0.add(v0);

      PVector norm1 = v0tov1.copy();
      norm1.normalize();
      norm1.mult(ns);
      norm1.rotate(phi);
      norm1.add(v0);

      float hue = map(i, 0, lerpVertList.size(), i, 360);
      fill(hue, 100, 100);

      vertex(norm0.x, norm0.y);
      vertex(norm1.x, norm1.y);
      s += dx;
    }
    endShape();
  }

  void displayLerpShapeRandomGaussianScale(float deviation, float middleValue)
  {
    PVector ov0 = lerpVertList.get(0);
    PVector ov1 = lerpVertList.get(1);
    PVector ov0toov1 = PVector.sub(ov1, ov0);
    beginShape(TRIANGLE_STRIP);
    for (int i=0; i< lerpVertList.size()-1; i++)
    {
      PVector v0 = lerpVertList.get(i);
      PVector v1 = lerpVertList.get(i+1);
      PVector v0tov1 = PVector.sub(v1, v0);

      float gauss = randomGaussian();
      float ns = (gauss * deviation) + middleValue;

      float eta = -HALF_PI;
      float phi = HALF_PI;
      if ( i > 0)
      {
        PVector n0 = ov0toov1.copy().normalize();//.mult(20).add(new PVector(width/2, height/2));
        PVector n1 = v0tov1.copy().normalize();//.mult(20).add(new PVector(width/2, height/2));

        if ((int)PVector.angleBetween(n0, n1) !=  0)
        {
          PVector cross = n0.cross(n1);
          //println(i, PVector.angleBetween(n0, n1), cross);
          // ns = v0tov1.mag() * sqrt(2);
          if (cross.z > 0) //left
          {
            eta = PI+HALF_PI/2;
            phi = PI/2 - HALF_PI/2;
          } else //Right
          {
            eta = -HALF_PI/2;
            phi = PI/2 + HALF_PI/2;
          }
        } else
        {
          eta = -HALF_PI;
          phi = HALF_PI;
          // ns =  v0tov1.mag();
        }

        ov0toov1 = v0tov1.copy();
      }

      PVector norm0 = v0tov1.copy();
      norm0.normalize();
      norm0.mult(ns);
      norm0.rotate(eta);
      norm0.add(v0);

      PVector norm1 = v0tov1.copy();
      norm1.normalize();
      norm1.mult(ns);
      norm1.rotate(phi);
      norm1.add(v0);

      float hue = map(i, 0, lerpVertList.size(), i, 360);
      fill(hue, 100, 100);

      vertex(norm0.x, norm0.y);
      vertex(norm1.x, norm1.y);
    }
    endShape();
  }

  void displayLerpShapeRandomGaussianSinScale(float deviation, float middleValue)
  { 
    PVector ov0 = lerpVertList.get(0);
    PVector ov1 = lerpVertList.get(1);
    PVector ov0toov1 = PVector.sub(ov1, ov0);
    float period = (lerpVertList.size()-1)*2;
    float dx = (TWO_PI / period);
    float s = 0;
    beginShape(TRIANGLE_STRIP);
    for (int i=0; i< lerpVertList.size()-1; i++)
    {
      PVector v0 = lerpVertList.get(i);
      PVector v1 = lerpVertList.get(i+1);
      PVector v0tov1 = PVector.sub(v1, v0);

      float gauss = randomGaussian();
      float ns = sin(s) * ((gauss * deviation) + middleValue);

      float eta = -HALF_PI;
      float phi = HALF_PI;
      if ( i > 0)
      {
        PVector n0 = ov0toov1.copy().normalize();//.mult(20).add(new PVector(width/2, height/2));
        PVector n1 = v0tov1.copy().normalize();//.mult(20).add(new PVector(width/2, height/2));

        if ((int)PVector.angleBetween(n0, n1) !=  0)
        {
          PVector cross = n0.cross(n1);
          //println(i, PVector.angleBetween(n0, n1), cross);
          // ns = v0tov1.mag() * sqrt(2);
          if (cross.z > 0) //left
          {
            eta = PI+HALF_PI/2;
            phi = PI/2 - HALF_PI/2;
          } else //Right
          {
            eta = -HALF_PI/2;
            phi = PI/2 + HALF_PI/2;
          }
        } else
        {
          eta = -HALF_PI;
          phi = HALF_PI;
          // ns =  v0tov1.mag();
        }

        ov0toov1 = v0tov1.copy();
      }

      PVector norm0 = v0tov1.copy();
      norm0.normalize();
      norm0.mult(ns);
      norm0.rotate(eta);
      norm0.add(v0);

      PVector norm1 = v0tov1.copy();
      norm1.normalize();
      norm1.mult(ns);
      norm1.rotate(phi);
      norm1.add(v0);

      float hue = map(i, 0, lerpVertList.size(), i, 360);
      fill(hue, 100, 100);

      vertex(norm0.x, norm0.y);
      vertex(norm1.x, norm1.y);
      s += dx;
    }
    endShape();
  }

  //computation
  void unwarpPath(float scale)
  {  
    PVector origine = shapeVertList.get(0).copy();
    PVector lp = shapeVertList.get(0).copy();
    PVector np = new PVector();

    ArrayList<Float> rangeList = new ArrayList<Float>();

    for (int i = 0; i < shapeVertList.size(); i++)
    {
      int i0 = i;
      int i1 = i0;

      if (i < shapeVertList.size() - 1)
      {
        i1 = i+1;
      } else
      {
        i1 = 0;
      }

      PVector v0 = shapeVertList.get(i0).copy();
      PVector v1 = shapeVertList.get(i1).copy();
      PVector v0tov1 = PVector.sub(v1, v0);
      np = new PVector(lp.x + v0tov1.mag(), lp.y);
      lp = np;
      rangeList.add(np.x);
    }

    int rangeIndex = 0;
    float rangeLimit = rangeList.get(rangeIndex); 
    float lastBreakPoint = 0;
    for (int i=0; i < resolution; i++)
    {
      float amt = map(i, 0, resolution, 0.0, 1.0);
      PVector lv = PVector.lerp(origine, np, amt);

      if (lv.x >= rangeLimit)
      {
        float hue = map(rangeIndex, 0, rangeList.size(), 0, 360);
        stroke(hue, 100, 100);

        float lineResolution = i - lastBreakPoint;
        lastBreakPoint = i;
        rangeIndex ++;
        rangeLimit = rangeList.get(rangeIndex);
        resolutionPerLine.add(lineResolution);
      }
    }

    //println(resolutionPerLine.size(), shapeVertList.size());
    for (int i=0; i<resolutionPerLine.size(); i++)
    {
      PVector v0 = shapeVertList.get(i).copy();
      PVector v1 = shapeVertList.get(i+1).copy();
      float range = resolutionPerLine.get(i);
      for (float r = 0; r< range; r++)
      {
        float amt = map(r, 0, range, 0.0, 1.0);
        PVector lv = PVector.lerp(v0, v1, amt);
        lerpVertList.add(lv);
      }
    }
    lerpVertList.add(shapeVertList.get(shapeVertList.size()-1));
  }

  //control
  void enableStyle(boolean state)
  {
    if (state)
    {
      for (PShape sh : shapeList)
      {
        sh.enableStyle();
      }
    } else
    {
      for (PShape sh : shapeList)
      {
        sh.disableStyle();
      }
    }
  }

  //get
  int getLerpVertListSize()
  {
    return lerpVertList.size();
  }

  PVector getLerpPosition(int i)
  {
    return lerpVertList.get(i).copy();
  }

  float getAngleAtLerp(int i)
  {
    float phi = 0;
    if (i < lerpVertList.size()-1)
    {
      PVector v0 = lerpVertList.get(i);
      PVector v1 = lerpVertList.get(i+1);
      PVector v0tov1 = PVector.sub(v1, v0);
      phi = v0tov1.heading();
    } else
    {
      PVector v0 = lerpVertList.get(i-1);
      PVector v1 = lerpVertList.get(i);
      PVector v0tov1 = PVector.sub(v0, v1);
      phi = v0tov1.heading();
    }
    return phi;
  }
}