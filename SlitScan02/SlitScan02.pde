/**
 * Background Subtraction 
 * by Golan Levin. 
 *
 * Detect the presence of people and objects in the frame using a simple
 * background-subtraction technique. To initialize the background, press a key.
 */


import processing.video.*;

int numSlices = 5;
int numPixels;

int[] backgroundPixels;
Capture video;
Movie inputMovie;

PImage[] buffer;

Movie depthMap;
boolean depthMapResized = false;

int iDepth[];

void setup() {
  size(640, 480); 

  // This the default video input, see the GettingStartedCapture 
  // example if it creates an error
  //video = new Capture(this, 160, 120);
  inputMovie = new Movie(this, "turist.mp4");
  depthMap = new Movie(this, "LPM_noise_1_revised.mp4");
  buffer = new PImage[numSlices];

  inputMovie.loop();
  depthMap.loop();
  // Start capturing the images from the camera 
  
  iDepth = new int[width*height];
  for(int i = 0; i < width*height; ++i){
    int ix = i % width;
    int iy = (i - ix)/width;
    int mx = depthMap.width * ix / width;
    int my = depthMap.height * iy / height;
    iDepth[i] = my * depthMap.width + mx;
//    print(iDepth[i]);
  }
  
  numPixels = width * height;
  // Create array to store the background image
  // Make the pixels[] array available for direct manipulation
  loadPixels();
}

void draw() {

  if (inputMovie.available()) {
    for(int j = 0; j < numSlices-1; ++j){
      if(j+1 < frameCount){
//        print("buffer", j, "\n");
        buffer[j] = buffer[j+1];
      }else{
        buffer[j] = inputMovie.get();
      }
  }
    
    buffer[numSlices-1] = inputMovie.get();
    // Difference between the current frame and the stored background
    int presenceSum = 0;
    if(frameCount > numSlices+500){

    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      int slicecolor = (depthMap.pixels[iDepth[i]] >> 16) & 0xFF;
 //     print("slice color : ", slicecolor);
      for(int j = 0; j < numSlices; ++j){
//          print("a");
//          print("b");
          float mincolor = j*256./numSlices;
          float maxcolor = (j+1)*256./numSlices;
          boolean sliced = (slicecolor >= mincolor && slicecolor < maxcolor);
          if(sliced){
 //           print("j", j, "\n");
            pixels[i] = buffer[j].pixels[i];
//            print("k", j, "\n");
          }else{
 //           pixels[i] = depthMap.pixels[iDepth[i]]; 

          }
        }
      }      
    }
    updatePixels(); // Notify that the pixels[] array has changed
  }

//  image(depthMap, width/4, 3*height/4, width/8, height/8);
//  image(video, 3*width/4, 3*height/4, width/8, height/8);

}

void mousePressed() {
  inputMovie.jump(random(inputMovie.duration()));
}

void movieEvent(Movie m) {
  m.read();
}