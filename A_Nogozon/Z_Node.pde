import java.util.Iterator;

abstract class Node extends ObservableObject implements ObserverObject {  
  Node() {
    channels = new ArrayList<Channel>();
    properties = new ArrayList<Property>();
  }

  public abstract void setup();
  public abstract void update();
  public void processMessage(Message msg) {
  }
  public void objectUpdated(ObservableObject obs, Object arg) {
  }

  public Pin getOutputPin(String chName) {
    for (Channel ch : channels) {
      if (ch.name.equals(chName)) {
        return ch.value;
      }
    }
    return null;
  }

  public Channel getChannelByName(String chName) {
    for (Channel ch : channels) {
      if (ch.name.equals(chName)) {
        return ch;
      }
    }
    return null;
  }

  public boolean outputPinExists(String chName) {
    for (Channel ch : channels) {
      if (ch.name.equals(chName)) {
        return true;
      }
    }
    return false;
  }

  public void addOutputPin(String name, Pin v) {
    channels.add(new Channel(name, v));
  }

  public <T> void updateOutputPinValue(String chName, T val) {
    for (Channel ch : channels) {
      if (ch.name.equals(chName)) {
        ch.value.setValue(val);
        notifyObjectChanged(chName);
        return;
      }
    }
  }

  protected Pin getInputPin(String name) {
    for (Property p : properties) {
      if (p.name.equals(name)) {
        return p.value;
      }
    }
    return null;
  }

  protected <T> T getInputPinValue(String name) {
    for (Property p : properties) {
      if (p.name.equals(name)) {
        return (T)p.value.value();
      }
    }
    println("error: the input "+name+" does not exist");

    return null;
  }

  protected <T> T getInputPinRawValue(String name) {
    for (Property p : properties) {
      if (p.name.equals(name)) {
        return (T)p.value.rawValue();
      }
    }
    println("error: the input "+name+" does not exist");

    return null;
  }

  Property getInputChannel(String name) {
    for (Property p : properties) {
      if (p.name.equals(name)) {
        return p;
      }
    }
    return null;
  }

  void addInputPin(String name, Pin val) {
    Property prop = new Property();
    prop.name = name;
    prop.value = val;
    if (!properties.contains(prop)) {
      properties.add(prop);
      prop.plug(this);
    } else {
      println("property: "+prop.name+ " allready exists in this player");
    }
  }

  //some Processing event
  void mousePressed() {
  }
  void mouseClicked() {
  }
  void mouseDragged() {
  }
  void mouseReleased() {
  }
  void keyPressed() {
  }

  void keyReleased() {
  }

  void mouseMoved() {
  }

  void mouseWheel(MouseEvent event) {
  }

  private ArrayList<Property> properties;
  private boolean playing = true;
  private ArrayList<Channel> channels;
};

class Channel {
  public Channel(String name, Pin v) {
    this.name = name;
    this.value = v;
  }
  public String name;
  public Pin value;
}

class Message {
  public Message(String name) {
    this.name = name;
  }
  
  public String name(){
    return name;
  }
  
  private String name;
}

class Pin<T> {
  Pin(T value) {
    this.value = value;
  }

  public T value() {
    return this.value;
  }
  
  public T rawValue() {
    return this.rawValue;
  }

  public void setValue(T newVal) {
    this.value = newVal;
  }

  public void setRawValue(T newVal) {
    this.rawValue = newVal;
  }


  private T value;
  public T rawValue;
}

class Property extends ObservableObject {
  String name;
  Pin value;
}
