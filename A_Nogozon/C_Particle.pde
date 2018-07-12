


// A simple Particle class

class Particle {
  PVector loc;
  PVector vel;
  PVector acc;
  float r;
  float timer;
  float lifetime;
  int jump = 3;
  float elasticity = 0.8;

  float g = 0.05;

  // Another constructor (the one we are using here)
  Particle(PVector l) {
    g = 0.2;
    acc = new PVector(0, g, 0);

    vel = new PVector(random(-2, 2), random(-2, 2), 0);
    loc = l.get();
    r = 10.0;
    timer = 250.0;
    lifetime  = 10.;
  }

  void run(PGraphics canvas) {
    update();
    render(canvas);
  }

  // Method to update location
  void update() {

    //    if ( jump > 0 && abs(sumAbove() - sumBelow()) > stepThreshold) bounce();


    vel.add(acc);
    loc.add(vel);
    timer -= 1.0;
  }

  void bounceVer() {
    vel.y = -vel.y*elasticity;
    --jump;
  }
  void bounceHor() {
    vel.x = -vel.x;
    --jump;
  }

  // Method to display
  void render(PGraphics canvas) {
    canvas.ellipseMode(CENTER);
    canvas.stroke(255, timer);
 //   canvas.strokeWeight(3);
    canvas.fill(60, timer);
    canvas.ellipse(loc.x, loc.y, r, r);



    //    displayVector(vel,loc.x,loc.y,10);
  }

  // Is the particle still useful?
  boolean dead() {
    if (timer <= 0) {
      return true;
    } else {
      return false;
    }
  }




  void displayVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    float arrowsize = 4;
    // Translate to location to render vector
    translate(x, y);
    stroke(255);
    // Call vector heading function to get direction (note that pointing up is a heading of 0) and rotate
    rotate(v.heading2D());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    line(0, 0, len, 0);
    line(len, 0, len-arrowsize, +arrowsize/2);
    line(len, 0, len-arrowsize, -arrowsize/2);
    popMatrix();
  }
}

