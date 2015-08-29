void initBufferScreen()
{
  initWorld();
  bufferScreen = createGraphics(width, height, P3D);
  smooth();
}

void computerBufferScreen()
{
  bufferScreen.beginDraw();
  bufferScreen.background(10);
  bufferScreen.translate(width/2, height/2, 200);
  bufferScreen.rotateX(rotation.x);
  bufferScreen.rotateY(rotation.y);
  if (mousePressed && mouseButton == RIGHT)
  {
    sceneControl(bufferScreen);
  }  
  
  if(debug)
  {
    drawAxis(100, "RVB", bufferScreen);
  }

  //lights
  light.updates();
  showLigth();
  bufferScreen.pointLight(light.r, light.g, light.b, light.x, light.y, light.z);

  //shape
  bufferScreen.shader(octaShader);
  bufferScreen.shape(octa);

  bufferScreen.endDraw();
}
//3D
void initWorld()
{

  //Boolean de controle + arcBall
  amplitude = 0.1;

  light = new PtLight(false);
}
//lights
void showLigth()
{
  bufferScreen.pushStyle();
  bufferScreen.strokeWeight(10);
  bufferScreen.stroke(light.r, light.g, light.b);
  bufferScreen.point(light.x, light.y, light.z);
  bufferScreen.popStyle();
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

//control de la scene 3D [ArcBall]
void sceneControl(PGraphics buff)
{

  if (mouseX <width/2-100)
  {
    sens = map(mouseX, 0, width/2-100, -1, 0);
  } else if (mouseX >+width/2+100)
  {
    sens = map(mouseX, width/2+100, width, 0, 1);
  } else
  {
    sens = 0;
  }

  if (mouseY <height/2-100)
  {
    sens2 = map(mouseY, 0, height/2-100, -1, 0);
  } else if (mouseY >+height/2+100)
  {
    sens2 = map(mouseY, height/2+100, height, 0, 1);
  } else
  {
    sens2 = 0;
  }

  orientation = new PVector(sens2*amplitude, sens*amplitude); //sens2*amplitude 

  acceleration.add(orientation);
  velocity.add(acceleration);
  rotation.add(velocity);
  acceleration.mult(0);
  velocity.mult(0);
}