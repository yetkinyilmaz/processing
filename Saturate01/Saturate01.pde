/**
 * Background Subtraction 
 * by Golan Levin. 
 *
 * Detect the presence of people and objects in the frame using a simple
 * background-subtraction technique. To initialize the background, press a key.
 */


import processing.video.*;

int numSlices = 30;
int numPixels;

int[] backgroundPixels;
Capture video;
PImage[] buffer;

Movie movie;
boolean movieResized = false;

int iDepth[];

void setup() {
  size(320, 240); 

  // This the default video input, see the GettingStartedCapture 
  // example if it creates an error
  //video = new Capture(this, 160, 120);
  video = new Capture(this, width, height);
  movie = new Movie(this, "LPM_noise_1_revised.mp4");
  buffer = new PImage[numSlices];

  iDepth = new int[width*height];
  for(int i = 0; i < width*height; ++i){
    int ix = i % width;
    int iy = (i - ix)/width;
    int mx = movie.width * ix / width;
    int my = movie.height * iy / height;
    iDepth[i] = my * movie.width + mx;
  }


  video.resize(width, height);
  movie.loop();
  // Start capturing the images from the camera
  video.start();  
  
  numPixels = video.width * video.height;
  // Create array to store the background image
  backgroundPixels = new int[numPixels];
  // Make the pixels[] array available for direct manipulation
  loadPixels();
}

void draw() {
  if(!movieResized && movie.available()){
//     movie.resize(width, height);
     movieResized = true;
  }
  
  if (video.available()) {


    video.read(); // Read a new video frame
//    video.loadPixels(); // Make the pixels of video available
    if(movie.available()){
    }
    for(int j = 0; j < numSlices-1; ++j){
      if(j+1 < frameCount){
        print("buffer", j, "\n");
        buffer[j] = buffer[j+1];
      }else{
        buffer[j] = video.get();
      }
  }
    
    buffer[numSlices-1] = video.get();
    // Difference between the current frame and the stored background
    int presenceSum = 0;
    if(frameCount > numSlices+100){

    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      int slicecolor = (movie.pixels[iDepth[i]] >> 16) & 0xFF;
 //     print("slice color : ", slicecolor);
      for(int j = 0; j < numSlices; ++j){
//          print("a");
//          print("b");
          float mincolor = j*256./numSlices;
          float maxcolor = (j+1)*256./numSlices;
          boolean sliced = (slicecolor >= mincolor && slicecolor < maxcolor);
          if(sliced){
 //           print("j", j, "\n");
            pixels[i] = buffer[j].pixels[i]+movie.pixels[iDepth[i]]; 
//            print("k", j, "\n");
          }
        }
      }      
    }
    updatePixels(); // Notify that the pixels[] array has changed
  }

  image(movie, width/4, 3*height/4, width/8, height/8);
  image(video, 3*width/4, 3*height/4, width/8, height/8);

}

void movieEvent(Movie m) {
  m.read();
//  movie.loadPixels(); 
//  m.resize(width, height);

}