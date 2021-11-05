
import processing.video.*;

int numSlices = 25;
int numPixels;

int[] backgroundPixels;
Capture video;

PImage[] buffer;

Movie depthMap;
boolean depthMapResized = false;

int iDepth[];


class PGraphics{
    int width;
    int height;
    int numPixels;
    color pixels[];
};

PGraphics pg;


void setup() {

  size(1280, 720);
  //  fullScreen();
  pg = new PGraphics();
  pg.width = 800;
  pg.height = 600;
  pg.pixels = new color[pg.width * pg.height];
  video = new Capture(this, pg.width, pg.height);
  
  // Need to put a displacement map video
  // inside the data directory
  depthMap = new Movie(this, "disp_depth.mov");
  buffer = new PImage[numSlices];

  video.resize(pg.width, pg.height);
  depthMap.loop();
  video.start();  
  
  iDepth = new int[width*height];
  for(int i = 0; i < width*height; ++i){
    int ix = width - (i % width);
    int iy = (i - ix)/width;
    int mx = depthMap.width * ix / width;
    int my = depthMap.height * iy / height;
    iDepth[i] = my * depthMap.width + mx;
  }
  numPixels = width * height;
  pg.numPixels = pg.width * pg.height;

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
    if(frameCount > numSlices+200){
    for (int i = 0; i < pg.numPixels; i++) {
      int slicecolor = (depthMap.pixels[i] >> 16) & 0xFF;
      for(int j = 0; j < numSlices; ++j){
          float mincolor = j*256./numSlices;
          float maxcolor = (j+1)*256./numSlices;
          boolean sliced = (slicecolor >= mincolor && slicecolor < maxcolor);
          if(sliced){
            pg.pixels[i] = buffer[j].pixels[i];
          }
        }
      }      
    }

//    updatePixels();
  }

for(int i = 0; i < numPixels; ++i){
  pixels[i] = pg.pixels[iDepth[i]];
}
updatePixels();
//  image(pg.pixels, 0, 0, width, height); 

//  saveFrame("selfie/slit-######.png");

}

void movieEvent(Movie m) {
  m.read();
}
