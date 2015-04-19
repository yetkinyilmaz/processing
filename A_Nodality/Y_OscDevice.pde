import oscP5.*;
import netP5.*;

class OscDevice extends Node {  
  public OscDevice(PApplet p5) {
    m_oscP5 = new OscP5(p5, 8000);
    m_remoteLocation = new NetAddress("127.0.0.1", 8300);
  }

  public  void setup() {
    addInputPin("osc_value", new FloatPin(0, 1, 0));
  }

  public void processMessage(Message msg) {
    if (msg.name.startsWith("/")) {
      FloatMessage m = (FloatMessage)msg;
      if (!outputPinExists(m.name())) {
        addOutputPin(m.name(), new FloatPin(m.min(), m.max(), m.value()));
      } else {
        updateOutputPinValue(m.name(), m.value());
      }
    }
  }

  public void update() {
  }

  private NetAddress m_remoteLocation;

  private OscP5 m_oscP5;

  public void objectUpdated(ObservableObject obs, Object arg) {
    if (arg.equals("osc_value")) {
      String adress = "/"+"test"+"?min="+0+"&"+"max="+1; 
      OscMessage myMessage = new OscMessage(adress);
      float v = getInputPinValue("osc_value");
      myMessage.add(v); 
      m_oscP5.send(myMessage, m_remoteLocation);
    }
  }
}   

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  float value = theOscMessage.get(0).floatValue();
  Message msg = new FloatMessage(theOscMessage.addrPattern(), 0.0, 1.0, value);
  app.sendMessage(msg);
}

