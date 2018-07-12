/**
 * ASCII Video
 * by Ben Fry. 
 *
 * 
 * Text characters have been used to represent images since the earliest computers.
 * This sketch is a simple homage that re-interprets live video as ASCII text.
 * See the keyPressed function for more options, like changing the font size.
 */

// All ASCII characters, sorted according to their visual density


String letterOrder =
" .`-_':,;^=+/\"|)\\<>)iv%xclrs{*}I?!][1taeo7zjLu" +
"nT#JCwfy325Fp6mqSghVd4EgXPGZbYkOA&8U$@KHDBWNMR0Q";


//String letterOrder =
//"------------------------------------------------" +
//"YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY";
//"000000000000000000000000000000000000000000000000";

char[] letters;

float[] bright;
char[] chars;

PFont font;
float fontSize = 1.2;


class Ascii extends Node {

  PImage video;
  PGraphics pg;

  int count;
  boolean fluentMode;

  void setup() {
    fluentMode = true;
    pg = createGraphics(320, 240);
    addInputPin("inputImage", new PImagePin(null));
    addOutputPin("outputImage", new PImagePin(null));

      count = 0;
    //println(count);

    font = loadFont("UniversLTStd-Light-48.vlw");

    // for the 256 levels of brightness, distribute the letters across
    // the an array of 256 elements to use for the lookup
    letters = new char[256];
    for (int i = 0; i < 256; i++) {
      int index = int(map(i, 0, 256, 0, letterOrder.length()));
      letters[i] = letterOrder.charAt(index);
    }
  }




  void update() {
    pg.beginDraw();
    if (!fluentMode) pg.background(0);

    //   imgOut = imgIn;
    video = getInputPinValue("inputImage");

    if (video != null) {
//      println("running");
      if (count == 0) {
        count = video.width * video.height;
        // current characters for each position in the video
        chars = new char[count];

        // current brightness for each point
        bright = new float[count];
        for (int i = 0; i < count; i++) {
          // set each brightness at the midpoint to start
          bright[i] = 128;
        }
      }  


      pg.pushMatrix();

      float hgap = pg.width / float(video.width);
      float vgap = pg.height / float(video.height);

      pg.scale(max(hgap, vgap) * fontSize);
      pg.textFont(font, fontSize);

      int index = 0;
      for (int y = 1; y < video.height; y++) {

        // Move down for next line
        pg.translate(0, 1.0 / fontSize);

        pg.pushMatrix();
        for (int x = 0; x < video.width; x++) {
          int pixelColor = video.pixels[index];
          // Faster method of calculating r, g, b than red(), green(), blue() 
          int r = (pixelColor >> 16) & 0xff;
          int g = (pixelColor >> 8) & 0xff;
          int b = pixelColor & 0xff;

          // Another option would be to properly calculate brightness as luminance:
          // luminance = 0.3*red + 0.59*green + 0.11*blue
          // Or you could instead red + green + blue, and make the the values[] array
          // 256*3 elements long instead of just 256.
          int pixelBright = max(r, g, b);

          // The 0.1 value is used to damp the changes so that letters flicker less
          float diff = pixelBright - bright[index];
          bright[index] += diff * 0.1;

          pg.fill(pixelColor);
          int num = int(bright[index]);
          pg.text(letters[num], 0, 0);

          // Move to the next pixel
          index++;

          // Move over for next character
          pg.translate(1.0 / fontSize, 0);
        }
        pg.popMatrix();
      }
      pg.popMatrix();

//println("something");

      pg.endDraw();
      PImage imgOut = (PImage)pg;
      updateOutputPinValue("outputImage", imgOut);
    }
  }
}

