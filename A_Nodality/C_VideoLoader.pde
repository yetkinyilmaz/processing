import processing.video.*;

class VideoLoader extends Node {
  VideoLoader(PApplet applet) {

    //     video = new Capture(applet, width, height);
    video = new Capture(applet, 320, 240);

    addOutputPin("loadedImage", new PImagePin(null));
  }

  PImage img;
  PImage lastFrame;
  Capture video;
  boolean live = false;

  void setup() {    
    if (live) video.start();
    else {
 //    img = loadImage("hat.png");
//      img = loadImage("blank_europe_map.gif");
//      img = loadImage("Lenna.png");
 //     img = loadImage("hand.jpeg");
  img = loadImage("AgacMap02_test01.png");
      img.resize(width,0);
    }
  }



  void update() {
    if (video.available()) {
      video.read();
      video.loadPixels();
      img = video;
    }
    if (img != null) {
      updateOutputPinValue("loadedImage", img);
      lastFrame = img;
    } else if (lastFrame != null) {
      updateOutputPinValue("loadedImage", lastFrame);
    }
  }
}

