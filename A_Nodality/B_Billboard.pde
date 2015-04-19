import processing.video.*;

class Billboard extends Node {
  Billboard() {
    addInputPin("finalImage", new PImagePin(null));
  }

  PImage img;
  PImage lastFrame;

  void setup() {
  }

  void update() {
    img = getInputPinValue("finalImage");
//    if (img == null && lastFrame != null) {
//      img = lastFrame;
//    }
    if (img!=null) {
      image(img, 0, 0, width, height);
//      image(img, 0, 0);

    }
  }
}

