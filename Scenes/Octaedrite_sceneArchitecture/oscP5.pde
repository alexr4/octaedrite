import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

void initOSCP5(String IP, int sendingPort, int receivingPort)
{
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, receivingPort);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress(IP, sendingPort);
  //scene 0
  oscP5.plug(this, "scene00_00_P5", "/scene00_00_P5");
  //scene 1
  oscP5.plug(this, "scene01_00_P5", "/scene01_00_P5"); 
  oscP5.plug(this, "scene01_01_P5", "/scene01_01_P5"); 
  //scene 2
  oscP5.plug(this, "scene02_00_P5", "/scene02_00_P5"); 
  oscP5.plug(this, "scene02_01_P5", "/scene02_01_P5"); 
  oscP5.plug(this, "scene02_02_P5", "/scene02_02_P5"); 
  oscP5.plug(this, "scene02_03_P5", "/scene02_03_P5");
}

void oscEvent(OscMessage theOscMessage) {
  /* with theOscMessage.isPlugged() you check if the osc message has already been
   * forwarded to a plugged method. if theOscMessage.isPlugged()==true, it has already 
   * been forwared to another method in your sketch. theOscMessage.isPlugged() can 
   * be used for double posting but is not required.
   */
  if (theOscMessage.isPlugged()==false) {
    /* print the address pattern and the typetag of the received OscMessage */
    println("### received an unPlugged osc message.");
    println("### addrpattern\t"+theOscMessage.addrPattern());
    println("### typetag\t"+theOscMessage.typetag());
  }
}

/*RECEIVED MESSAGES*/
void scene00_00_P5(int top_)
{
  //println("\nscene00_00_P5 Top Sequence: "+top_);
  debugLineState = "\nscene00_00_P5 Top Sequence: "+top_;
  if (top_ == 1)
  {
    sceneIndex = 0;
  } else
  {
    sceneIndex = 1;
  }
}

void scene00_00_P5(int index_, int onOff_, float speed_, float opacity_)
{
  //println("\nscene00_00_P5 line at: "+index_+"\n\tonOff : "+onOff_+"\n\tspeed : "+speed_+"\n\topacity : "+opacity_);
  debugLineState = "\nscene00_00_P5 line at: "+index_+"\n\tonOff : "+onOff_+"\n\tspeed : "+speed_+"\n\topacity : "+opacity_;
  if (onOff_ == 1) // draw line or create a new one
  {
    if (index_ > followerlistScene00.size() - 1) //creation d'une nouvelle ligne
    {
      try {
        followerlistScene00.add(new Follower(pathlist.get(index_), index_, onOff_, speed_, 6, 1));
      }
      catch(Exception e)
      {
        println("Found an exception at create line "+e);
      }
    } else // ou update d'une ligne actuelle
    {
      try {
        followerlistScene00.get(index_).setSpeed(speed_);
        followerlistScene00.get(index_).setOpacity(opacity_);
      }
      catch(Exception e)
      {
        println("Find an exception at update line "+e);
      }
    }
  } else if (onOff_ == 0)
  {
    try {
      println("Erase line "+index_+" "+onOff_+" "+followerlistScene00.size()+" speed : "+speed_);
      followerlistScene00.get(index_).onOff = onOff_;
      followerlistScene00.get(index_).setEndSpeed(speed_);
      followerlistScene00.get(index_).setOpacity(opacity_);
    }
    catch(Exception e)
    {
      println("Find an exception at erase line"+e);
    }
  } else {
    println("Cannot find anything if onOff = 0 at scene00_00_P5");
  }
}

void scene01_00_P5(int top_)
{
  //println("\nscene01_00_P5 Top Sequence: "+top_);
  debugLineState = "\nscene01_00_P5 Top Sequence: "+top_;

  if (top_ == 1)
  {
    sceneIndex = 1;
  } else
  {
    sceneIndex = 2;
  }
}

void scene01_00_P5(int index_, int onOff_, float deviation_)
{
  //println("\nscene01_00_P5 grattage at: "+index_+"\n\tonOff : "+onOff_+"\n\tdeviation : "+deviation_);
  debugLineState = "\nscene01_00_P5 grattage at: "+index_+"\n\tonOff : "+onOff_+"\n\tdeviation : "+deviation_;
}

void scene01_00_P5(int top_, int plan_)
{
  //println("\nscene01_00_P5 grattage zoom top : "+top_+"\n\tzoom/dezoom : "+plan_);
  debugLineState = "\nscene01_00_P5 grattage zoom top : "+top_+"\n\tzoom/dezoom : "+plan_;
}

void scene01_01_P5(int top_)
{
  //println("\nscene01_01_P5 Top Sequence: "+top_);
  debugLineState = "\nscene01_01_P5 Top Sequence: "+top_;

  if (top_ == 1)
  {
    sceneIndex = 2;
  } else
  {
    sceneIndex = 3;
  }
}

