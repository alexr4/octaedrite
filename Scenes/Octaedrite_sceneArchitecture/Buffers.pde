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
  renderScene(sceneIndex);
  finalBuffer.endDraw();
}

void renderStencilBuffer()
{
  stencilBuffer.beginDraw();
  stencilBuffer.background(255);
  stencilBuffer.translate(finalBuffer.width/2, finalBuffer.height/2);
  //shape
  stencilBuffer.shader(octaedrite.octaStencil);
  stencilBuffer.shape(octaedrite.octa);
  stencilBuffer.endDraw();
}

/*-----render scene -----*/
void renderScene(int sceneIndex)
{
  if (sceneIndex == 0)
  {
    //lights
    for (int i=0; i<lightList.size(); i++)
    {
      PtLight p = lightList.get(i);
      p.setPosition(followerlist.get(i).getHeadPosition());
      p.display(finalBuffer, true);
    }
    //shape
    finalBuffer.pushMatrix();
    finalBuffer.translate(finalBuffer.width/2, finalBuffer.height/2); 
    finalBuffer.shader(octaedrite.octaShader);
    finalBuffer.shape(octaedrite.octa);
    finalBuffer.popMatrix();

    for (int i=0; i<followerlist.size(); i++)
    {
      Follower f = followerlist.get(i);
      //f.showPath();

      if (f.getFinalEndAnimation())
      {
        //followerlist.remove(i);
      } else
      {
        f.run();
        f.displayTail(finalBuffer);
      }
    }

    //debug
    //stencilBuffer.translate(finalBuffer.width/2, finalBuffer.height/2);
    for (Path p : pathlist)
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
    }
  }
}