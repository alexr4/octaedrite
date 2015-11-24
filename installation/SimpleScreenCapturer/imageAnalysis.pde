int videoWidth = 1920;
int videoHeight = 1080;
int scanX;
color[] detectedPixels = new color[videoHeight];
ArrayList<Float> normalizedBrightness;
int resolution;
int offset;
int a, r, g, b;
float brightness;
color c; 

void initAnalysis(float w_, float h_, int res_)
{
  scanX = floor(w_ / 2);

  resolution = res_;
  offset = floor(h_ /  resolution);
}

void brightAnalysis(PImage temp_)
{
  noStroke();
  temp_.loadPixels();
  for (int i=0; i<resolution; i++)
  {
    float y = i*offset;
    float bright = 0;
    float redValue = 0;
    float greenValue = 0;
    float blueValue = 0;

    try {
      for (int j = floor(y); j < y+resolution; j++) 
      {
        if ( j < captureHeight)
        {
          int pixelindex = floor(scanX + j * temp_.width);
          c = (color)temp_.pixels[pixelindex];
          a = (c >> 24) & 0xFF;
          r = (c >> 16) & 0xFF;  
          g = (c >> 8) & 0xFF;   
          b = c & 0xFF;
          float brightness = (r+g+b)/3;
          redValue += r;
          greenValue += g;
          blueValue += b;
          bright += brightness;
        }
      }
    }
    catch(Exception e)
    {
      println(e);
    }
    bright /= resolution;
    bright = norm(bright, 0, 255);
    sendMessage(i, bright);


    redValue /= resolution;
    greenValue /= resolution;
    blueValue /= resolution;


    fill(bright * 255);
    stroke(255, 50);
    float ny = map(i, 0, resolution, 0, height);
    rect(10, ny, 10, 10);
    
    noStroke();
    fill(r, g, b);
    rect(20, ny, 10, 10);
  }
}