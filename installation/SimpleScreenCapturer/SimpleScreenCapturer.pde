SimpleScreenCapture simpleScreenCapture;

float captureWidth, captureHeight;
float captureResolution;
float tempWidth, tempHeight;
int analysisResolution;

//OSCp5
String ip = "129.102.64.222";
int port;
String pattern = "/P5_brightness";

void setup() {
  size(900, 480, P3D);
  smooth(8);
  initSlider();
  initSketch();
}

void draw() {
  background(40);
  PImage temp = simpleScreenCapture.get(0, 0, (int)captureWidth, (int)captureHeight);
  image(temp, 50, 0, tempWidth, tempHeight);
  
  float lx = map(scanX, 0, captureWidth, 50, 50+tempWidth);
  stroke(255, 0, 0);
  line(lx, 0, lx, tempHeight);
  
  brightAnalysis(temp);
}

void initSketch()
{
  captureWidth = 1920.0;
  captureHeight = 1080.0;
  captureResolution = captureWidth/captureHeight;
  analysisResolution = 100;
  
  initOSCP5(ip, port);
  simpleScreenCapture = new SimpleScreenCapture();
  
  initAnalysis(captureWidth, captureHeight, analysisResolution);
 
  tempWidth = 480;
  tempHeight = tempWidth / captureResolution;
}