/* 
 * Blobscanner v. 0.2-a  
 * by Antonio Molinaro (c) 20/07/2013.
 * Draws the blob's bounding box.
 *
 */
import blobscanner.*;

Detector bd;

PImage img0 = loadImage("sim_all_event_76.png");
PImage img = new PImage(img0.width,img0.height);
img.copy(img0,0,0,img.width,img.height,0,0,img.width,img.height);

size(img.width, img.height);

//img.filter(DILATE);
//img.filter(ERODE);
//img.filter(BLUR,2);

img.filter(THRESHOLD,0.2);
//img.blend(img0,0,0,img.width,img.height,0,0,img.width,img.height, MULTIPLY);

bd = new Detector( this, 255 );

image(img, 0, 0);

color boundingBoxCol = color(255, 0, 0);
int boundingBoxThickness = 1;

img.loadPixels();

bd.findBlobs(img.pixels, img.width, img.height);

// to be called always before using a method 
// returning or processing a blob's feature
bd.loadBlobsFeatures(); 
image(img0,0,0);

bd.drawBox(boundingBoxCol, boundingBoxThickness);

println(bd.version());
 

 
