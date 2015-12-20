PGraphics finalBuffer;
float finalBufferRatio;

PGraphics stencilBuffer;
float stencilBufferRatio;

PGraphics initBuffers(int w, int h)
{
  PGraphics buff = createGraphics(w, h, P3D);
  buff.smooth(8);
  buff.beginDraw();
  buff.background(0);
  buff.endDraw();

  return buff;
}

float computeBufferRatio(int w, int h)
{
  float bufferRatio = (float) w / (float) h;

  return bufferRatio;
}

void renderFinalBuffer()
{
  finalBuffer.beginDraw();
  finalBuffer.background(0);
  renderLights(finalBuffer);
  renderOctaedrite(finalBuffer, false);

  if (sceneIndex == 0)
  {
    renderScene00(finalBuffer);
  } else if (sceneIndex == 1)
  {
  } else if (sceneIndex == 2) {
    renderScene02_01(finalBuffer);
  } else if (sceneIndex == 3) {
  } else if (sceneIndex == 4) {
  } else if (sceneIndex == 5) {
  } else if (sceneIndex == 6)
  {
  } else
  {
    println("Scene Index doesn't exists, please check the storyboard");
  }

  finalBuffer.endDraw();
}

void renderStencilBuffer()
{
  stencilBuffer.beginDraw();
  stencilBuffer.background(255);
  
  //renderLights(stencilBuffer);
  renderOctaedrite(stencilBuffer, true);

  if (sceneIndex == 0)
  {
    renderScene00(stencilBuffer);
  } else if (sceneIndex == 1)
  {
  } else if (sceneIndex == 2) {
    renderScene02_01(stencilBuffer);
  } else if (sceneIndex == 3) {
  } else if (sceneIndex == 4) {
  } else if (sceneIndex == 5) {
  } else if (sceneIndex == 6)
  {
  } else
  {
    println("Scene Index doesn't exists, please check the storyboard");
  }

  stencilBuffer.endDraw();
}

/*-----render scene -----*/
void renderOctaedrite(PGraphics buffer, boolean stencil)
{

  buffer.pushMatrix();
  buffer.translate(buffer.width/2, buffer.height/2, 0); 
  //buffer.rotateY(frameCount * 0.01); //check bumpmap
  if (stencil)
  {
    buffer.shader(octaedrite.octaStencil);
  } else
  {
    buffer.shader(octaedrite.octaShader);
  }
  buffer.shape(octaedrite.octa);
  buffer.resetShader();
  buffer.popMatrix();
}

void renderLights(PGraphics buffer)
{
  //lights
  float phi = frameCount * 0.01;
  for (int i = 0; i< 4; i++)
  {
    float eta = norm(i, 0, 4) * TWO_PI;
    float x = finalBuffer.width/2 + cos(phi + eta) * finalBuffer.width;
    float y = finalBuffer.height/2 + sin(phi + eta) * finalBuffer.height;
    float z = finalBuffer.width/2;
    buffer.pointLight(255, 255, 255, x, y, z);
  }
  /*finalBuffer.spotLight(200, 200, 200, finalBuffer.width/2, finalBuffer.height/2, width, 0, 0, -1, PI, 8);
   for (int i=0; i<lightList.size(); i++)
   {
   PtLight p = lightList.get(i);
   p.setPosition(followerlistScene00.get(i).getHeadPosition());
   p.display(finalBuffer, false);
   }*/
}

void renderScene00(PGraphics buffer)
{
  for (int i=0; i<followerlistScene00.size(); i++)
  {
    Follower f = followerlistScene00.get(i);
    //f.showPath();

    if (f.getFinalEndAnimation())
    {
      //followerlist.remove(i);
    } else
    {
      f.run();
      f.displayTail(buffer);
    }
  }

  //debug
  //stencilBuffer.translate(finalBuffer.width/2, finalBuffer.height/2);
  /*for (Path p : pathlist)
   {
   // p.displayPath(finalBuffer);
   //p.displayLerpNormal(10, finalBuffer);
   //p.displayLerpShape(finalBuffer);
   //p.displayLerpShapeSinScale(finalBuffer);
   // p.displayLerpShapeNoiseSinScale(finalBuffer);
   //p.displayLerpShapeNoiseScale(finalBuffer);
   //p.displayLerpShapeRandomScale(finalBuffer);
   //p.displayLerpShapeRandomSinScale(finalBuffer);
   //p.displayLerpShapeRandomGaussianScale(finalBuffer);
   //p.displayLerpShapeRandomGaussianSinScale(finalBuffer);
   }*/
}
void renderScene02_00(PGraphics buffer)
{
}

void renderScene02_01(PGraphics buffer)
{
  // displayShapeCenter(displayShapeCenter, globalCoord, finalBuffer);
  //displayOrientationArrow(displayOrientationArrow, globalCoord, finalBuffer);
  //displayNormals(displayNormals, globalCoord, finalBuffer);
  //displayPath(displayShape, globalCoord, finalBuffer);

  for (int i=0; i<ofListScene0101.size(); i++)
  {
    OutlineFollower of = ofListScene0101.get(i);

    //of.debugOriginalPath(1, finalBuffer);
    of.displayLead(buffer);
    of.run(buffer);
  }
}