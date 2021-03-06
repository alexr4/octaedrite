class PtLight
{
  PVector pos;
  PVector rgb;

  float x, y, z, r, g, b;

  float eta, theta;
  float minRadius, maxRadius;
  float radiusX, radiusY, radiusZ;
  float speedEta, speedTheta;
  float speedRadius;

  boolean xyz;

  PtLight(PVector loc_, PVector rgb_)
  {
    pos = loc_;
    rgb = rgb_;

    x = pos.x;
    y = pos.y;
    z = pos.z;

    r = rgb.x;
    g = rgb.y;
    b = rgb.z;

    println(pos);
  }

  PtLight(boolean xyz_)
  {
    xyz = xyz_;
    if (xyz)
    {
      minRadius = random(100, 125);
      maxRadius = random(150, 175);

      radiusX = random(minRadius, maxRadius);
      radiusY = random(minRadius, maxRadius);
      radiusZ = random(minRadius, maxRadius);  
      speedRadius = random(0.01, 0.05); 

      eta = random(PI);
      theta = random(TWO_PI);
      speedEta =  radians(random(0.1, 0.5));
      speedTheta =  radians(random(0.1, 0.5));

      x =  sin(eta)*cos(theta)*radiusX;
      y =  sin(eta)*sin(theta)*radiusY;
      z =  cos(eta)*radiusZ;

      r = 0;//random(255);
      g = random(255);
      b = random(255);

      pos = new PVector(x, y, z);
      rgb = new PVector(r, g, b);
    } else
    {
      minRadius = random(100, 125);
      maxRadius = random(150, 175);

      radiusX = random(minRadius, maxRadius);
      radiusY = random(minRadius, maxRadius);  
      speedRadius = random(0.01, 0.05); 

      theta = random(TWO_PI);
      speedTheta =  radians(random(0.1, 0.5));

      x =  0;//cos(theta)*radiusX;
      y =  0;//sin(theta)*radiusY;
      z = minRadius;

      r = 255; //random(255);
      g = 255; //random(255);
      b = 255; //random(255);

      pos = new PVector(x, y, z);
      rgb = new PVector(r, g, b);
    }
  }

  //Update
  void updates()
  {
    updateAngles();
    updatePosition();
  }

  void updateEta()
  {
    eta += speedEta;
  }

  void updateTheta()
  {
    theta += speedTheta;
  }

  void updateAngles()
  {
    if (xyz)
    {
      updateEta();
    }
    updateTheta();
  }

  void updatePosition()
  {    

    radiusX += speedRadius;
    radiusY += speedRadius;
    radiusZ += speedRadius;

    float rx = minRadius + sin(radiusX) * maxRadius;
    float ry = minRadius + sin(radiusY) * maxRadius;
    float rz = minRadius + sin(radiusZ) * maxRadius;

    x =  cos(theta)*rx;
    y =  sin(theta)*rx;
    z =  minRadius + cos(eta)*rx;

    pos = new PVector(x, y, z);
  }

  void display(PGraphics buffer, boolean debug)
  {
    buffer.pointLight(rgb.x, rgb.y, rgb.z, pos.x, pos.y, pos.z);
   // buffer.spotLight(rgb.x, rgb.y, rgb.z, pos.x, pos.y, pos.z, 0, 0, -1, PI, 0.5);
    if (debug)
    {
      buffer.pushStyle();
      buffer.strokeWeight(5);
      buffer.stroke(rgb.x, 0, 0);//rgb.y, rgb.z);
      buffer.point(x, y, z);      
      buffer.strokeWeight(1);
      buffer.line(pos.x, pos.y, 0.0, pos.x, pos.y, pos.y);
      buffer.popStyle();
    }
  }

  //set
  void setPosition(PVector pos_)
  {
    pos.x = pos_.x;//screenX(pos_.x, pos_.y, pos_.z);
    pos.y = pos_.y;//screenY(pos_.x, pos_.y, pos_.z);
    pos.z = 50;//screenZ(pos_.x, pos_.y, pos_.z);
    //pos.z = pos_.z;
  }

  void setColor(PVector rgb_)
  {
    rgb = rgb_.copy();
  }
}