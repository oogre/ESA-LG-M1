
import java.io.*;
import java.util.*;

File[] files;
PImage output;
void settings() {
  String path = sketchPath("../data/jaffe");

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

  output = createImage(width /2, height, RGB);
  background(0);
}
void draw() {

  output.loadPixels();
  File file = files[(int)random(files.length)];

  PImage src = loadImage(file.getPath());
  //PImage src = loadImage(files[frameCount % files.length].getPath());
  int minX = (int)random(output.width);
  int maxX = (int)random(minX, output.width);
  int minY = (int)random(output.height);
  int maxY = (int)random(minY, output.height);

  output.set(minX, minY, src.get(minX, minY, maxX, maxY));
  /* for (int y = minY; y < maxY; y ++) {
   for (int x = minX; x < maxX; x ++) {
   output.pixels[x + y*output.width] = src.pixels[x + y*output.width];
   }
   }*/
  output.updatePixels();
  //
  image(output, 0, 0, width*0.5, height);
  //tint(255, 20);
  image(src, width*0.5, 0, width*0.5, height);
  delay(50);
}

// This function returns all the files in a directory as an array of Strings  
File[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File names[] = file.listFiles(new ImageFileFilter());
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}

public class ImageFileFilter implements FileFilter {
  private final String[] okFileExtensions = new String[] {"jpg"};
  public boolean accept(File file) {
    for (String extension : okFileExtensions) {
      if (file.getName().toLowerCase().endsWith(extension)) return true;
    }
    return false;
  }
}