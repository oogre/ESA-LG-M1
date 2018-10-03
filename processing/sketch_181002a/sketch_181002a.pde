import java.io.*;
import java.util.*;
int n = 3;

/*
 ···
 ···
 ··o
 */
Multimap<String, Integer> nGrams;
File[] files;
PImage output;
int maxSrc = 100;
void setup() {
  size(512, 255);
  surface.setResizable(true);
  nGrams = HashMultimap.create();
  String path = sketchPath("../../data/jaffe");
  files = listFileNames(path);
  int counter = 0;
  for (File f : files)
  {
    println("file: " + f.getName());
    PImage img = loadImage(f.getPath());
    img.loadPixels();
    if (output == null) {
      output = createImage(img.width, img.height, RGB);
    }
    for (int y = 0; y < img.height; y ++) {
      for (int x = 0; x < img.width; x ++) {
        int currentPixel = img.pixels[x + y * img.width];
        String key = ""; 
        for (int _y = y - n; _y <= y; _y ++) {
          for (int _x = x - n; _x <= x; _x ++) {
            if (_x < 0 || _y < 0 || _x >= img.width || _y >= img.height || (_x == x && _y == y)) {
              key+= "";
            } else {
              color c = img.pixels[_x + _y * img.width];
              key+= ((c >> 16 & 0xFF) / 32);//+nf(c >> 8 & 0xFF, 3)+nf(c & 0xFF, 3);
            }
          }
        }
        nGrams.put(key, currentPixel);
      }
    }
    if (++counter >= maxSrc) break;
    println(counter);
  }
}
void draw() {
  background(0);
  output.set(0, 0, get(0, 0, output.width, output.height));
  output.loadPixels();
  PImage src = loadImage(files[(int)random(files.length)].getPath());
  int minX = (int)random(output.width * 0.5);
  int maxX = (int)random(minX + output.width * 0.5, output.width);
  int minY = (int)random(output.height * 0.5);
  int maxY = (int)random(minY + output.height * 0.5, output.height);
  for (int y = minY; y < maxY; y ++) {
    for (int x = minX; x < maxX; x ++) {
      output.pixels[x + y*output.width] = src.pixels[x + y*output.width];
    }
  }
  output.updatePixels();
  
  output.loadPixels();
  
  int currentPixel = output.pixels[minX + minY * output.width];
  for (int y = minY; y < output.height; y ++) {
    for (int x = minX; x < output.width; x ++) {
      if (!(x >= minX && x < maxX) || !(y >= minY && y < maxY)) {
        String key = ""; 
        for (int _y = y - n; _y <= y; _y ++) {
          for (int _x = x - n; _x <= x; _x ++) {
            if (_x < 0 || _y < 0 || _x >= output.width || _y >= output.height || (_x == x && _y == y)) {
              key += "";
            } else {
              color c = output.pixels[_x + _y * output.width];
              key += ((c >> 16 & 0xFF) / 32);//+nf(c >> 8 & 0xFF, 3)+nf(c & 0xFF, 3);
            }
          }
        }
        
        if (nGrams.containsKey(key)) {
          java.util.Collection<Integer> value = nGrams.get(key);
          currentPixel = (int)(value.toArray()[(int)random(value.size())]);
        }
        output.pixels[x + y*output.width] = currentPixel;
      }
    }
  }
  output.updatePixels();
  
  background(0);
  image(output, 0, 0, width*0.5, height);
  //tint(255, 20);
  image(src, width*0.5, 0, width*0.5, height);
  //delay(1000);
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