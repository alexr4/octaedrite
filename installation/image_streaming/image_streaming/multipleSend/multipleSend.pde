import processing.video.*;

import javax.imageio.*;
import java.awt.image.*; 
import java.net.*;
import java.io.*;

// This is the port we are sending to
int clientPort00 = 9100; 
int clientPort01 = 9200; 
// This is our object that sends UDP out
DatagramSocket ds; 
// Capture object
Capture cam;
PImage camMid00;
PImage camMid01;
int halfImage;
int totalImage;

boolean firstImage;

void setup() {
  size(640, 240);
  // Setting up the DatagramSocket, requires try/catch
  try {
    ds = new DatagramSocket();
  } 
  catch (SocketException e) {
    e.printStackTrace();
  }
  // Initialize Camera
  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
  } 
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i, cameras[i]);
    }

    // The camera can be initialized directly using an element
    // from the array returned by list():
    cam = new Capture(this, cameras[33]); //33
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);

    // Start capturing the images from the camera
    cam.start();
  }
}

void captureEvent( Capture c ) {
  c.read();
  // Whenever we get a new image, send it!
  //broadcast(c);
  if (!firstImage)
  {
    println("cam has started at "+cam.width+" × "+cam.height);
    camMid00 = new PImage(c.width/2, c.height);
    camMid01 = new PImage(c.width/2, c.height);
    halfImage = camMid01.width * camMid01.height;
    totalImage = cam.width * cam.height;
    println(halfImage, camMid01.width, camMid01.height);
    firstImage = true;
  } else
  {
  }
}

void draw() {
  image(cam, 0, 0, 320, height);
  if (firstImage)
  {
    cam.loadPixels();

    camMid00 = cam.get(0, 0, camMid00.width, camMid00.height); 
    camMid01 = cam.get(camMid01.width, 0, camMid01.width, camMid01.height); 
    
    
    broadcast(camMid00, clientPort00);
    broadcast(camMid01, clientPort01);
    
    image(camMid00, 320, 0, 320/2, height);
    image(camMid01, 320+320/2, 0, 320/2, height);
    noFill();
    stroke(255, 0, 0);
    rect(320, 0,  320/2, height);
    stroke(0, 255, 0);
    rect(320+320/2, 0, 320/2, height);
  }
}


// Function to broadcast a PImage over UDP
// Special thanks to: http://ubaa.net/shared/processing/udp/
// (This example doesn't use the library, but you can!)
void broadcast(PImage img, int clientPort_) {
  // We need a buffered image to do the JPG encoding
  BufferedImage bimg = new BufferedImage( img.width, img.height, BufferedImage.TYPE_INT_RGB );

  // Transfer pixels from localFrame to the BufferedImage
  img.loadPixels();
  bimg.setRGB( 0, 0, img.width, img.height, img.pixels, 0, img.width);

  // Need these output streams to get image as bytes for UDP communication
  ByteArrayOutputStream baStream	= new ByteArrayOutputStream();
  BufferedOutputStream bos		= new BufferedOutputStream(baStream);

  // Turn the BufferedImage into a JPG and put it in the BufferedOutputStream
  // Requires try/catch
  try {
    ImageIO.write(bimg, "jpg", bos);
  } 
  catch (IOException e) {
    println("has stop working on ImageIO.write(bimg, jpg, bos)");
    e.printStackTrace();
  }

  // Get the byte array, which we will send out via UDP!
  byte[] packet = baStream.toByteArray();

  // Send JPEG data as a datagram
  //println("Sending datagram with " + packet.length + " bytes");
  try {
    ds.send(new DatagramPacket(packet, packet.length, InetAddress.getByName("localhost"), clientPort_));
  } 
  catch (Exception e) {
    println("has stop working ds.send(new DatagramPacket(packet, packet.length, InetAddress.getByName(localhost), clientPort));");
    e.printStackTrace();
  }
}