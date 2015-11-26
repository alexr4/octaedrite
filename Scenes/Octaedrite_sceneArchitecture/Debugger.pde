String[] patternList = 
  {"/scene00_00_P5", 
  "/scene01_00_P5", 
  "/scene01_01_P5", 
  "/scene02_00_P5", 
  "/scene02_01_P5", 
  "/scene02_02_P5", 
  "/scene02_03_P5"}; 

void mousePressed() {
  /* createan osc message with address pattern /test */
  OscMessage myMessage = new OscMessage("/scene00_00_P5");
  /*
  myMessage.add(123); 
  myMessage.add(456); 
*/
  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}