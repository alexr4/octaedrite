void loadTextures()
{
  diffuse = loadImage("diffuse.jpg");
  bumpmap = loadImage("bumpmap.jpg");
  mask = loadImage("mask.jpg");
  displacement = loadImage("displacement.jpg");

  textureList = new ArrayList<PImage>();
  textureList.add(diffuse);
  textureList.add(bumpmap);
  textureList.add(mask);
  textureList.add(displacement);
}

void loadShapeShader()
{
  octaShader = loadShader("shader/frag.glsl", "shader/vert.glsl");

  octaShader.set("mask", textureList.get(2));
  octaShader.set("bumpmap", textureList.get(1));
  octaShader.set("displacement", textureList.get(3));
  octaShader.set("kd", new PVector(0.25, 0.25, 0.25));
  octaShader.set("ka", new PVector(0.5, 0.5, 0.5));
  octaShader.set("ks", new PVector(1, 1, 1));
  octaShader.set("emissive", new PVector(.5, .5, .5));// new PVector(0.1, 0.1, 0.1));
  octaShader.set("shininess", 500.0);
  octaShader.set("minNormalEmissive", 0.25);
}

void init3DShape(float w, float h, float scale)
{
  float fw = (w/2) * scale;
  float fh = (h/2) * scale;
  vertList = new ArrayList<PVector>();
  colorList = new ArrayList<PVector>();
  texCoord = new ArrayList<PVector>();
  normalList = new ArrayList<PVector>();

  vertList.add(new PVector(-1 * fw, 1 * fh, 0));
  vertList.add(new PVector(-1 * fw, -1 * fh, 0));
  vertList.add(new PVector(1 * fw, -1 * fh, 0));
  
  vertList.add(new PVector(-1 * fw, 1 * fh, 0));
  vertList.add(new PVector(1 * fw, -1 * fh, 0));
  vertList.add(new PVector(1 * fw, 1 * fh, 0));  

  colorList.add(new PVector(-1 * 255, 1 * 255, 0));
  colorList.add(new PVector(-1 * 255, -1 * 255, 0));
  colorList.add(new PVector(1 * 255, -1 * fh, 0));
  
  colorList.add(new PVector(-1 * 255, 1 * 255, 0));
  colorList.add(new PVector(1 * 255, -1 * fh, 0));
  colorList.add(new PVector(1 * 255, 1 * 255, 0));

  normalList.add(new PVector(0, 0, 1));
  normalList.add(new PVector(0, 0, 1));
  normalList.add(new PVector(0, 0, 1));
  
  normalList.add(new PVector(0, 0, 1));
  normalList.add(new PVector(0, 0, 1));
  normalList.add(new PVector(0, 0, 1));

  texCoord.add(new PVector(0, 1));
  texCoord.add(new PVector(0, 0));
  texCoord.add(new PVector(1, 0));
  
  texCoord.add(new PVector(0, 1));
  texCoord.add(new PVector(1, 0));
  texCoord.add(new PVector(1, 1));

  octa = createShape();
  createOcta();
}

void createOcta()
{
  octa.beginShape(TRIANGLES);
  octa.textureMode(NORMAL);
  octa.texture(textureList.get(0));
  octa.noStroke();

  for (int i = 0; i<vertList.size(); i+=3)
  {  
    octa.fill(colorList.get(i).x, colorList.get(i).y, colorList.get(i).z);
    octa.normal(normalList.get(i).x, normalList.get(i).y, normalList.get(i).z);
    octa.vertex(vertList.get(i).x, vertList.get(i).y, vertList.get(i).z, texCoord.get(i).x, texCoord.get(i).y);

    octa.fill(colorList.get(i+1).x, colorList.get(i+1).y, colorList.get(i+1).z);
    octa.normal(normalList.get(i+1).x, normalList.get(i+1).y, normalList.get(i+1).z);
    octa.vertex(vertList.get(i+1).x, vertList.get(i+1).y, vertList.get(i+1).z, texCoord.get(i+1).x, texCoord.get(i+1).y);

    octa.fill(colorList.get(i+2).x, colorList.get(i+2).y, colorList.get(i+2).z);
    octa.normal(normalList.get(i+2).x, normalList.get(i+2).y, normalList.get(i+2).z);
    octa.vertex(vertList.get(i+2).x, vertList.get(i+2).y, vertList.get(i+2).z, texCoord.get(i+2).x, texCoord.get(i+2).y);
  }
  octa.endShape();
}

void changeTexture(int i)
{
  octa.beginShape(TRIANGLES);
  octa.texture(textureList.get(i));
  octa.endShape();
}

void showDebugStroke()
{
  octa.beginShape(TRIANGLES);
  octa.textureMode(NORMAL);
  octa.texture(textureList.get(0));
   for (int i = 0; i<vertList.size()-2; i+=3)
  {  
    octa.stroke(colorList.get(i).x, colorList.get(i).y, colorList.get(i).z);
    octa.normal(normalList.get(i).x, normalList.get(i).y, normalList.get(i).z);
    octa.vertex(vertList.get(i).x, vertList.get(i).y, vertList.get(i).z, texCoord.get(i).x, texCoord.get(i).y);

    octa.stroke(colorList.get(i+1).x, colorList.get(i+1).y, colorList.get(i+1).z);
    octa.normal(normalList.get(i+1).x, normalList.get(i+1).y, normalList.get(i+1).z);
    octa.vertex(vertList.get(i+1).x, vertList.get(i+1).y, vertList.get(i+1).z, texCoord.get(i+1).x, texCoord.get(i+1).y);

    octa.stroke(colorList.get(i+2).x, colorList.get(i+2).y, colorList.get(i+2).z);
    octa.normal(normalList.get(i+2).x, normalList.get(i+2).y, normalList.get(i+2).z);
    octa.vertex(vertList.get(i+2).x, vertList.get(i+2).y, vertList.get(i+2).z, texCoord.get(i+2).x, texCoord.get(i+2).y);
  }
  octa.endShape();
}