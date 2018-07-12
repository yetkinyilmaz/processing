import controlP5.*;
import java.util.List;
class CP5Device  extends Node implements ControlListener {
  public CP5Device(PApplet p5) {
    cp5 = new ControlP5(p5);
    cp5.addListener(this);
  }

  public void processMessage(Message msg) {
  }
  
  public void createSlider(String name) {

    cp5.addSlider(name)
      .setPosition(0, height-10)
        .setRange(0, 255).setColorBackground(color(255));
    ;
    addOutputPin(name, new FloatPin(0, 255, 0));
  }

  public void setup() {
    // add a horizontal sliders, the value of this slider will be linked
    // to variable 'sliderValue' 

   createSlider("alphaSlider");
   
   
    /*
    cp5.addSlider("amplitude")
     .setPosition(0, height-10)
     .setRange(0, 255).setColorBackground(color(255));
     ;
     addOutputPin("amplitude", new FloatPin(0, 255, 0));
     
     cp5.addSlider("frequency")
     .setPosition(150, height -10)
     .setRange(0, 255).setColorBackground(color(255));
     ;
     addOutputPin("frequency", new FloatPin(0, 255, 0));
     
     cp5.addSlider("offset")
     .setPosition(300, height-10)
     .setRange(-100, 100).setColorBackground(color(255));
     ;
     addOutputPin("offset",new FloatPin( -100, 100, 0));
     */

    //    hideGui();
  }

  public void update() {
  }

  public void controlEvent(ControlEvent theEvent) {
    String name = theEvent.getController().getName();
    float min = theEvent.getController().getMin();
    float max = theEvent.getController().getMax();
    float value = theEvent.getController().getValue();

    updateOutputPinValue(name, value);
  }

  public void keyPressed() {
    if (key=='g') {
      visible = !visible;
      hideGui();
    }
  }

  private void hideGui() {
    for (Slider c : cp5.getAll (Slider.class)) {
      c.setVisible(visible);
    }
  }

  private ControlP5 cp5;
  private boolean visible = false;
}

