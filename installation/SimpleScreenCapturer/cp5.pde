import controlP5.*;

ControlP5 cp5;

void initSlider()
{
  cp5 = new ControlP5(this);

  // add a horizontal sliders, the value of this slider will be linked
  // to variable 'sliderValue' 
  cp5.addSlider("captureWidth")
    .setPosition(550, 20)
    .setRange(10, 1920)
    .setValue(1920);
  ;

  cp5.addSlider("analysisResolution")
    .setPosition(550, 40)
    .setRange(1, 250)
    .setValue(10);
  ;

  cp5.addTextfield("ip")
    .setPosition(550, 60)
    .setFocus(true)
    ;
    
    cp5.addTextfield("port")
    .setPosition(550, 100)
    .setFocus(true)
    ;
    
     cp5.addTextfield("OSCpattern")
    .setPosition(550, 140)
    .setFocus(true)
    ;
}

void ip(String theText) {
  // automatically receives results from controller input
  ip = theText;
  initOSCP5(ip, port);
  println("a textfield event for controller 'input' : "+theText+" ip : "+ip);
}

void port(String theText) {
  // automatically receives results from controller input
  port = parseInt(theText);
  initOSCP5(ip, port);
  println("a textfield event for controller 'input' : "+theText+" port : "+port);
}

void OSCpattern(String theText) {
  // automatically receives results from controller input
  pattern = theText;
  println("a textfield event for controller 'input' : "+theText+" pattern : "+pattern);
}


void captureWidth(float w_)
{
  captureWidth = floor(w_);
  captureHeight = floor(captureWidth / captureResolution);  
  initAnalysis(captureWidth, captureHeight, analysisResolution);
}

void analysisResolution(int res_)
{
  analysisResolution = res_;
  initAnalysis(captureWidth, captureHeight, analysisResolution);
}