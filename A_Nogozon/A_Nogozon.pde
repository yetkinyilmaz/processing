import codeanticode.syphon.*;

Application app;
SyphonServer syphon;


void setup() {
//  size(640, 480, P3D);
  size(1280, 960, P3D);

  syphon = new SyphonServer(this, "#Yetkin");

  app = new Application();

  Node capture = new VideoLoader(this);
  Node bill1 = new Billboard();
  Node bill2 = new Billboard();

//  Node diff = new FrameDifference();
//  Node track = new Tracking();
//  Node ascii = new Ascii();

  Node bounce = new BouncingParticles();

  Node mc = new MasterClass();

  Node cp5Dev = new CP5Device(this);
  Node midiDev = new MidiDevice(this, 0, 1);
  Node oscDevice = new OscDevice(this);
  Node signalDevice = new SignalDevice();

  //  app.add(mc);



  app.add(capture);
  //  app.add(diff);
  //  app.add(track);

  app.add(bounce);


//  app.add(bill1);
  app.add(bill2);

  //  app.add(ascii);

  //  app.add(cp5Dev);
  //  app.add(midiDev);

  //  app.add(oscDevice);
  //  app.add(signalDevice);

  app.setup();


  // //mapping must be done after setup
  app.defaultProcess = new MapProcess();
  app.plug(cp5Dev, signalDevice, "amplitude", "amplitude");
  app.plug(cp5Dev, signalDevice, "frequency", "frequency");
  app.plug(cp5Dev, signalDevice, "offset", "offset");
  //  app.plug(signalDevice, demo1, "sin_value", "x-offset");

  app.plug(cp5Dev, mc, "alphaSlider", "lineAlpha");
  //  app.plug(midiDev, mc, "cc1", "lineAlpha");
  //app.plug(oscDevice, mc, "/o1", "lineAlpha");

  app.plug(midiDev, oscDevice, "cc10", "osc_value");

  // app.plug(capture, bill, "loadedImage", "finalImage", new NoOpProcess());

  //app.plug(capture, diff, "loadedImage", "inputImage", new NoOpProcess());
  //app.plug(diff, track, "outputImage", "inputImage", new NoOpProcess());
  //app.plug(diff, bill, "outputImage", "finalImage", new NoOpProcess());


  if (true) {
    app.plug(capture, bill1, "loadedImage", "finalImage", new NoOpProcess());
    app.plug(capture, bounce, "loadedImage", "inputImage", new NoOpProcess());
    app.plug(bounce, bill2, "outputImage", "finalImage", new NoOpProcess());
  }

/*
  if (false) {
    app.plug(capture, diff, "loadedImage", "inputImage", new NoOpProcess());
    app.plug(diff, bill, "outputImage", "finalImage", new NoOpProcess());
  }

  if (false) {
    app.plug(capture, ascii, "loadedImage", "inputImage", new NoOpProcess());
    app.plug(ascii, bill, "outputImage", "finalImage", new NoOpProcess());
  }

  if (false) {
    app.plug(capture, diff, "loadedImage", "inputImage", new NoOpProcess());
    app.plug(diff, ascii, "outputImage", "inputImage", new NoOpProcess());
    app.plug(diff, bill, "outputImage", "finalImage", new NoOpProcess());
  }
*/

  //  app.plug(demo2, demo1, "loaded_image", "texture", new NoOpProcess());

  hint(DISABLE_DEPTH_TEST);
  //  smooth();
}

void draw() {
  background(0);
  app.update();
  syphon.sendScreen();
}

void stop() {
  println("closing");
  syphon.stop();
}

