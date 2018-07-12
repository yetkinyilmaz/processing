abstract class LayerNode extends Node {
  protected int w, h;
  protected PGraphics pg;

  LayerNode(int w, int h) {
    this.w = w;
    this.h = h;
    addOutputPin("texture", new PGraphicsPin(pg));
  }

  void setup() {
    pg = createGraphics(w, h);
  }

  public void update() {
    pg.beginDraw();
    render(pg);
    pg.endDraw();

    updateOutputPinValue("texture", pg);
  }

  abstract public void render(PGraphics pg) ;
}

class LayerRect extends LayerNode {
  public LayerRect(int w, int h) {
    super(w, h);
    addInputPin("x-pos", new FloatPin(-10, 10, 0));
  }

  public void render(PGraphics pg) {
    pg.translate(w/2, h/2);
    pg.fill(0);
    float xPos = getInputPinValue("x-pos");
    pg.rect(xPos, 0, 10, 10);
  }
}

class LayerSphere extends LayerNode {
  public LayerSphere(int w, int h) {
    super(w, h);
  }

  public void render(PGraphics pg) {
    pg.translate(w/4, h/2);
    pg.fill(0);
    pg.ellipse(0, 0, 10, 10);
  }
}
