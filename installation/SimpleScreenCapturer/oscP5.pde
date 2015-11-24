
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

void sendMessage(int index, float bright) {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage(pattern);

  myMessage.add(index);
  myMessage.add(bright);

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
  //println("Message sent");
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {

  //scene-2-2
  if (theOscMessage.checkAddrPattern("/scene1_P5") == true) {
    // println("plop");
  }
}