import gab.opencv.*;


void setup() {
  size(1280, 720, P2D);
  smooth(8);
  PApplet context = this;
  initOpenCV(context);
  initVariables();
  computeShape(18, octaPath.getPoints().size(), 0.5, 5, 50);
}

void draw() {
  background(255);
  image(src, 0, 0, diffuse.width * .5, diffuse.height * .5);
  image(diffuse, 0, 0, diffuse.width * .5, diffuse.height * .5);
  shape(octa);

  displayProgressiveShape(60);

  fill(255, 0, 0);
  ellipse(octaCenter.x, octaCenter.y, 20, 20);

  //ArrowDebug
  displayOrientationArrow(10);

  //normals
  displayNormals(20);

  //follower
  followContour(5);
  displayFollower();
}



