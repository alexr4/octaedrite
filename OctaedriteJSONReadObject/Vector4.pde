class Vec4
{
  PVector vertex;
  float x, y, z, w;
  
  Vec4(float x_, float y_, float z_, float w_)
  {
    x = x_;
    y = y_;
    z = z_;
    w = w_;
    vertex = new PVector(x, y, z);
  }
  
  //set
  void setX(float x_)
  {
    x = x_;
  }
  
  void setY(float y_)
  {
    y = y_;
  }
  
  void setZ(float z_)
  {
    z = z_;
  }
  
  void setW(float w_)
  {
    w = w_;
  }
  
  void set2D(float x, float y)
  {
    setX(x);
    setY(y);
  }
  
   void set3D(float x, float y, float z)
  {
    setX(x);
    setY(y);
    setZ(z);
  }
  
  void set4D(float x, float y, float z, float w)
  {
    setX(x);
    setY(y);
    setZ(z);
    setW(w);
  }
  
  //get
  float getX()
  {
    return x;
  }
  
  float getY()
  {
    return y;
  }
  
  float getZ()
  {
    return z;
  }
  
  float getW()
  {
    return w;
  }
  
  float[] get2D()
  {
    float[] vec2 = {getX(), getY()};
    return vec2;
  }
  
   float[] get3D()
  {
    float[] vec3 = {getX(), getY(), getZ()};
    return vec3;
  }
  
  float[] get4D()
  {
    float[] vec4 = {getX(), getY(), getZ(), getZ()};
    return vec4;
  }
}