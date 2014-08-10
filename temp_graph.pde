// Graphing sketch
// based on public domain code by Tom Igoe

import processing.serial.*;

Serial myPort;        // The serial port
//initial x pos
int x_0 = 50;
int xPos = x_0;         // horizontal position of the graph
int xPrev = x_0;
int yPrev = -1;

char unit = 'F';

//min and max temperatures (input in C)
int min = ToDisplayUnit(-40);
int max = ToDisplayUnit(60);

PFont f;

//boolean sketchFullScreen() {
//  return true;
//}

void setup () {
  // set the window size:
  size(800, 600);
  //size(displayWidth, displayHeight);  

  // List all the available serial ports
  println(Serial.list());
  // I know that the first port in the serial list on my mac
  // is always my  Arduino, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[0], 9600);
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');
  // set inital background:
  background(0);

  //setup font
  f = createFont("Georgia", 12);
  textFont(f);
}
void draw () {
}

void serialEvent (Serial myPort) {
  DrawAxes();
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');

  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);
    // convert to an int and map to the screen height:
    float inByte = ToDisplayUnit(int(float(inString)+.5));

    f = createFont("Georgia", 40);
    textFont(f);
    String displayTemp = inByte + "\u00b0" + unit;
    stroke(0, 0, 0);
    fill(0, 0, 0);
    rect(width-200, 0, 200, 100);
    stroke(255, 255, 255);
    fill(255, 255, 255);
    textAlign(RIGHT, CENTER);
    text(displayTemp, width-10, 50); 
    println(displayTemp);

    inByte = map(inByte, min, max, 0, height);

    // draw the line:
    stroke(127, 34, 255);
    //line(xPos, height, xPos, height - inByte);
    int yPos = int(height - inByte);
    if (yPrev < 0) {
      point(xPos, height-inByte);
    } else {
      line(xPrev, yPrev, xPos, yPos);
    }
    xPrev = xPos;
    yPrev = yPos;


    // at the edge of the screen, go back to the beginning:
    if (xPos >= width) {
      xPos = 0;
      background(0);
    } else {
      // increment the horizontal position:
      xPos++;
    }
  }
}

int ToDisplayUnit(int degC) {
  return (unit=='C')? degC:int((degC * 1.8 + 32));
}

void DrawAxes() {
  //draw axes
  stroke(127, 34, 255);
  float zeroDegrees = map(0, min, max, 0, height);
  line(x_0-10, height-zeroDegrees, width, height-zeroDegrees);
  line(x_0, 0, x_0, height);

  //label axis
  f = createFont("Georgia", 12);
  textFont(f);
  for (int i = min; i < max; i++) {
    float y = height - map(i, min, max, 0, height);
    if (i%2 == 0) {
      line(x_0, y, x_0-5, y);
    }
    if (i%10 == 0) {
      line(x_0, y, x_0-10, y);
    }
    if (i%20 == 0) {
      String tmpString = i + "\u00b0" + unit;
      textAlign(CENTER, CENTER);
      text(tmpString, x_0/2-5, y);
    }
  }
}

