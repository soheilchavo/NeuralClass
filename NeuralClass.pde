import processing.video.*;

Capture video;


void setup() {
  size(700, 700);
  video = new Capture(this, 320, 240);
  video.start();
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  background(45);
  PFont times = createFont("Georgia", 23);
  
  textSize(36);
  textFont(times);
  text("Live Feed:", 440, 30);
  
  imageMode(CENTER);
  image(video, 490, 170, video.width, video.height);
}
