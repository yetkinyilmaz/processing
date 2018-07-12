class FloatPin extends Pin<Float> {
  public FloatPin(float min, float max, float value) {
    super(value);
    this.min = min;
    this.max = max;
  }

  public void setMin(float min) {
    this.min = min;
  }

  public void setMax(float max) {
    this.max = max;
  }

  public float min() {
    return this.min;
  }

  public float max() {
    return this.max;
  }

  private float min;
  private float max;
}

class PImagePin extends Pin<PImage> {
  public PImagePin(PImage value) {
    super(value);
  }
}

class PGraphicsPin extends Pin<PGraphics> {
  public PGraphicsPin(PGraphics value) {
    super(value);
  }
}
class MapProcess implements Process {
  public void execute(Pin in, Pin out) {
    FloatPin src = (FloatPin) in;
    FloatPin dst = (FloatPin) out;
    dst.setRawValue(src.value());
    dst.setValue(map(src.value(), src.min, src.max, dst.min, dst.max));
  }
}

class NoOpProcess implements Process {
  public void execute(Pin in, Pin out) {
    out.setValue(in.value());
    out.setRawValue(in.rawValue());
  }
}

class FloatMessage extends Message {
  public FloatMessage(String name, float min, float max, float value) {
    super(name);
    this.value = value;
    this.min = min;
    this.max = max;
  }

  public float min() {
    return min;
  }

  public float max() {
    return max;
  }

  public float value() {
    return value;
  }
  
  private float min;
  private float max;
  private float value;
}

