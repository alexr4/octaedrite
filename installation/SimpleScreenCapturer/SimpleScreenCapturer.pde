SimpleScreenCapture simpleScreenCapture;

void setup() {
size(1920, 1080, P3D);
simpleScreenCapture = new SimpleScreenCapture();

}

void draw() {

image(simpleScreenCapture.get(), 0, 0, width, height);

}