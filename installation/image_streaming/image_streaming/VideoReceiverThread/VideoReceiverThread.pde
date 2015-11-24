// Daniel Shiffman
// <http://www.shiffman.net>

// A Thread using receiving UDP to receive images

import java.awt.image.*; 
import javax.imageio.*;
import java.net.*;
import java.io.*;

PImage video00;
PImage video01;
ReceiverThread thread00;
ReceiverThread thread01;

void setup() {
  size(960, 720);
  video00 = createImage(480, 720, RGB);
  video01 = createImage(480, 720, RGB);
  thread00 = new ReceiverThread(video00.width, video00.height, 9100);
  thread01 = new ReceiverThread(video00.width, video00.height, 9200);
  thread00.start();
  thread01.start();
}

void draw() {
  if (thread00.available()) {
    video00 = thread00.getImage();
  }
  if (thread01.available()) {
    video01 = thread01.getImage();
  }

  // Draw the image
  background(0);
  image(video00, 0,0, video00.width, video00.height);//width/2, height/2);
  image(video01, video00.width,0, video01.width, video01.height);//width/2, height/2);
}