
import java.io.*;
import java.util.*;
import gab.opencv.*;
import java.awt.Rectangle;

OpenCV opencv;
Rectangle[] faces;


File[] files;
PImage output;
void settings() {
  String path = sketchPath("../../data/original images");

  Collection f = FileUtils.listFiles(
    new File(path), 
    new RegexFileFilter("^(.*?)(jpg|png)$"), 
    DirectoryFileFilter.DIRECTORY
    );

  files = (File[])(f.toArray(new File[f.size()]) );
  PImage sample = loadImage(files[0].getPath());
  size(sample.width*2, sample.height);
}

void setup() {
  surface.setResizable(true);
  opencv = new OpenCV(this, width/2, height);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  output = createImage(width/2, height, RGB);
  background(0);
}
void draw() {


  File file = files[(int)random(files.length)];

  PImage src = loadImage(file.getPath());
  int minX = (int)random(output.width);
  int maxX = (int)random(minX, output.width);
  int minY = (int)random(output.height);
  int maxY = (int)random(minY, output.height);
  src.loadPixels();
  output.set(minX, minY, src.get(minX, minY, maxX, maxY));
  output.updatePixels();
  //tint(255, 20);
 // image(output, 0, 0, width*0.5, height);
  image(src, 0, 0, width*0.5, height);
  opencv.loadImage(src);
  faces = opencv.detect();
  noFill();
  stroke(255, 0, 0);
  for (int i = 0; i < faces.length; i++) {
    image(src.get(faces[i].x, faces[i].y, faces[i].width, faces[i].height), width*0.5, 0, width*0.5, height);
   // rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }
}