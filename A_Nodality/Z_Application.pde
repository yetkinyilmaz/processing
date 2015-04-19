import java.util.ArrayDeque;

class Application {
  public Application() {
    nodeManager = new NodeManager();
    messageQueue = new ArrayDeque<Message>();
    mappingTable = new MappingTable();
  }

  public void add(Node dev) {
    nodeManager.add(dev);
  }

  public void setup() {
    nodeManager.setup();
  }

  public void update() {
    for (Message m : messageQueue) {
      nodeManager.sendMessage(m);
    }
    nodeManager.update();
    messageQueue.clear();
  }

  void plug(Node out, Node in, String chName, String propName) {
    plug(out, in, chName, propName, defaultProcess);
  }
  void plug(Node out, Node in, String chName, String propName, Process proc) {
    Property prop =in.getInputChannel(propName);
    if (prop != null) {
      mappingTable.add(out, prop, chName, proc);
    } else {
      println("error you cannot plug "+chName+" and " + propName+" together");
    }
  }

  public void sendMessage(Message msg) {
    messageQueue.add(msg);
  }

  //processing event forwarding
  //some Processing event
  void mousePressed() {
    for (Node n : nodeManager) {
      n.mousePressed();
    }
  }
  void mouseClicked() {
    for (Node n : nodeManager) {
      n.mouseClicked();
    }
  }
  void mouseDragged() {
    for (Node n : nodeManager) {
      n.mouseDragged();
    }
  }
  void mouseReleased() {
    for (Node n : nodeManager) {
      n.mouseReleased();
    }
  }
  void keyPressed() {
    for (Node n : nodeManager) {
      n.keyPressed();
    }
  }

  void keyReleased() {
    for (Node n : nodeManager) {
      n.keyReleased();
    }
  }

  void mouseMoved() {
    for (Node n : nodeManager) {
      n.mouseMoved();
    }
  }
  void mouseWheel(MouseEvent event) {
    for (Node n : nodeManager) {
      n.mouseWheel(event);
    }
  }
  private NodeManager nodeManager;
  private ArrayDeque<Message> messageQueue;
  private MappingTable mappingTable;
  private Process defaultProcess;
}

//processing event forwarding
//some Processing event
void mousePressed() {
  app.mousePressed();
}
void mouseClicked() {
  app.mouseClicked();
}
void mouseDragged() {
  app.mouseDragged();
}
void mouseReleased() {
  app.mouseReleased();
}
void keyPressed() {
  app.keyPressed();
}

void keyReleased() {
  app.keyReleased();
}

void mouseMoved() {
  app.mouseMoved();
}

void mouseWheel(MouseEvent event) {
  app.mouseWheel(event);
}

