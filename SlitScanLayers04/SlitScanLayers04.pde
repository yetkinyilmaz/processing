
import processing.video.*;

String take = "YuhYuhSmall_02";
float depthSpeed = 1.20;
float period = 30.;
float startFrame = 0;
float startDepth = 8;

float threshold = 8000;

float fps = 25;
int numSlices = 40;

int depthLayers = 1;

int numPixels;

PImage background;
PImage inputSubtracted;

Capture video;
Movie inputMovie;

PImage[] buffer;

Movie depthMap;
boolean depthMapResized = false;

int iDepth[];
int n_filled = 0;

int white = 0;


int bkgdR = 0;
int bkgdG = 0;
int bkgdB = 0;

int mode = 0;

boolean kilink = false;

void setup() {

  if(kilink){
    inputMovie = new Movie(this, "kilink_01.mov");
  }else{
   inputMovie = new Movie(this, "smallraw.mov");
}
    size(640, 480, P3D);
  

  frameRate(fps);
  imageMode(CENTER);
  textureMode(NORMAL);
    textureWrap(CLAMP);

  // This the default video input, see the GettingStartedCapture 
  // example if it creates an error
  //video = new Capture(this, 160, 120);


//    inputMovie = new Movie(this, "turist.mp4");


  depthMap = new Movie(this, "disp_depth3.mov");

background = createImage(width, height, ARGB);
inputSubtracted = createImage(width, height, ARGB);

  buffer = new PImage[numSlices];
  inputMovie.speed(1.);
  depthMap.speed(1.);

  inputMovie.loop();
  depthMap.loop();
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
  colorMode(ARGB);

  background.pixels = new int[numPixels];
  inputSubtracted.pixels = new int[numPixels];
  background.loadPixels();
  inputSubtracted.loadPixels();
  loadPixels();
  background(0);
depthMap.jump(0);
 

}

void draw() {

  if(frameCount > 80){
   mode = 1; 
  }
  
  if(mousePressed){
    camera(mouseX, mouseY, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);
  }
  
//   white = int(256. * ((0.5 + 0.5*cos(frameCount/period)) + frameCount/period));
 //  white = int(256. * ((0.5 + 0.5*cos(frameCount/period)) + frameCount/period));
  // white = int(256. * frameCount/period);
  inputMovie.loadPixels();
  depthMap.loadPixels();
//  inputMovie.read();
   if(n_filled < 1){
       for (int i = 0; i < numPixels; i++) {
      background.pixels[i] = inputMovie.pixels[i];
       }
       color bkgdColor = background.pixels[width*101/2];

       bkgdR = (bkgdColor >> 16) & 0xFF;
        bkgdG = (bkgdColor >> 8) & 0xFF;
        bkgdB = bkgdColor & 0xFF;

        //background.updatePixels();
        n_filled++;
  }

    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
          color currColor = inputMovie.pixels[i];
        color bkgdColor = background.pixels[i];
        // Extract the red, green, and blue components of the current pixel's color
        int currR = (currColor >> 16) & 0xFF;
        int currG = (currColor >> 8) & 0xFF;
        int currB = currColor & 0xFF;
        // Extract the red, green, and blue components of the background pixel's color
        //int bkgdR = (bkgdColor >> 16) & 0xFF;
        //int bkgdG = (bkgdColor >> 8) & 0xFF;
        //int bkgdB = bkgdColor & 0xFF;
        // Compute the difference of the red, green, and blue values
        int diffR = currR - bkgdR;
        int diffG = currG - bkgdG;
        int diffB = currB - bkgdB;
        // Add these differences to the running tally
        int presenceSum = diffR*diffR + diffG*diffG + diffB*diffB;
        // Render the difference image to the screen
//        inputSubtracted.pixels[i] = color(diffR, diffG, diffB);
//        if(brightness(inputSubtracted.pixels[i]) < 5){
//          inputSubtracted.pixels[i] = color(0, 0);
        if(mode > 0 && presenceSum < threshold){
            inputSubtracted.pixels[i] = color(0, 0);
        }else{
         inputSubtracted.pixels[i] = currColor;
        }
  }
  inputSubtracted.updatePixels();
    for(int j = 0; j < numSlices-1; ++j){
      if(j+1 < n_filled){
        buffer[j] = buffer[j+1].copy();
      }else{
        buffer[j] = inputSubtracted.copy();
      }
    n_filled += 1;
    buffer[numSlices-1] = inputSubtracted;
    
    }
    println("frame : ", frameCount, "white : ", white);
    // Difference between the current frame and the stored background
    int presenceSum = 0;
    if(n_filled > numSlices){

    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
    
      if(false){
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
    }

 //   updatePixels(); // Notify that the pixels[] array has changed
//  }
 stroke(255);
 // fill(0,0,0,0);
  tint(255);
 //       translate(width/2, height/2, -depthLayers*numSlices*10);
        translate(width/2, height/2, 0);

      for(int j = 0; j < numSlices; ++j){

            //  pushMatrix();
        scale(1. - 1./numSlices);
//        popMatrix();
     //  translate(0, 0, (j)*depthLayers);
    

        buffer[j].updatePixels();
        if(false){
          beginShape();
          texture(buffer[j]);
          float imageSize = 10*(numSlices - j);
          vertex(-imageSize, -imageSize, 0, 0);
          vertex(imageSize, -imageSize, 2, 0);
          vertex(imageSize, imageSize, 2, 2);
          vertex(-imageSize, imageSize, 0, 2);
          endShape(CLOSE);
        }
          image(buffer[j], 0, 0, width, height);
      }

  saveFrame("/Users/yetkin/"+take+"_period"+str(period)+"_start"+str(startFrame)+"/slit-######.png");
//   image(inputMovie, width/4, height/4, width/8, height/8);
//  image(inputSubtracted, width/4, 3*height/4, width/8, height/8);
//  image(background, 3*width/4, 3*height/4, width/8, height/8);


}

void mousePressed() {
  inputMovie.jump(random(inputMovie.duration()));
//  camera(mouseX, mouseY, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);

}

void movieEvent(Movie m) {
  m.read();
}