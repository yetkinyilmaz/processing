class MixerNode extends Node {

  MixerNode() {
    layers = new ArrayList<LayerNode>();
  }

  void setup() {
  }

  void addLayer(LayerNode layer) {
    addInputPin("layer"+layers.size(), new PGraphicsPin(null));
    app.plug(layer, this, "texture", "layer"+layers.size(), new NoOpProcess());

    layers.add(layer);
  }

  void update() {
    background(0,255,0);
    translate(width/2, height/2);
    for (int i = 0; i < layers.size (); i++) {
      PGraphics layer = getInputPinValue("layer"+i);
      if (layer != null) {
        image(layer, 0, 0);
      }
    }
  }

  ArrayList<LayerNode> layers;
}
