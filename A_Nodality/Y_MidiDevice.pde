import themidibus.*;

class MidiDevice extends Node {
  MidiDevice(PApplet p5, int inputDevIdx, int outputDevIdx) {
    MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
    m_bus = new MidiBus(p5, inputDevIdx, outputDevIdx);
  }

  public void processMessage(Message m) {
    if (m.name.startsWith("cc")) {
      FloatMessage msg = (FloatMessage)m;
      if (!outputPinExists(msg.name())) {
        addOutputPin(msg.name(), new FloatPin(msg.min(), msg.max(), msg.value()));
      } else {
        updateOutputPinValue(msg.name(), msg.value());
      }
    }
  }

  void setup() {
  }

  void update() {
  }

  private MidiBus m_bus; // The MidiBus
}

void controllerChange(int channel, int number, int value) {
  Message msg = new FloatMessage("cc"+number, 0.0, 127.0, value);
  app.sendMessage(msg);
}
