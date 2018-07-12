class Mover {
 
  PVector pos;
  PVector vel;
  PVector acc;
  float mass = 1;
 
  Mover() {
    pos = new PVector(width/5., height/2.);
    vel = new PVector();
    acc = new PVector();
  }
  float getAngle(PVector anchor) {
    PVector temp1 = PVector.sub(pos, anchor);
    PVector temp2 = PVector.sub(new PVector(anchor.x, height), anchor);
    float angle = PVector.angleBetween(temp1, temp2);
 
    return angle;
  }
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }
 
  void update() {
    vel.add(acc);
    pos.add(vel);
 
    acc.mult(0);
  }
 
  void render() {
    fill(255);
    ellipse(pos.x, pos.y, 30, 30);
  }
}