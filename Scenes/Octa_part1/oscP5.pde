
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

void sendMessage(int index, int onOff) {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/P5_scene00_00");

  myMessage.add(index);
  myMessage.add(onOff);

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
  // println("Message sent");
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  
  //scene-2-2
  if (theOscMessage.checkAddrPattern("/scene00_00_P5") == true) {
    // println("plop");
    drawLine(theOscMessage);
  }
}

void drawLine(OscMessage theOscMessage)
{
  if (theOscMessage.checkTypetag("iiff")) {
    int index = theOscMessage.get(0).intValue();
    int onOff = theOscMessage.get(1).intValue();
    float speed = theOscMessage.get(2).floatValue();
    float opacity = theOscMessage.get(3).floatValue();
    if (onOff == 1)
    {
      if (index > followerlist.size()-1)
      {
        println("Create new line");
        followerlist.add(new Follower(pathlist.get(index), index, onOff, speed, 6, 1));
      } else
      {
        followerlist.get(index).setSpeed(speed);
        followerlist.get(index).setOpacity(opacity);
      }
    } else if (onOff == 0)
    {
      try {
        println("Erase line "+index+" "+onOff+" "+followerlist.size()+" speed : "+speed);
        followerlist.get(index).onOff = onOff;
        followerlist.get(index).setEndSpeed(speed);
        followerlist.get(index).setOpacity(opacity);
      }
      catch(Exception e)
      {
        println("\t"+e);
      }
    }
    //println("index : "+index+" followerlist.size() : "+followerlist.size());
    globalIndex++;
    //println(" values: "+index+", "+onOff+", "+speed+", "+opacity);
    return;
  }
}