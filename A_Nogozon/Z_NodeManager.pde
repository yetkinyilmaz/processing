class NodeManager implements Iterable<Node> {
  public NodeManager() {
    nodes = new ArrayList<Node>();
  }

  public void setup() {
    for (Node dev : nodes) {
      dev.setup();
    }
  }

  public void update() {
    for (Node dev : nodes) {
      pushMatrix();
      pushStyle();
      dev.update();
      popStyle();
      popMatrix();
    }
  }

  public void add(Node dev) {
    nodes.add(dev);
  }

  public void sendMessage(Message msg) {
    for (Node p : nodes) {
      p.processMessage(msg);
    }
  }

  public Iterator<Node> iterator() {
    return nodes.iterator();
  }
  private ArrayList<Node> nodes;
}
