// A simple Particle class

class PixelSeed {
 
int x;
int y;
int i;
int diff;
  int time;
  
  PixelSeed(int in, int diff, int t){
    i = in;
    x = i % width;
    y = (i-x)/width; 
time = t;
//i = iy*width+ix;
  }


int sumColorDiff(){

  int sum = 0;

    for(int iy = y - seedRange; iy < y + seedRange+1 && iy < height; ++iy){
      if(iy < 0) continue;
      for(int ix = x - seedRange; ix < x + seedRange+1 && ix < width; ++ix){
      if(ix < 0) continue;
        
      int ic = iy*width+ix;
      
      if(ic > width * height) continue;
      if(ic < 0 ) continue;



      sum += getColorDiff(ic); 
      }
    }


       println("yes"+sum);

diff = sum;
return sum;

}  
  
}


class PixelCluster {
  PVector loc;
  PVector vel;
  PVector acc;
  int i;
  float r;
  float timer;
  ArrayList seeds;
  // Another constructor (the one we are using here)

PixelCluster(){
      acc = new PVector(0,0,0);
    vel = new PVector(0,0,0);
    loc = new PVector(0,0,0);

    r = 5.0;
    timer = 10;
seeds = new ArrayList();
}


  PixelCluster(PVector l, float time) {
    acc = new PVector(0,0.7,0);
    vel = new PVector(0,0,0);
    loc = l.get();
    r = 5.0;
    timer = time;
seeds = new ArrayList();
  }

void seed(PixelSeed sd){
seeds.add(sd);  
i = sd.i;
loc.x = sd.x;
loc.y = sd.y;

}


float momentum(){ 

        vel.set(0,0,0);
  
  for(int is = 0; is < seeds.size(); ++is){
        PixelSeed sd = (PixelSeed) seeds.get(is);  
      vel.set(vel.x + sd.x, vel.y + sd.y,0);
    }  

return vel.mag();

}

  void run() {
    update();
    render();
  }

  // Method to update location
  void update() {
    vel.add(acc);
    loc.add(vel);
    timer -= 2.0;
  }

  // Method to display
  void render() {
    ellipseMode(CENTER);
    stroke(255,timer);
    fill(200,timer);
    ellipse(loc.x,loc.y,r,r);
//      displayVector(vel,loc.x,loc.y,10);
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

int getColorDiff(int i){
  
     //Need to be able to use merged pixels at some point.
      color currColor = video.pixels[i];
      color prevColor = previousFrame[i];

      // Extract the red, green, and blue components from current pixel
      int currR = (currColor >> 16) & 0xFF; // Like red(), but faster
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract red, green, and blue components from previous pixel
      int prevR = (prevColor >> 16) & 0xFF;
      int prevG = (prevColor >> 8) & 0xFF;
      int prevB = prevColor & 0xFF;
      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - prevR);
      int diffG = abs(currG - prevG);
      int diffB = abs(currB - prevB); 
  
  int sum = diffR + diffG + diffB;
  return sum;
  
}





