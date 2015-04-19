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

  void setup() {    
    video.start();
    //    img = loadImage("Lenna.png");
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

