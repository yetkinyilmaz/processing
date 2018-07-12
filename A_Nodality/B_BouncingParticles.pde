/**
 * Simple Particle System
 * by Daniel Shiffman.  
 * 
 * Particles are generated each cycle through draw(),
 * fall with gravity and fade out over time
 * A ParticleSystem object manages a variable size (ArrayList) 
 * list of particles. 
 */

class BouncingParticles extends Node {

  boolean displayVideo = true; 
  int pace = 2;
  int barrier = 110;
  int nsteps = 1000064;
  int stepThreshold = 900;
  int range = 3;


  ParticleSystem ps;
  int counter = 0;
  int source = 0;
  int numPixels;

  PImage inputImage;
  PImage outputImage;
  PGraphics canvas;

  void setup() {
    canvas = createGraphics(width, height);
    addInputPin("inputImage", new PImagePin(null));
    addOutputPin("outputImage", new PImagePin(null));


    canvas.loadPixels();

    canvas.colorMode(RGB, 255, 255, 255, 100);
    canvas.strokeWeight(50);
    ps = new ParticleSystem(1, new PVector(width/2, height/2, 0));

    canvas.smooth();
  }

  void update() {

    canvas.beginDraw();
    //    canvas.background(0);
    println("bouncing");

    inputImage = getInputPinValue("inputImage");
    if (inputImage!=null) {

      if (numPixels == 0) {
        numPixels = inputImage.width * inputImage.height;
      }

      println("got image");

      for (Particle p : ps.particles) {
        if (abs(sumAbove(p) - sumBelow(p)) > stepThreshold) p.bounceVer();
        if (abs(sumLeft(p) - sumRight(p)) > stepThreshold) p.bounceHor();
      }

      canvas.strokeWeight(1);

      ps.run(canvas);

      if (counter++ % pace == 0) {
        ps.addParticle(mouseX, mouseY);
        println("particle added");
        ////  ps.addParticle(source,0); // Tarama modu
      }


      source += 5;

      if (source >= 799) source = 0;
    }
    canvas.endDraw();

    outputImage = (PImage)canvas;
    updateOutputPinValue("outputImage", outputImage);
  }














  float sumAbove(Particle p) {
    int c = 0;
    for (int x = (int)p.loc.x - range; x < (int)p.loc.x+ range + 1; ++x) {
      for (int y = (int)p.loc.y - range; y < (int)p.loc.y + 1; ++y) {
        c += getColor(x, y);
      }
    }        
    return c;
  }

  float sumBelow(Particle p) {
    int c = 0;
    for (int x = (int)p.loc.x - range; x < (int)p.loc.x+ range + 1; ++x) {
      for (int y = (int)p.loc.y; y < (int)p.loc.y + range + 1; ++y) {
        c += getColor(x, y);
      }
    }        
    return c;
  }

  float sumLeft(Particle p) {
    int c = 0;
    for (int y = (int)p.loc.y - range; y < (int)p.loc.y+ range + 1; ++y) {
      for (int x = (int)p.loc.x - range; x < (int)p.loc.x + 1; ++x) {
        c += getColor(x, y);
      }
    }        
    return c;
  }


  float sumRight(Particle p) {
    int c = 0;
    for (int y = (int)p.loc.y - range; y < (int)p.loc.y+ range + 1; ++y) {
      for (int x = (int)p.loc.x; x < (int)p.loc.x + range + 1; ++x) {
        c += getColor(x, y);
      }
    }        
    return c;
  }


  int getColor(int x, int y) {

    int i = y*inputImage.width+x;

    if (i < 0) return 0;
    if (i >= numPixels) return 0;

    //Need to be able to use merged pixels at some point.
    color currColor = inputImage.pixels[i];

    // Extract the red, green, and blue components from current pixel
    int currR = (currColor >> 16) & 0xFF; // Like red(), but faster
    int currG = (currColor >> 8) & 0xFF;
    int currB = currColor & 0xFF;

    int sum = currR + currG + currB;
    return sum;
  }
}

