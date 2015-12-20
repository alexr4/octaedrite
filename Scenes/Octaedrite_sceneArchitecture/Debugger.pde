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

int index_= 0;

void mousePressed() {
  //debugScene00();
  //scene01_01_P5(1);
  //debugScene0101();
}

//scene01_01_P5(int index_, int onOff_, float beginLocation_, float endLocation_, float speed_)
void debugScene00() {
  OscMessage myMessage = new OscMessage("/scene00_00_P5");

  float b = random(1);

  //myMessage.add("u");
  myMessage.add(index_);
  myMessage.add(1);
  myMessage.add(random(1.0));
  myMessage.add(random(1.0)); 

  oscP5.send(myMessage, myRemoteLocation);

  index_ ++;
}

void debugScene0101() {
  OscMessage myMessage = new OscMessage("/scene01_01_P5");

  float b = random(1);

  //myMessage.add("u");
  myMessage.add(index_);
  myMessage.add(1);
  myMessage.add(b);
  myMessage.add(random(b, 1.0));
  myMessage.add(random(0.1)); 

  oscP5.send(myMessage, myRemoteLocation);

  index_ ++;
}

void debugScene0101(float value) {
  OscMessage myMessage = new OscMessage("/scene01_01_P5");


  //myMessage.add("u");
  myMessage.add(value); 

  oscP5.send(myMessage, myRemoteLocation);
}