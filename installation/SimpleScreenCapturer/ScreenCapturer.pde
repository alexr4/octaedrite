import java.awt.Robot;
import java.awt.Rectangle;
import java.awt.AWTException;

class SimpleScreenCapture {

  Robot robot;

  PImage screenshot;

  SimpleScreenCapture() {
    try {
      robot = new Robot();
    }
    catch (AWTException e) {
      println(e);
    }
  }

 

  PImage get() {
    screenshot = new PImage(robot.createScreenCapture(new Rectangle(0, 0, width, height)));
    return screenshot;
  }
  
   PImage get(int x_, int y_, int w_, int h_) {
    screenshot = new PImage(robot.createScreenCapture(new Rectangle(x_, y_, w_, h_)));
    return screenshot;
  }
}