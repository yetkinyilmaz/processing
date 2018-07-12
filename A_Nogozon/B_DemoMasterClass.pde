class MasterClass extends Node {
  MasterClass() {
    addInputPin("lineAlpha", new FloatPin(0, 255, 0));
  }
  void setup() {
  }

  float alpha;
  void update() {

    stroke(255, alpha);
    line(0, 0, width, height);
  }
  
@Override
  public void objectUpdated(ObservableObject obs, Object arg) {
    String pinName = (String) arg; 
    if (pinName.equals("lineAlpha")) {
      alpha = getInputPinValue(pinName);
    }
  }
}


