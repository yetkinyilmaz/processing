// A simple Particle class

class Particle {
  PVector loc;
  PVector vel;
  PVector acc;
  float r;
  float timer;
  
  // Another constructor (the one we are using here)
  Particle(PVector l, float time) {
    acc = new PVector(0,0,0);
    vel = new PVector(0,-2.5,0);
    loc = l.get();
    r = 6.0;
    timer = time;
  }

  void run() {
    update();
    render();
  }

  // Method to update location
  void update() {

r = r + 0.4;
    vel.add(acc);
if(timer < 200 && random(0,1) > 0.00095){ 
  vel.x = random(-1.5,1.5);
}
    loc.add(vel);
    timer -= 2.0;
  }

  // Method to display
  void render() {
    ellipseMode(CENTER);
    stroke(255,timer);
    fill(0,140,180,timer);
    ellipse(loc.x,loc.y,r,r);
if(timer > 50){
    ellipseMode(CENTER);
    fill(200,220,220,100);
    ellipse(loc.x+(r/5),loc.y-(r/4),5,4);
}

  }
  
  // Is the particle still useful?
  boolean dead() {
    if (timer <= 0.) {
      return true;
    } else {
      return false;
    }
  }
  
   void displayVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    float arrowsize = 4;
    // Translate to location to render vector
    translate(x,y);
    stroke(255);
    // Call vector heading function to get direction (note that pointing up is a heading of 0) and rotate
    rotate(v.heading2D());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    line(0,0,len,0);
    line(len,0,len-arrowsize,+arrowsize/2);
    line(len,0,len-arrowsize,-arrowsize/2);
    popMatrix();
  } 

}

