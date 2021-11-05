/**
 * Simple Particle System
 * by Daniel Shiffman.  
 * 
 * Particles are generated each cycle through draw(),
 * fall with gravity and fade out over time
 * A ParticleSystem object manages a variable size (ArrayList) 
 * list of particles. 
 */

import processing.video.*;
 
boolean displayVideo = true; 
int pace = 2;
int barrier = 110;
 
 int nsteps = 1000064;
float elasticity = 0.4;
int stepThreshold = 900;
int range = 3;
float acceleration = 0.25;

ParticleSystem ps;
int counter = 0;
int source = 0;
int numPixels;

Capture video;


void setup() {
  size(1280, 720, P3D);
  
  video = new Capture(this, width, height, 24);
  video.start();

  numPixels = video.width * video.height;
  loadPixels();

  colorMode(RGB, 255, 255, 255, 100);
  ps = new ParticleSystem(1, new PVector(width/2,height/2,0));
  
  smooth();

}

void draw() {
  background(0);

  if (video.available()) {
    // When using video to manipulate the screen, use video.available() and
    // video.read() inside the draw() method so that it's safe to draw to the screen
    video.read(); // Read the new frame from the camera
    video.loadPixels(); // Make its pixels[] array available
    
  }

// For development
if(displayVideo){
for(int i = 0; i < numPixels; ++i){
  pixels[i] = video.pixels[i];
  
 //   pixels[i]=color(120,0.5,200);
}
}

 updatePixels();
 ps.run();

if(counter++ % pace == 0){
ps.addParticle(mouseX,mouseY);

////  ps.addParticle(source,0); // Tarama modu

}


source += 5;

if(source >= 799) source = 0;


}



