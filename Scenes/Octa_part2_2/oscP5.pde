
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

void initOSCP5(String IP, int port)
{
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress(IP, port);
}

void sendMessage(int index, float locX, float locY) {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/P5_scene01_01");

  myMessage.add(index);
  myMessage.add(locX); /* add an int to the osc message */
  myMessage.add(locY);

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
  // println("Message sent");
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
   println("### received an osc message. "+theOscMessage.typetag());
   /*print(" addrpattern: "+theOscMessage.addrPattern());
   println(" typetag: "+theOscMessage.typetag());*/

  //scene-2-2
  if (theOscMessage.checkAddrPattern("/scene01_01_P5") == true) {
    println("/scene01_01_P5");
    //addNewLine(theOscMessage);
    if (theOscMessage.checkTypetag("iifff")) {
      int index = theOscMessage.get(0).intValue();
      int onOff = theOscMessage.get(1).intValue();
      float begin = theOscMessage.get(2).floatValue();
      float end = theOscMessage.get(3).floatValue();
      float speed = theOscMessage.get(4).floatValue();

      ofList.add(new OutlineFollower(index, onOff, vertList, begin, end, globalCoord, speed));

      println("index : "+index+" ofList.size() : "+ofList.size());
      println("\t index : "+index+" onOff "+onOff+" begin : "+begin+" end : "+end+" speed : "+speed);
      globalIndex++;
      //println(" values: "+index+", "+onOff+", "+begin+", "+end+", "+speed);
      return;
    }

    stopLine(theOscMessage);
  }
}

void addNewLine(OscMessage theOscMessage)
{
  if (theOscMessage.checkTypetag("iifff")) {
    int index = theOscMessage.get(0).intValue();
    int onOff = theOscMessage.get(1).intValue();
    float begin = theOscMessage.get(2).floatValue();
    float end = theOscMessage.get(3).floatValue();
    float speed = theOscMessage.get(4).floatValue();

    ofList.add(new OutlineFollower(index, onOff, vertList, begin, end, globalCoord, speed));

    println("index : "+index+" ofList.size() : "+ofList.size());
    globalIndex++;
    //println(" values: "+index+", "+onOff+", "+begin+", "+end+", "+speed);
    return;
  }
}

void stopLine(OscMessage theOscMessage)
{
  if (theOscMessage.checkTypetag("ii")) {
    int index = theOscMessage.get(0).intValue();
    int onOff = theOscMessage.get(1).intValue();

    if (index < ofList.size())
    {
      if (onOff == 0)
      {
        try {
          println("stop line "+index+" "+onOff+" "+ofList.size());
          ofList.get(index).finished = true;
        }
        catch(Exception e)
        {
          println("\t at stop line "+e);
        }
      } else if (onOff == -1)
      {
        try {
          println("Kill line "+index+" "+onOff+" "+ofList.size());
          ofList.get(index).clearAllPath();
          //ofList.remove(index);
        }
        catch(Exception e)
        {      
          println("\t at Kill line "+e);
        }
      }
    }
    return;
  }
}