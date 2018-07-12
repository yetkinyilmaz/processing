
import processing.video.*;

int numSlices = 20;
int numPixels;

int[] backgroundPixels;
Capture video;

PImage[] buffer;

Movie depthMap;
boolean depthMapResized = false;

int iDepth[];

void setup() {
  size(640, 480); 

  video = new Capture(this, width, height);
  
  // Need to put a displacement map video
  // inside the data directory
  depthMap = new Movie(this, "disp_depth.mov");
  buffer = new PImage[numSlices];

  video.resize(width, height);
  depthMap.loop();
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
}

void draw() {

  if (video.available()) {
    video.read();
    for(int j = 0; j < numSlices-1; ++j){
      if(j+1 < frameCount){
        buffer[j] = buffer[j+1];
      }else{
        buffer[j] = video.get();
      }
  }
    
    buffer[numSlices-1] = video.get();
    if(frameCount > numSlices+500){
    for (int i = 0; i < numPixels; i++) {
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
    updatePixels();
  }
  saveFrame("selfie/slit-######.png");

}

void movieEvent(Movie m) {
  m.read();
}