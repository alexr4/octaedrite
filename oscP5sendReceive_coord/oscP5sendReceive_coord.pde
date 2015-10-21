/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */
 
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;

PVector location;

float x;
int boolAnimation;
float offset = 0;
float animation = 0.1;

void setup() {
  size(400,400);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("169.254.239.251",1111);
}


void draw() {
  background(0); 
  
//  location = new PVector(noise(frameCount)*width, noise(frameRate)*height);
  
   x = lerp(0, width, offset);
  
  fill(255);
  ellipse(x, height/2, 20, 20);
  
  animation();
}

void animation()
{
  if(boolAnimation == 1)
  {
    offset += animation;
    if(offset >=1 || offset <= 0)
    {
      animation *= -1;
    }
    boolAnimation = 0;
    sendLocation(x, height/2);
  }
}

void sendLocation(float locX, float locY) {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/test");
  
  myMessage.add(locX); /* add an int to the osc message */
  myMessage.add(locY);

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  println(theOscMessage.get(0).intValue());
  boolAnimation = theOscMessage.get(0).intValue();
 /*/ print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());*/
  /*
   if(theOscMessage.checkAddrPattern("/test")==true) {
     println("test");
    if(theOscMessage.checkTypetag("ifs")) {
      int firstValue = theOscMessage.get(0).intValue();  
      float secondValue = theOscMessage.get(1).floatValue();
      String thirdValue = theOscMessage.get(2).stringValue();
      printl,("### received an osc message /test with typetag ifs.");
      println(" values: "+firstValue+", "+secondValue+", "+thirdValue);
      return;
    }  
  } */
}