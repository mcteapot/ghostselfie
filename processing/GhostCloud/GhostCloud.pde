import gifAnimation.*;

import org.openkinect.*;
import org.openkinect.processing.*;

//OBJECTS
PImage imgHashTag00;
PImage imgFrame00;
PImage imgBackground00;
PImage imgPoint00;

PImage imgActiveBack;
PImage imgActivePoint;

// Kinect Library object
Kinect kinect;
GifMaker gifExport;
Timer timerGif;
Timer timerBlink;
Timer timerSwitch;
HTTPClient httpClient;

// Constants
int Y_AXIS = 1;
int X_AXIS = 2;
color backgroundColor01, backgroundColor02, pointColor;

// Variables
float rotateAngle = 0;
float animateDepth = 0;
boolean switchDepth = false;
String url = "http://localhost:3000/ghostselfie";
String tweetUser = "null";

// Size of kinect image
int w = 640;
int h = 480;




// We'll use a lookup table so that we don't have to repeat the math over and over
float[] depthLookUp = new float[2048];

void setup() {
  size(800,600,OPENGL);
   frameRate(12);
  // images loaded]
  imgHashTag00 = loadImage("hashtag.png");
  imgFrame00 = loadImage("ghostframe00.png");
  imgBackground00 = loadImage("background00.png");
  imgPoint00 = loadImage("pointcloud01.png");
  
  // setup gif

  // timers set
  timerGif = new Timer(5000); //5000ms = .5s
  timerBlink = new Timer(50);
  timerSwitch = new Timer(10000);
  
  // setup HTTP Client
  httpClient = new HTTPClient(url);
  
  // variables set 
  backgroundColor01 = color(255, 0, 255);
  backgroundColor02 = color(0, 255, 255);
  pointColor = color(255, 0, 0);
  
  //other 
  setupKinect();
  //drawBackground();
}

void draw() {

  //listenForTweets();
  blinkTimer();
  
  // Background and other stuff
  drawBackground();
  fill(255);
  textMode(SHAPE);
  text("Kinect FR: " + (int)kinect.getDepthFPS() + "\nProcessing FR: " + (int)frameRate,10,16);

  // Get the raw depth as array of integers
  int[] depth = kinect.getRawDepth();

  // We're just going to calculate and draw every 4th pixel (equivalent of 160x120)
  int skip = 4;

  // Translate and rotate
  translate(width/2,height/2,-50);
  rotateY(rotateAngle);
  //rotateX(PI/3);
  //rotateZ(PI/6);

  // Draws point clouds
  for(int x=0; x<w; x+=skip) {
    for(int y=0; y<h; y+=skip) {
      int offset = x+y*w;

      // Convert kinect data to world xyz coordinate
      int rawDepth = depth[offset];
      PVector v = depthToWorld(x,y,rawDepth);

      //stroke(pointColor);
      stroke(imgPoint00.get(x,y));
      pushMatrix();
      // Scale up by 200
      float factor = 600;
      translate(v.x*factor,v.y*factor,factor-v.z*factor);
      // Draw a point
      strokeWeight(2);  // Beastly
      line(0, 0, 10, 10);
      //point(0,0);
      popMatrix();
    }
  }

  // Increent Rotates points
  rotateAngle += 0.015f;
  //animateDepth += 1.0f;
  //println(animateDepth);
  

}


//API FUNCITON

