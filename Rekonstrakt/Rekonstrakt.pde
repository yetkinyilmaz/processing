
PImage img;
PImage imgGray;
PImage imgColor;

int iy = 0;
int yRange = 5;
int searchRange = 600;
String filename = "serna_111.jpg";

int[] offsets;
color[] shiftedPix;

void setup() {
img = loadImage(filename);
int res = 1;
int w = img.width/res;
int h = img.height/res;
img.resize(w,h);
size(img.width,img.height);

imgColor = img;
imgGray = img;

 //imgGray.filter(GRAY);

 loadPixels();
 offsets = new int[height];
shiftedPix = new color[width*height];
}

void draw() {


  if(iy <= yRange){
   for(int ix = 0; ix < width; ++ix){
    int ip = iy*width + ix;
    pixels[ip] = img.pixels[ip];
   }
  }else if(iy < height-1){
    int i = 0;
    double minDiff = 1400000000.;
    int optimx = offsets[iy - 1];
    for(int offset = -searchRange; offset < searchRange; ++offset){
   
      double d = slitDiff(imgGray,iy,offset);
      if(d < minDiff){
          minDiff = d;
          optimx = offset;   
      }
    }
    offsets[iy] = optimx;
    //print the optimum shift for this line
 //   println(iy+"   "+optimx);

   for(int ix = 0; ix < width; ++ix){
    int ip = iy*width + ix;
    int ip2 = iy*width + (ix + optimx);
    pixels[ip] = img.pixels[ip2];
    shiftedPix[ip] = imgGray.pixels[ip2];
   }
  }

  updatePixels();
  ++iy;

  if(iy == height){
   save("reconstructed_"+filename); 
  }

}

int slitDiff(PImage imag, int iy, int offset){

  int diff = 0;
  int margin = 60;

  for(int offy = 1; offy < yRange; ++offy){
   for(int ix = 0; ix < width; ++ix){

     color col0 = shiftedPix[(iy-offy)*width+((ix) % width)];
     color col1 = imag.pixels[(iy)*width+((ix+offset) % width)];

  //   diff += colorDiff(col0,col1);
   // diff += colorDiff(col0,col1)/Math.sqrt(offy);
   diff += colorDiff(col0,col1)/offy;
  //  diff += colorDiff(col0,col1)/(offy*offy);

   }
 }
return diff;  
}


double colorDiff(color c1, color c2){

    int currR1 = (c1 >> 16) & 0xFF;
    int currG1 = (c1 >> 8) & 0xFF;
    int currB1 = c1 & 0xFF;

    int currR2 = (c2 >> 16) & 0xFF;
    int currG2 = (c2 >> 8) & 0xFF;
    int currB2 = c2 & 0xFF;
    
    double diffR = (currR1 - currR2);
    double diffG = (currG1 - currG2);
    double diffB = (currB1 - currB2); 

    double sum = diffR*diffR + diffG*diffG + diffB*diffB;
    return sum;
}

