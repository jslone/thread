float dt = 0.05;
int continuity = 4;
color bgcolor = color(100);
int radius = 10;
int waitFrames = 120;
int framesLeft = 0;
int colorDist = 5;
float startSpeed = 10.0;
float deltaTextAlpha = 0.05;


ArrayList<Thread> threads;

void setup() {
  background(bgcolor);
  size(600,400);
  noStroke();
  threads = new ArrayList<Thread>();
  threads.add(new Thread());
  threads.add(new Thread());
}

float posMod(float x, int n) {
  float r = x % n;
  if(r < 0) return n + r;
  return r;
}

boolean sameColor(color c1, color c2) {
  return c1 == c2
    || (abs(red(c1)-red(c2)) < colorDist
    && abs(green(c1)-green(c2)) < colorDist
    && abs(blue(c1)-blue(c2)) < colorDist);
}

void printColor(color c) {
  print(red(c) + "," + green(c) + "," + blue(c) + "\n");
}

void draw() {
  loadPixels();
  for(int i = 0; i < threads.size(); i++) {
    Thread thread = threads.get(i);
    fill(thread.c);
    if(thread.update()) {
      Thread nt = threads.get(threads.size()-1);
      getTweet(red(nt.c) >= blue(nt.c), thread.vs[0].get());
      framesLeft = waitFrames;
    }
    thread.draw();
  }
  framesLeft--;
}

void clamp(Pvector v, float l) {
  if(v.mag() > l) {
    v.normalize();
    v.mult(l);
  }
}

class Thread {
  PVector[] vs;
  color c;

  Thread() {
    vs = new PVector[continuity];
    vs[0] = new PVector(random(width),random(height));
    vs[1] = PVector.random2D();
    vs[1].mult(startSpeed);
    for(int i = 2; i < continuity; i++) {
      vs[i] = new PVector(0,0);
    }
    c = color(random(255),random(255),random(255));
  }

  Thread(PVector v, color c1, color c2) {
    vs = new PVector[continuity];
    vs[0] = v;
    vs[1] = PVector.random2D();
    vs[1].mult(startSpeed);
    for(int i = 2; i < continuity; i++) {
      vs[i] = new PVector(0,0);
    }
    color c3 = color(random(255),random(255),random(255));
    c = color((red(c1)+red(c2)+red(c3))/3,
              (green(c1)+green(c2)+green(c3))/3,
              (blue(c1)+blue(c2)+blue(c3))/3);
  }

  boolean update() {
    vs[0].add(PVector.mult(vs[1],dt));
    vs[0].x = posMod(vs[0].x,width);
    vs[0].y = posMod(vs[0].y,height);
    for(int i = 1; i < continuity - 1; i++) {
      vs[i].add(PVector.mult(vs[i+1],dt));
    }
    clamp(vs[1],radius/(2*dt));
    vs[continuity-1] = PVector.random2D();
    vs[continuity-1].mult(2);

    if(framesLeft <= 0) {
      PVector v = vs[1].get();
      v.normalize();
      v.mult(radius);
      v.add(vs[0]);
      int x = (int)posMod(v.x,width);
      int y = (int)posMod(v.y,height);
      int index = x + width*y;
      if(pixels[index] != c) {
        if(pixels[index] != bgcolor) {
          threads.add(new Thread(v,c,pixels[index]));
          return true;
        }
      }
    }
    return false;
  }

  void draw() {
    ellipse(vs[0].x,vs[0].y,radius,radius);
  }
}