void drawBackground() {
  float backgroundDepth = -2049;
  float backgroundSize = 2500;
  float frameDepth = -2049;
  float frameSize = 400;
  
  float frame00 = -1380;
  float frame01 = 2700;
  
  background(color(255, 255, 0));
  //image(imgBackground, 0, 0, width, height);
  
  //translate(width / 2, height / 2);
  beginShape();
  texture(imgBackground00);
  vertex(-backgroundSize, -backgroundSize, backgroundDepth, 0, 0);
  vertex(backgroundSize, -backgroundSize, backgroundDepth, imgBackground00.width, 0);
  vertex(backgroundSize, backgroundSize, backgroundDepth, imgBackground00.width, imgBackground00.height);
  vertex(-backgroundSize, backgroundSize, backgroundDepth, 0, imgBackground00.height);
  endShape();
  
    //translate(width / 2, height / 2);
  if(!(timerBlink.isActive()) ) {
     beginShape();
     texture(imgHashTag00);
    //println("minus" + (-frame00 + animateDepth));
    //println("plus " + (frame01 + animateDepth));
    vertex(frame00, frame00 + animateDepth, frameDepth, 0, 0);
    vertex(frame01, frame00, frameDepth, imgFrame00.width, 0);
    vertex(frame01, frame01, frameDepth, imgFrame00.width, imgFrame00.height);
    vertex(frame00, frame01, frameDepth, 0, imgFrame00.height);
    endShape();
   }
  
  //setGradient(0, 0, width, height, backgroundColor01, backgroundColor02, X_AXIS);
}


void setupKinect() {
  kinect = new Kinect(this);
  kinect.start();
  kinect.enableDepth(true);
  // We don't need the grayscale image in this example
  // so this makes it more efficient
  kinect.processDepthImage(false);

  // Lookup table for all possible depth values (0 - 2047)
  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i);
  }
}

//HEPER FUNCTION
// These functions come from: http://graphics.stanford.edu/~mdfisher/Kinect.html
float rawDepthToMeters(int depthValue) {
  if (depthValue < 2047) {
    return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
  }
  return 0.0f;
}

PVector depthToWorld(int x, int y, int depthValue) {

  final double fx_d = 1.0 / 5.9421434211923247e+02;
  final double fy_d = 1.0 / 5.9104053696870778e+02;
  final double cx_d = 3.3930780975300314e+02;
  final double cy_d = 2.4273913761751615e+02;

  PVector result = new PVector();
  double depth =  depthLookUp[depthValue];//rawDepthToMeters(depthValue);
  result.x = (float)((x - cx_d) * depth * fx_d);
  result.y = (float)((y - cy_d) * depth * fy_d);
  result.z = (float)(depth);
  return result;
}

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}

void gifCapture() {
    gifExport.setDelay(1);
    gifExport.addFrame();
}

void gifSave() {
    gifExport.finish();
    ArrayList nameValueHeader = new ArrayList();
    nameValueHeader.add(new BasicNameValuePair("User-Agent", tweetUser + ".gif"));
    httpClient.POSTPageHeader(url, nameValueHeader);
    tweetUser = "null";
}


void gifStart() {
    gifExport = new GifMaker(this, "../../img/" + tweetUser + ".gif");
    gifExport.setRepeat(0);             // make it an "endless" animation
    timerGif.start();
}

void listenForTweets() {
  // captures gif when timer is active
  if(timerGif.isActive()) {
    gifCapture();
    if(timerGif.isFinished()) {
      timerGif.stop();
      gifSave();
      println("TIMER FINISHED");
    }
  } else {
    // checks if user is regestred
    tweetUser = httpClient.GETPage(url);
    if(!(tweetUser.equals("null"))) {
      println("USERNAME: " + tweetUser);
      gifStart();
    }
  }
}


void blinkTimer() {
  if(timerBlink.isActive()) {
    if(timerBlink.isFinished()) {
      timerBlink.stop();
    }
  } else {
    timerBlink.start();
  }
}

void switchTimer() {
  if(timerSwitch.isActive()) {
    if(timerSwitch.isFinished()) {
      timerSwitch.stop();
    }
  } else {
    timerSwitch.start();
  }
  
}

void switchImages() {

}


void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      animateDepth = animateDepth + 10;
    } else if (keyCode == DOWN) {
      animateDepth = animateDepth - 10;
    }
  } 
}


void stop() {
  kinect.quit();
  super.stop();
}

