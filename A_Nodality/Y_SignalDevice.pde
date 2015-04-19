class SignalDevice extends Node {
  void setup() {
    addOutputPin("sin_value", new FloatPin(0, 1, 0));
    addInputPin("frequency", new FloatPin( 0, 1, 0.01));
    addInputPin("amplitude", new FloatPin(0, 200, 1));
    addInputPin("offset", new FloatPin(0, 20, 1));
  }

  void update() {
    float t = ((float)millis())/1000.0f;

    Pin v = getOutputPin("sin_value");
    FloatPin vF = (FloatPin) v;
    vF.setMin(0.0f);
    vF.setMax(amplitude);
    updateOutputPinValue("sin_value", amplitude*sin(2*PI * t * frequ + offset));

    if (showGraph) {
      stroke(255);
      translate(50, height-100, 0);
      float rate = 1;
      float xP = 0;
      float yP = 0;
      float amp = map(amplitude, 0, 200, 0, 50);
      for (float i = 0; i < width/2; i+=rate) {
        float x = i;
        float y = amp *sin(i*2*PI*frequ + offset);
        line(xP, yP, x, y);
        xP = x;
        yP = y;
      }
    }
  }

  private float frequ;
  private float offset;
  private float amplitude;
  private boolean showGraph = false;

  public void objectUpdated(ObservableObject obs, Object arg) {
    String propName = (String) arg;
    if (arg.equals("frequency")) {
      frequ = getInputPinValue(propName);
    }  
    if (arg.equals("amplitude")) {
      amplitude = getInputPinValue(propName);
    }
    if (arg.equals("offset")) {
      offset = getInputPinValue(propName);
    }
  }

  public void keyPressed() {
    if (key == 's') {
      showGraph = !showGraph;
    }
  }
}