void scene01_01_P5(int index_, int onOff_, float beginLocation_, float endLocation_, float speed_)
{
  //println("\nscene01_01_P5 outline at: "+index_+"\n\tonOff : "+onOff_+"\n\tbegin location : "+beginLocation_+"\n\tend location : "+endLocation_+"\n\tspeed : "+speed_);
  debugLineState = "\nscene01_01_P5 outline at: "+index_+"\n\tonOff : "+onOff_+"\n\tbegin location : "+beginLocation_+"\n\tend location : "+endLocation_+"\n\tspeed : "+speed_;
  if (onOff_ == 1)
  {
    if (index_ > ofListScene0101.size() - 1) //creation d'une nouvelle ligne
    {
      try {
        ofListScene0101.add(new OutlineFollower(index_, onOff_, vertList, beginLocation_, endLocation_, globalCoord, speed_));
      }
      catch(Exception e)
      {
        println("Found an Exception at create outline "+e);
      }
    }
  } else if (onOff_ == 0)
  {
    if (index_ < ofListScene0101.size())
    {
      try {
        ofListScene0101.get(index_).finished = true;
      }
      catch(Exception e)
      {
        println("Found an exception at stop outline "+e);
      }
    }
  } else if (onOff_ == -1)
  {
    if (index_ < ofListScene0101.size())
    {
      try {
        ofListScene0101.get(index_).clearAllPath();
      }
      catch(Exception e)
      {
        println("Found an exception at kill outline "+e);
      }
    }
  }
}

void scene01_01_P5(float opacity_)
{
  //println("\nscene01_01_P5 Meteor opacity: "+opacity_);
  debugLineState = "\nscene01_01_P5 Meteor opacity: "+opacity_;
  octaedrite.octaShader.set("alphaAlbedo", opacity_);
}

void scene02_00_P5(int top_)
{
  //println("\nscene02_00_P5 Top Sequence: "+top_);
  debugLineState = "\nscene02_00_P5 Top Sequence: "+top_;

  if (top_ == 1)
  {
    sceneIndex = 3;
  } else
  {
    sceneIndex = 4;
  }
}

void scene02_00_P5(int index_, int onOff_, float speed_, float opacity_)
{
  //println("\nscene02_00_P5 line at: "+index_+"\n\tonOff : "+onOff_+"\n\tspeed : "+speed_+"\n\topacity : "+opacity_);
  debugLineState = "\nscene02_00_P5 line at: "+index_+"\n\tonOff : "+onOff_+"\n\tspeed : "+speed_+"\n\topacity : "+opacity_;
}

void scene02_00_P5(int index_, int onOff_)
{
  //println("\nscene02_00_P5 outline at: "+index_+"\n\tonOff : "+onOff_);
  debugLineState = "\nscene02_00_P5 outline at: "+index_+"\n\tonOff : "+onOff_;
}

void scene02_01_P5(int top_)
{
  //println("\nscene02_01_P5 Top Sequence: "+top_);
  debugLineState = "\nscene02_01_P5 Top Sequence: "+top_;

  if (top_ == 1)
  {
    sceneIndex = 4;
  } else
  {
    sceneIndex = 5;
  }
}

void scene02_01_P5(int index_, int onOff_, float speed_)
{
  //println("\nscene02_01_P5 playback at : "+index_+"\n\tonOff : "+onOff_+"\n\tspeed : "+speed_);
  debugLineState = "\nscene02_01_P5 playback at : "+index_+"\n\tonOff : "+onOff_+"\n\tspeed : "+speed_;
}

void scene02_02_P5(int top_)
{
  //println("\nscene02_02_P5 Top Sequence: "+top_);
  debugLineState = "\nscene02_02_P5 Top Sequence: "+top_;

  if (top_ == 1)
  {
    sceneIndex = 5;
  } else
  {
    sceneIndex = 6;
  }
}

void scene02_02_P5(String unlock_, int index_, int onOff_)
{
  //println("\nscene02_02_P5 playback unlock : "+unlock_+"\n\tat index : "+index_+"\n\tonOff : "+onOff_);
  debugLineState = "\nscene02_02_P5 playback unlock : "+unlock_+"\n\tat index : "+index_+"\n\tonOff : "+onOff_;
}

void scene02_02_P5(int index_, int onOff_)
{
  //println("\nscene02_02_P5 precedent drawing apparition at index : "+index_+"\n\tonOff : "+onOff_);
  debugLineState = "\nscene02_02_P5 precedent drawing apparition at index : "+index_+"\n\tonOff : "+onOff_;
}

void scene02_03_P5(int top_)
{
  //println("\nscene02_03_P5 Top Sequence: "+top_);
  debugLineState = "\nscene02_03_P5 Top Sequence: "+top_;

  if (top_ == 1)
  {
    sceneIndex = 6;
  } else
  {
    sceneIndex = 7;
  }
}

void scene02_03_P5(int index_, int onOff_, float speed_)
{
  //println("\nscene02_03_P5 scanner at : "+index_+"\n\tonOff : "+onOff_+"\n\tspeed : "+speed_);
  debugLineState = "\nscene02_03_P5 scanner at : "+index_+"\n\tonOff : "+onOff_+"\n\tspeed : "+speed_;
}

/*-----------------------------------------------------------------------------------------------------*/
/*SEND MESSAGE*/
void sendMessage(String header, int index, int value) {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage(header);

  myMessage.add(index);
  myMessage.add(value);

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
  // println("Message sent");
}

void sendMessage(String header, int index, float value) {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage(header);

  myMessage.add(index);
  myMessage.add(value);

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
  // println("Message sent");
}

void sendMessage(String header, int index, float value0, float value1, float value2, float value3) {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage(header);

  myMessage.add(index);
  myMessage.add(value0);
  myMessage.add(value1);
  myMessage.add(value2);
  myMessage.add(value3);

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
  // println("Message sent");
}

void sendMessage(String header, int index, float value0, float value1) {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage(header);

  myMessage.add(index);
  myMessage.add(value0);
  myMessage.add(value1);

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
  // println("Message sent");
}


void sendMessage(String header, int index, float value0, int value1) {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage(header);

  myMessage.add(index);
  myMessage.add(value0);
  myMessage.add(value1);

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
  // println("Message sent");
}