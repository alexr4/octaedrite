//Sketch properties
String appName = "Octaedrite_OSCArchitecture";
String version = "Alpha";
String subVersion = "0.0.0";
String frameName;

//App Parameters
void appParameter()
{
  frameName = appName+"_"+version+"_"+subVersion;
  surface.setTitle(frameName);
}

void showFpsOnFrameTitle()
{
  surface.setTitle(frameName+"    FPS : "+int(frameRate));
}