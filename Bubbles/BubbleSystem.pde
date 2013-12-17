/**
 * Sparkling Moves
 * Yetkin Yilmaz :P
 * based on
 * Frame Differencing 
 * by Golan Levin. 
 * 
 * Create particles at movement by frame-differencing.
 */ 

// Previous Tango Progress:
// Version 3 : Initiate work on clustering
// Version 4 : Introduce long time clusters and add seeds

// New module: For understanding diff in detail

import processing.video.*;

// Main parameters
float pLife = 90; // Particle lifetime - decrease for performance
int seedThreshold = 30; // Keep between 100-400
int pixelJump = 80; //Increase for better performance, decrease for quality // Not to create a particle for each pixel, but to randomly choose.
int seedRange = 8; // Search region around a triggering pixel
int maxParticles = 5000;

float reloop = 0; // Not used
float drMax = 50;
int diffThresholdGlobal = 0; 

// Global data

ParticleSystem ps;
int numPixels;
int[] previousFrame;
int counter = 0;
int seedArea = (2*seedRange+1)*(2*seedRange+1);
ArrayList seeds = new ArrayList();
ArrayList clusters = new ArrayList();
Capture video;
PImage bkgImage;

void setup() {
  size(800, 600, P3D);
  String[] cameras = Capture.list();
  
  bkgImage = loadImage("image.png");
  video = new Capture(this, width, height, 24);
  video.start();

  numPixels = video.width * video.height;
  // Create an array to store the previously captured frame
  previousFrame = new int[numPixels];
  loadPixels();
  colorMode(RGB, 255, 255, 255, 100);
  ps = new ParticleSystem(0, new PVector(width/2,height/2,0), 5000);
  smooth();
 
}

void draw() {
  background(0,120,160);

  image(video,0,0); 
  
  if (video.available()) {
    // When using video to manipulate the screen, use video.available() and
    // video.read() inside the draw() method so that it's safe to draw to the screen
    video.read(); // Read the new frame from the camera
    video.loadPixels(); // Make its pixels[] array available
//    for (int i = 0; i < numPixels; i++) {
//      pixels[i] = color(0,0,0);
//    }

    // Amount of movement in the frame
    int movementSum = 0;
color[] coltemp = new color[height*width];
    for(int iy = 0; iy < height; iy = iy + ((int)random(0,pixelJump))){
      for(int ix = 0; ix < width; ix = ix + ((int)random(0,pixelJump))){
//  for(int iy = 0; iy < height; iy = iy + 1){
//      for(int ix = 0; ix < width; ix = ix + 1){ 
        int i = iy*width+ix;
        if(i > width * height) continue;
        if(i < 0 ) continue;
            
        // To skip first frames where the diff is confused, 
        // but doesn't work. What's the problem? 

        int d = getColorDiff(i);
        movementSum += d;

        coltemp[i] = color(0,0,0);
        if(d > seedThreshold){ 
 //          col = color(0,100,0);          
       println(i);
  
          seeds.add(new PixelSeed(i,d,counter));
          //       ps.addParticle(ix,iy, pLife); 
          //        if(ix > pixelJump){
            //          ix = ix - ((int)random(0,(int)((float)pixelJump/reloop)));
          //        }
        }

//    previousFrame[i] = video.pixels[i];
//        pixels[i] = col;  
    }
  }

//println("Global" + movementSum);
  if (movementSum > diffThresholdGlobal) {      
      int i1 = 0;

//   println("alo" + seeds.size());
      for(int is = 0; is < seeds.size(); ++is){
        PixelSeed sd = (PixelSeed) seeds.get(is);
//      if( sd.sumColorDiff() > sd.diff*seedArea){
        if( sd.sumColorDiff() > seedThreshold*seedArea){
 
if(ps.particles.size() < maxParticles){   
          println("added particle " + seeds.size() + " seeds");
           ps.addParticle(sd.x,sd.y, pLife); 
}

          coltemp[sd.i] = color(0,100,0);          
          //Find cluster and stick to it

/*
          for(int ic = 0; ic < clusters.size(); ++ic){    
            PixelCluster cl = (PixelCluster) clusters.get(ic);        
            if(deltaR(sd.i,cl.i) < drMax){
              cl.seed(sd);
            }else{
              // Form a new cluster
              if(deltaR(i1,sd.i) < drMax){        
                clusters.add(new PixelCluster());        
              }
            }  
          }
*/          
          
          
          i1 = sd.i;                    
        }
      }
    
      for(int ic = 0; ic < clusters.size(); ++ic){    
        PixelCluster cl = (PixelCluster) clusters.get(ic);
//        if(cl.seeds.size() > 1) pixels[cl.i] = color(0,100,0);
//        ps.addParticle(cl.loc.x,cl.loc.y, pLife);
      }
      // To prevent flicker from frames that are all black (no movement),
      // only update the screen if the image has changed.
      //     updatePixels();  // Switch on for debug mode.
      // Print the total amount of movement to the console
//      updatePixels();
//      ps.run();
    }  

//If simply want to display the diff.


for(int i = 0; i < height*width; ++i){  
      previousFrame[i] = video.pixels[i];
//        pixels[i] = coltemp[i];  
}

//   println("Particles " + ps.particles.size());

//if(ps.particles.size() < 2500) ps.run();
//else ps.particles.clear();
  }
/*

   camera(width/2.0, height/2.0 - mouseY, (height/2.0) / tan(PI*60.0 / 360.0), // eyeX, eyeY, eyeZ
          width/2.0, height/2.0, 0, // centerX, centerY, centerZ
         0, 1, 0); // upX, upY, upZ
*/

ps.run();

 counter++;

      seeds.clear();
}

float deltaR(int i1, int i2){
 
  // Can be done faster, using indices directly?
  
     int x1 = i1 % width;
    int y1 = (i1-x1)/width; 
 
       int x2 = i2 % width;
    int y2 = (i2-x2)/width; 

float dx = x2 - x1;
float dy = y2 - y1;
 
 float r = sqrt(dx*dx+dy*dy);
  return r;
}
