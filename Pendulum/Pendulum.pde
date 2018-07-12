Mover bob;
PVector anchor;
float len;
PVector tension;
PVector gravity;
 
void setup() {
  size(640, 380);
  anchor = new PVector(width/2, 0);
  bob = new Mover();
  gravity = new PVector(0, 0.4);
  tension = new PVector(0, 0);
  len = dist(bob.pos.x, bob.pos.y, anchor.x, anchor.y);
}
 
void applyForces() {
  tension = PVector.sub(anchor, bob.pos);
  float str = bob.vel.magSq()/len + gravity.mag()*cos(bob.getAngle(anchor));
  tension.setMag(str);
  bob.applyForce(tension);
  bob.applyForce(gravity);
 
}
 
void draw() {
  //background(50);
  println(dist(bob.pos.x, bob.pos.y, anchor.x, anchor.y));
  applyForces();
  bob.update();
  bob.render();
}