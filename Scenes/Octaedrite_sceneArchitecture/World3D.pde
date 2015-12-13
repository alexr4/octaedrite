void showLigth(PtLight p, PGraphics buff)
{
  buff.pushStyle();
  buff.strokeWeight(10);
  buff.stroke(p.r, p.g, p.b);
  buff.point(p.x, p.y, p.z);
  buff.popStyle();
}

//World
void drawAxis(float l, String colorMode, PGraphics buff)
{
  color xAxis = color(255, 0, 0);
  color yAxis = color(0, 255, 0);
  color zAxis = color(0, 0, 255);

  if (colorMode == "rvb" || colorMode == "RVB")
  {
    xAxis = color(255, 0, 0);
    yAxis = color(0, 255, 0);
    zAxis = color(0, 0, 255);
  } else if (colorMode == "hsb" || colorMode == "HSB")
  {
    xAxis = color(0, 100, 100);
    yAxis = color(115, 100, 100);
    zAxis = color(215, 100, 100);
  }

  buff.pushStyle();
  buff.strokeWeight(1);
  //x-axis
  buff.stroke(xAxis); 
  buff.line(0, 0, 0, l, 0, 0);
  //y-axis
  buff.stroke(yAxis); 
  buff.line(0, 0, 0, 0, l, 0);
  //z-axis
  buff.stroke(zAxis); 
  buff.line(0, 0, 0, 0, 0, l);
  buff.popStyle();
}