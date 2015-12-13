String debugLineState = "";
String exception = "";

void showDebug(boolean state)
{
  if (state)
  {
    try {
      fpstracker.run(frameRate);
      pushStyle();
      image(fpstracker.getImageTracker().get(), width - fpstracker.getImageTracker().width, 0);
      popStyle();
      showDebugSequence(state);
    }
    catch(Exception e)
    {
      exception = e.toString();
      pushStyle();
      fill(255, 0, 0);
      text(exception, 20, 20);
      popStyle();
    }
  }
}

void showDebugSequence(boolean state)
{
  if (state)
  {
    pushStyle();
    fill(255, 255, 0);
    text(debugLineState, 20, 20);
    popStyle();
  }
}

void mousePressed() {
  /* createan osc message with address pattern /test */
  OscMessage myMessage = new OscMessage("/scene00_00_P5");

  //myMessage.add("u");
  myMessage.add(1);
 //myMessage.add(1);
  //myMessage.add(1.0);
  //myMessage.add(1.0);
  // myMessage.add(1.0); 

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation);
}