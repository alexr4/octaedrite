/*
OSC message architecture :
 This sketch show the architecture of the OSC message between Max/MSP and processing for the project Octaedrite
 It's has been establish that the visual will be guided by the soundtrack which will receive input from the visual in order to modulated the soundtrack.
 Max/Msp will sequence the visuals using the following architecture message :
 Max/MSP send : /sceneINT00_INT01_P5 as String where :
 INT00 = int index of the scene
 INT02 = int index of the shot
 _P5 = send to P5
 
 Processing send : /P5_sceneINT00_INT01 as String where :
 _P5 = send from P5
 INT00 = int index of the scene
 INT02 = int index of the shot
 */

void setup()
{
  size(500, 500, P3D);
  //OSCCLIENT
  initOSCP5("127.0.0.1", 12000, 12000);


  appParameter();
  surface.setLocation(0, 0);
  println("-----------------------------------------------\n\n");
}

void draw()
{
  background(0);


  showFpsOnFrameTitle();
}