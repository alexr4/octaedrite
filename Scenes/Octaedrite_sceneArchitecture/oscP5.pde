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

void scene00_00_P5()
{
}

void scene01_00_P5()
{
}

void scene01_01_P5()
{
}

void scene02_00_P5()
{
}

void scene02_01_P5()
{
}

void scene02_02_P5()
{
}

void scene02_03_P5()
{
}