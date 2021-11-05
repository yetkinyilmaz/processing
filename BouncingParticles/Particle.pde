


// A simple Particle class

class Particle {
  PVector loc;
  PVector vel;
  PVector acc;
  float r;
  float timer;
  float lifetime;
int jump;

  // Another constructor (the one we are using here)
  Particle(PVector l) {
    acc = new PVector(0,acceleration,0);
    vel = new PVector(random(-2,2),random(-4,0),0);
    loc = l.get();
    r = 10.0;
    timer = 250.0;
lifetime  = 10.;

jump = nsteps;

  }

  void run() {
    update();
    render();
  }

  // Method to update location
  void update() {

     if( jump > 0 && abs(sumAbove() - sumBelow()) > stepThreshold) bounce();

//    if(jump && loc.y > height-barrier){
//       bounce();
//    }


    vel.add(acc);
    loc.add(vel);
    timer -= 1.0;
  }

void bounce(){
 vel.y = -vel.y*elasticity;
--jump;
}


  // Method to display
  void render() {
    ellipseMode(CENTER);
    stroke(255,timer);
    fill(100,timer);

    ellipse(loc.x,loc.y,r,r);
    

    
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
  
  
  float sumAbove(){
    
   int c = 0;
    
    for(int x = (int)loc.x - range; x < (int)loc.x+ range + 1; ++x){
//            if(x > video.width) continue;
          for(int y = (int)loc.y - range; y < (int)loc.y + 1; ++y){
//                  if(y > video.height) continue;
            c += getColor(x,y);
          }
    }        

return c;
  }
  
  
  float sumBelow(){
       int c = 0;
    
    for(int x = (int)loc.x - range; x < (int)loc.x+ range + 1; ++x){

 //     if(x > video.width) continue;
      for(int y = (int)loc.y; y < (int)loc.y + range + 1; ++y){
//      if(y > video.height) continue;
        c += getColor(x,y);


          }
    }        

return c;
    
  }
  
  int getColor(int x, int y){

    int i = y*width+x;
    
    if(i < 0) return 0;
    if(i >= numPixels) return 0;
    
         //Need to be able to use merged pixels at some point.
      color currColor = video.pixels[i];

      // Extract the red, green, and blue components from current pixel
      int currR = (currColor >> 16) & 0xFF; // Like red(), but faster
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
 
  int sum = currR + currG + currB;
  return sum;
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

