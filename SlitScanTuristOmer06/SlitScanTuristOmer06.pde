
import processing.video.*;

String take = "Nikah01";
float depthSpeed = 0.20;
float period = 30.;
float startFrame = 0;
float startDepth = 8;

float fps = 2.5;
int numSlices = 100;
int numPixels;

int[] backgroundPixels;
Capture video;
Movie inputMovie;

PImage[] buffer;

Movie depthMap;
boolean depthMapResized = false;

int iDepth[];
int n_filled = 0;

int white = 0;

void setup() {
  size(1280, 720); 
  frameRate(fps);
  // This the default video input, see the GettingStartedCapture 
  // example if it creates an error
  //video = new Capture(this, 160, 120);


//    inputMovie = new Movie(this, "turist.mp4");

//  inputMovie = new Movie(this, "Turist_360p_01.mov");
  inputMovie = new Movie(this, "Nikah.mov");
//  depthMap = new Movie(this, "LPM_noise_1_revised.mp4");
  depthMap = new Movie(this, "disp_depth3.mov");

  buffer = new PImage[numSlices];
  inputMovie.speed(fps/25/5);
  depthMap.speed(fps*depthSpeed/25/5);

  inputMovie.play();
  depthMap.play();
  inputMovie.volume(0);
  inputMovie.jump(startFrame);
  depthMap.jump(startDepth);
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
  background(0);
depthMap.jump(0);

}

void draw() {
  if(n_filled < 1){
     inputMovie.jump(startFrame);
       depthMap.jump(startDepth);
  }
//   white = int(256. * ((0.5 + 0.5*cos(frameCount/period)) + frameCount/period));
 //  white = int(256. * ((0.5 + 0.5*cos(frameCount/period)) + frameCount/period));
  // white = int(256. * frameCount/period);
  inputMovie.loadPixels();
  depthMap.loadPixels();
//  if (inputMovie.available()) {
    inputMovie.read();
    for(int j = 0; j < numSlices-1; ++j){
      if(j+1 < n_filled){
        buffer[j] = buffer[j+1];
      }else{
        buffer[j] = inputMovie.get();
      }
    n_filled += 1;
    buffer[numSlices-1] = inputMovie.get();
    
    }
    println("frame : ", frameCount, "white : ", white);
    // Difference between the current frame and the stored background
    int presenceSum = 0;
    if(n_filled > numSlices){

    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      int slicecolor = white + (depthMap.pixels[iDepth[i]] >> 16) & 0xFF;
      if(slicecolor > 255) slicecolor = 255;
 //     print("slice color : ", slicecolor);
      for(int j = 0; j < numSlices; ++j){
//          print("a");
//          print("b");
//          float mincolor = (numSlices-j-1)*256./numSlices;
//          float maxcolor = (numSlices-j)*256./numSlices;
          float mincolor = (j)*256./numSlices;
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
//  }

  saveFrame("/Volumes/PlatinExFAT/Turist"+take+"_period"+str(period)+"_start"+str(startFrame)+"/slit-######.png");
//  image(depthMap, width/4, 3*height/4, width/8, height/8);
//  image(inputMovie, 3*width/4, 3*height/4, width/8, height/8);

}

void mousePressed() {
 // inputMovie.jump(random(inputMovie.duration()));
}

void movieEvent(Movie m) {
  m.read();
}