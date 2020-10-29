
PFont f;
PFont f_glitch;

String fulltext1[] = {
"L'heure est grave !                          ",
"Le président et son gouvernement ont activé   ", 
"la phase 46 du plan de sécurité.           ",
"Voici les premières directives :               ",
"Les écoles seront fermées pendant plus d’une   ", 
"dizaine de jours. Sauf reconduction.                    ",
"Un couvre-feu est effectif de 10h du matin   ", 
"à 3h du matin.                ",
"Seul les personnes munies de droit d’accès   ", 
"et de badge spécifique pourront   ",
"se déplacer dans les rues.                       "
};

String fulltext2[] = {
  "Joséphine n’est plus là. "
};

String fulltext3[] = {
  "... "
};


String fulltext4[] = {
  "STOP         ",
  "Arrêtez de me convoquer !          ",
  "Je ne veux plus.             ",
  "Je ne veux plus être là.          "
};

String fulltext5[] = {
  "Stop"
};

String fulltext6[] = {
  "???"
};


String fulltext[] = fulltext1;

int xpos = 150;
int ypos = 150;
int linewidth = 40;

int line = 0;
int counter = 0;
int wait = 1;

void setup() {
  size(1280,720);
  f = createFont("Virtual DJ",24,true);
//  f = createFont("OCR A Std",24,true);
//  f = createFont("Orator Std",24,true);

  f_glitch = createFont("LOVE-BOX",24,true);
  background(0);
  textAlign(LEFT);
  textFont(f);
  fill(255);
}

void draw() {
    boolean slowframe = false;
    background(0);

    String currentline = fulltext[line];
    int linelength = currentline.length();
      if(counter >= linelength){
      line++;
      counter = 0;
    }
 //   glitch(0);

    for(int i = 0; i < line; ++i){
        text(fulltext[i], xpos, i * linewidth + ypos); 
    } 
    text(currentline.substring(0, counter), xpos, line * linewidth + ypos); 
    println(linelength, counter);

//    if(linelength > counter && currentline.charAt(counter) == ' ') slowframe = true;
    if(counter >= linelength) slowframe = true;
    if(frameCount % wait == 0){
//      if(!slowframe) counter++;
        counter ++;
    }
  saveFrame("output/frame-######.png");
}

void glitch(int i){
  if(i == 3){
   // return;
  }
    if(frameCount == 135 * wait){
      textFont(f_glitch);
    }
    if(frameCount == 150 * wait){
      textFont(f);
    }
 
}