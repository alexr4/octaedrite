
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
  OscMessage myMessage = new OscMessage("/test");

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
  println("### received an osc message.");
   print(" addrpattern: "+theOscMessage.addrPattern());
   println(" typetag: "+theOscMessage.typetag());

  if (theOscMessage.checkAddrPattern("/traj")==true) {
    println("/traj");
    if (theOscMessage.checkTypetag("ii")) {
      index = theOscMessage.get(0).intValue();  
      anim = theOscMessage.get(1).intValue();
      //String thirdValue = theOscMessage.get(2).stringValue();
      println ("### received an osc message /test with typetag ifs.");
      println(" values: "+index+", "+anim);//+", "+thirdValue);
      return;
    }
  }
}
/*
int[] getMessage(OscMessage mess)
 {
 int[] temp = new int[2];
 if(mess.checkAddrPattern("/traj"))
 {
 if (mess.checkTypetag("ifs")) {
 temp[0] = mess.get(0).intValue();  
 temp[1] = mess.get(1).intValue();
 //String thirdValue = theOscMessage.get(2).stringValue();
 //println ("### received an osc message /test with typetag ifs.");
 //println(" values: "+firstValue+", "+secondValue+", "+thirdValue);
 }
 }
 return temp;
 }*/