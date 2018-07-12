
/**
 * Frame Differencing 
 * by Golan Levin. 
 *
 * Quantify the amount of movement in the video frame using frame-differencing.
 */

class FrameDifference extends Node {

  int numPixels;
  int[] previousFrame;
  PImage imgIn;
  PImage imgOut;

  void setup() {
    addInputPin("inputImage", new PImagePin(null));
    addOutputPin("outputImage", new PImagePin(null));

    numPixels = 0;
  }

  void update() {
    imgIn = getInputPinValue("inputImage");
    if (imgIn != null) {
      imgOut = imgIn;

      if (numPixels == 0) {
        numPixels = imgIn.width*imgIn.height;
        previousFrame = new int[numPixels];
      }

      int movementSum = 0; // Amount of movement in the frame
      for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
        color currColor = imgIn.pixels[i];
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
        // Add these differences to the running tally
        movementSum += diffR + diffG + diffB;
        // Render the difference image to the screen
        imgOut.pixels[i] = color(diffR, diffG, diffB);
        // The following line is much faster, but more confusing to read
        //pixels[i] = 0xff000000 | (diffR << 16) | (diffG << 8) | diffB;
        // Save the current color into the 'previous' buffer
        previousFrame[i] = currColor;
      }

      // To prevent flicker from frames that are all black (no movement),
      // only update the screen if the image has changed.
      if (movementSum > 0) {
        println(movementSum); // Print the total amount of movement to the console
      }
    }

    updateOutputPinValue("outputImage", imgOut);
  }
}

