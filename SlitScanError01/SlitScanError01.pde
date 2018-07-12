
/**
 * Hi Dina!
 * It`s been such a good time in Rijeka. 
 * By the help of the workshop, I went back to coding in 
 * processing (also realizing I gotta save myself from 
 * mac-exclusive software - i.e. my first love Quartz Composer)
 * and started to rewrite some of my compositions, such as
 * this slit scan. My motivation for producing new stuff is
 * back...
 * Also the sea had a very good effect on us, so we will
 * remember this dense five days for long. Maybe we`re still
 * living it, all times are connected. That`s a kind of 
 * space-time object, or slit-scan, right there!
 * Many thanks to Sarah, Ana, Vedran, Hrvoje,
 * hope to see you all soon!
 */

import processing.video.*;

int numSlices = 40;
int numPixels;

int[] backgroundPixels;
Capture video;

PImage[] buffer;

Movie depthMap;
boolean depthMapResized = false;

int iDepth[];

PGraphics errorGraph;
float[] errors;
float shift = 0.;
int radius = 10;

void setup() {
  size(640, 480); 

  // to be pointing to a video file in [sketch_dir]/data/
  depthMap = new Movie(this, "disp_depth.mov");

  video = new Capture(this, width, height);
  buffer = new PImage[numSlices];

  video.resize(width, height);
  depthMap.loop();
  // Start capturing the images from the camera
  video.start();  
  
  iDepth = new int[width*height];
  for(int i = 0; i < width*height; ++i){
    int ix = i % width;
    int iy = (i - ix)/width;
    int mx = depthMap.width * ix / width;
    int my = depthMap.height * iy / height;
    iDepth[i] = my * depthMap.width + mx;
  }
  numPixels = width * height;
  loadPixels();
  
  errorGraph = createGraphics(400, 100);
  errorGraph.beginDraw();
  errorGraph.imageMode(CENTER);
  imageMode(CENTER);

}

void draw() {
  errorGraph.beginDraw();

  if (video.available()) {
    video.read(); // Read a new video frame
    for(int j = 0; j < numSlices-1; ++j){
      if(j+1 < frameCount){
        buffer[j] = buffer[j+1];
      }else{
        buffer[j] = video.get();
      }
  }
    
    buffer[numSlices-1] = video.get();
    if(frameCount > numSlices+500){

    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      int slicecolor = (depthMap.pixels[iDepth[i]] >> 16) & 0xFF;
      for(int j = 0; j < numSlices; ++j){
          float mincolor = j*256./numSlices;
          float maxcolor = (j+1)*256./numSlices;
          boolean sliced = (slicecolor >= mincolor && slicecolor < maxcolor);
          if(sliced){
            pixels[i] = buffer[j].pixels[i];
          }
        }
      }      
    }
    updatePixels(); // Notify that the pixels[] array has changed
  }

    fill(255);
    rect(width - 100, height - 60, 85, 25, 7);
    fill(0);
    float error = difference(pixels, video.pixels);
    text(str(error), width - 95, height - 45);
    drawError(error, color(255,255,255));

}

void drawError(float error, color col) { 
  int point = 10;
  PImage img = errorGraph.get();
  errorGraph.background(0,0,0,255);
  errorGraph.image(img, errorGraph.width/2-shift, errorGraph.height/2);
  errorGraph.fill(col, 255);
  errorGraph.ellipse(errorGraph.width - 4*point, 
    errorGraph.height * (1. - error/1.) , 
    point, point);
  errorGraph.endDraw();
  image(errorGraph, 220, 400);
  shift = 0.01;
}

float difference(int[] pixels1, int[] pixels2){
    float scale = 5.E9;
    float movementSum = 0; // Amount of movement in the frame
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      color currColor = pixels1[i];
      color prevColor = pixels2[i];
      // Extract the red, green, and blue components from current pixel

      int currR = (currColor >> 16) & 0xFF; // Like red(), but faster
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract red, green, and blue components from previous pixel
      int prevR = (prevColor >> 16) & 0xFF;
      int prevG = (prevColor >> 8) & 0xFF;
      int prevB = prevColor & 0xFF;

      // Compute the difference of the red, green, and blue values
      float diffR = pow(currR - prevR, 2);
      float diffG = pow(currG - prevG, 2);
      float diffB = pow(currB - prevB, 2);
      // Add these differences to the running tally
      movementSum += (diffR + diffG + diffB)/scale;
    }
  return movementSum;
}

void movieEvent(Movie m) {
  m.read();
}